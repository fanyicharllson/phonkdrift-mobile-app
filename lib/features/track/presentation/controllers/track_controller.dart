import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../auth/presentation/screens/banned_screen.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../data/repositories/track_repository.dart';

enum TrackLoadState { idle, loading, loaded, error }

class TrackController extends ChangeNotifier {
  final _repo = TrackRepository.instance;
  final _player = AudioPlayer();
  final Set<String> _likedTrackIds = {};
  Set<String> get likedTrackIds => _likedTrackIds;

  bool isLiked(String trackId) => _likedTrackIds.contains(trackId);

  // ── Telemetry sync timer ───────────────────────────────────────────────────
  Timer? _telemetryTimer;

  // ── For You ────────────────────────────────────────────────────────────────
  List<TrackMetadata> _forYouTracks = [];
  TrackLoadState _forYouState = TrackLoadState.idle;
  String _forYouError = '';

  List<TrackMetadata> get forYouTracks => _forYouTracks;
  TrackLoadState get forYouState => _forYouState;
  String get forYouError => _forYouError;

  // ── Recently Played ────────────────────────────────────────────────────────
  List<TrackMetadata> _recentTracks = [];
  TrackLoadState _recentState = TrackLoadState.idle;

  List<TrackMetadata> get recentTracks => _recentTracks;
  TrackLoadState get recentState => _recentState;

  // ── Search ────────────────────────────────────────────────────────────────
  List<TrackMetadata> _searchTracks = [];
  TrackLoadState _searchState = TrackLoadState.idle;
  String _searchError = '';
  int _searchPage = 0;
  String _lastSearchQuery = '';

  List<TrackMetadata> get searchTracks => _searchTracks;
  TrackLoadState get searchState => _searchState;
  String get searchError => _searchError;

  // ── Now Playing ────────────────────────────────────────────────────────────
  TrackMetadata? _nowPlaying;
  bool _isLoadingStream = false;
  bool _isPlaying = false;
  String _playError = '';
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  TrackMetadata? get nowPlaying => _nowPlaying;
  bool get isLoadingStream => _isLoadingStream;
  bool get hasNowPlaying => _nowPlaying != null;
  bool get isPlaying => _isPlaying;
  String get playError => _playError;
  Duration get position => _position;
  Duration get duration => _duration;
  AudioPlayer get player => _player;

  // ── Queue (drives auto-play-next) ──────────────────────────────────────────
  List<TrackMetadata> _queue = [];
  int _queueIndex = -1;

  bool get hasNext => _queueIndex >= 0 && _queueIndex + 1 < _queue.length;
  bool get hasPrevious => _queueIndex > 0;

  TrackController() {
    _initAudioSession();
    _listenToPlayer();
  }

  // ── Audio session (handles interruptions) ─────────────────────────────────
  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Pause on interruption (calls, other apps)
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        _player.pause();
      } else {
        if (event.type == AudioInterruptionType.pause ||
            event.type == AudioInterruptionType.duck) {
          _player.play();
        }
      }
    });

    // Pause on headphone disconnect
    session.becomingNoisyEventStream.listen((_) => _player.pause());
  }

  // ── Listen to player state ─────────────────────────────────────────────────
  void _listenToPlayer() {
    _player.playingStream.listen((playing) {
      _isPlaying = playing;
      notifyListeners();
      if (playing) {
        _startTelemetrySync();
      } else {
        _stopTelemetrySync();
      }
    });

    _player.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _player.durationStream.listen((dur) {
      if (dur != null) {
        _duration = dur;
        notifyListeners();
      }
    });

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _onTrackCompleted();
      } else if (state.processingState == ProcessingState.idle &&
          _nowPlaying != null &&
          !_isLoadingStream) {
        // Source dropped out from under us (e.g. expired/broken stream link)
        // — don't leave the UI stuck showing a "pause" icon over silence.
        _isPlaying = false;
        notifyListeners();
      }
    });
  }

  // ── Telemetry sync every 30s ───────────────────────────────────────────────
  void _startTelemetrySync() {
    _telemetryTimer?.cancel();
    _telemetryTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_nowPlaying != null) {
        _repo.syncTelemetry(
          trackId: _nowPlaying!.trackId,
          positionSeconds: _position.inSeconds,
          isCompleted: false,
        );
      }
    });
  }

  void _stopTelemetrySync() {
    _telemetryTimer?.cancel();
  }

  void _onTrackCompleted() {
    if (_nowPlaying != null) {
      // Fire completed telemetry
      _repo.syncTelemetry(
        trackId: _nowPlaying!.trackId,
        positionSeconds: _duration.inSeconds,
        isCompleted: true,
      );
    }
    _isPlaying = false;
    notifyListeners();
    // Reload recently played after completion
    loadRecentlyPlayed();

    if (hasNext) {
      playNext();
    }
  }

  // TikTok-style like — instant optimistic toggle
  Future<void> toggleLike(String trackId) async {
    final wasLiked = _likedTrackIds.contains(trackId);
    // Optimistic update — update UI instantly
    if (wasLiked) {
      _likedTrackIds.remove(trackId);
    } else {
      _likedTrackIds.add(trackId);
    }
    notifyListeners();

    // Sync to backend
    try {
      final success = await _repo.setTrackInteraction(
        trackId: trackId,
        isLiked: !wasLiked,
      );
      if (!success) {
        // Revert if backend rejected
        if (wasLiked) {
          _likedTrackIds.add(trackId);
        } else {
          _likedTrackIds.remove(trackId);
        }
        notifyListeners();
      }
    } catch (_) {
      // Revert on error
      if (wasLiked) {
        _likedTrackIds.add(trackId);
      } else {
        _likedTrackIds.remove(trackId);
      }
      notifyListeners();
    }
  }

  // ── Play track ─────────────────────────────────────────────────────────────
  /// [queue] is the list this track was tapped from (ForYou, search results,
  /// a playlist, ...) — it drives auto-play-next when the track finishes.
  /// Defaults to a single-track queue when omitted.
  Future<void> playTrack(
    TrackMetadata track,
    BuildContext context, {
    List<TrackMetadata>? queue,
  }) async {
    _playError = '';

    // If same track — toggle play/pause
    if (_nowPlaying?.trackId == track.trackId) {
      if (_isPlaying) {
        await _player.pause();
      } else {
        await _player.play();
      }
      _isPlaying = _player.playing;
      notifyListeners();
      return;
    }

    // Always enforce ban check before starting a new track.
    final allowed = await _ensurePlaybackAllowed(context);
    if (!allowed) return;

    final resolvedQueue = queue ?? [track];
    final idx = resolvedQueue.indexWhere((t) => t.trackId == track.trackId);
    _queue = resolvedQueue;
    _queueIndex = idx >= 0 ? idx : 0;

    await _playFromSource(track);
  }

  Future<void> playNext() async {
    if (!hasNext) return;
    final allowed = await _ensurePlaybackAllowed(AppNavigator.context);
    if (!allowed) return;
    _queueIndex++;
    await _playFromSource(_queue[_queueIndex]);
  }

  Future<void> playPrevious() async {
    if (!hasPrevious) return;
    final allowed = await _ensurePlaybackAllowed(AppNavigator.context);
    if (!allowed) return;
    _queueIndex--;
    await _playFromSource(_queue[_queueIndex]);
  }

  Future<void> _playFromSource(TrackMetadata track) async {
    _nowPlaying = track;
    _isLoadingStream = true;
    _isPlaying = false;
    _position = Duration.zero;
    _duration = Duration.zero;
    notifyListeners();

    try {
      final resolved = await _repo.resolvePlaybackUrl(track);
      final streamUrl = resolved.url;
      _isLoadingStream = false;
      notifyListeners();

      if (streamUrl.isEmpty) {
        throw const TrackException('Playback URL is empty.');
      }

      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(streamUrl),
          tag: MediaItem(
            id: track.trackId,
            album: 'PhonkDrift',
            title: track.title,
            artist: track.artistName,
            artUri: track.thumbnailUrl.isNotEmpty
                ? Uri.tryParse(track.thumbnailUrl)
                : null,
          ),
        ),
      );
      await _player.play();
      _isPlaying = _player.playing;
      notifyListeners();
    } catch (e) {
      _isLoadingStream = false;
      _isPlaying = false;
      _nowPlaying = null;
      _playError = 'Could not play "${track.title}". Please try again.';
      notifyListeners();
    }
  }

  Future<bool> _ensurePlaybackAllowed(BuildContext? context) async {
    try {
      final banStatus = await AuthRepository.instance.checkBanStatus();
      if (!banStatus.isBanned) return true;

      await _player.stop();
      _stopTelemetrySync();
      _nowPlaying = null;
      _isPlaying = false;
      _isLoadingStream = false;
      notifyListeners();

      if (context == null || !context.mounted) return false;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => BannedScreen(reason: banStatus.reason),
        ),
        (_) => false,
      );
      return false;
    } catch (_) {
      // Ban check failures are soft-fail so playback can continue.
      return true;
    }
  }

  // ── Playback controls ──────────────────────────────────────────────────────
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
    _isPlaying = _player.playing;
    notifyListeners();
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  void clearNowPlaying() {
    _player.stop();
    _stopTelemetrySync();
    _nowPlaying = null;
    _isPlaying = false;
    _position = Duration.zero;
    _duration = Duration.zero;
    _queue = [];
    _queueIndex = -1;
    notifyListeners();
  }

  // ── Load data ──────────────────────────────────────────────────────────────
  Future<void> loadForYou() async {
    if (_forYouState == TrackLoadState.loading) return;
    _forYouState = TrackLoadState.loading;
    _forYouError = '';
    notifyListeners();
    try {
      _forYouTracks = await _repo.getForYouTracks();
      _forYouState = TrackLoadState.loaded;
    } catch (e) {
      _forYouError = e.toString();
      debugPrint('FOR_YOU_ERROR: $_forYouError'); 
      _forYouState = TrackLoadState.error;
    }
    notifyListeners();
  }

  Future<void> loadRecentlyPlayed() async {
    if (_recentState == TrackLoadState.loading) return;
    _recentState = TrackLoadState.loading;
    notifyListeners();
    try {
      _recentTracks = await _repo.getRecentlyPlayed();
      _recentState = TrackLoadState.loaded;
    } catch (_) {
      _recentState = TrackLoadState.error;
    }
    notifyListeners();
  }

  Future<void> loadHomeData() async {
    await Future.wait([loadForYou(), loadRecentlyPlayed()]);
  }

  Future<void> search(String query, {bool loadMore = false}) async {
    final normalized = query.trim();

    if (normalized.isEmpty) {
      _searchTracks = [];
      _searchState = TrackLoadState.idle;
      _searchError = '';
      _searchPage = 0;
      _lastSearchQuery = '';
      notifyListeners();
      return;
    }

    if (!loadMore || _lastSearchQuery != normalized) {
      _searchPage = 0;
      _searchTracks = [];
    }

    _lastSearchQuery = normalized;
    _searchState = TrackLoadState.loading;
    _searchError = '';
    notifyListeners();

    try {
      final next = await _repo.searchTracks(
        query: normalized,
        page: _searchPage,
      );
      if (loadMore && _searchPage > 0) {
        _searchTracks = [..._searchTracks, ...next];
      } else {
        _searchTracks = next;
      }
      if (next.isNotEmpty) {
        _searchPage += 1;
      }
      _searchState = TrackLoadState.loaded;
    } catch (e) {
      _searchError = e.toString();
      _searchState = TrackLoadState.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTelemetrySync();
    _player.dispose();
    super.dispose();
  }
}
