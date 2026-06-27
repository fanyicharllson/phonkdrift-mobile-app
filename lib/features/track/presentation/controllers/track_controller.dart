import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../data/repositories/track_repository.dart';

enum TrackLoadState { idle, loading, loaded, error }

class TrackController extends ChangeNotifier {
  final _repo = TrackRepository.instance;
  final _player = AudioPlayer();

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
      }
    });
  }

  // ── Telemetry sync every 10s ───────────────────────────────────────────────
  void _startTelemetrySync() {
    _telemetryTimer?.cancel();
    _telemetryTimer = Timer.periodic(const Duration(seconds: 10), (_) {
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
  }

  // ── Play track ─────────────────────────────────────────────────────────────
  Future<void> playTrack(TrackMetadata track, BuildContext context) async {
    _playError = '';

    // If same track — toggle play/pause
    if (_nowPlaying?.trackId == track.trackId) {
      _isPlaying ? await _player.pause() : await _player.play();
      notifyListeners();
      return;
    }

    _nowPlaying = track;
    _isLoadingStream = true;
    _position = Duration.zero;
    _duration = Duration.zero;
    notifyListeners();

    try {
      final streamUrl = await _repo.getStreamUrl(track);
      _isLoadingStream = false;
      notifyListeners();

      // Strategy 1: Try playing directly in-app with just_audio
      if (streamUrl.isNotEmpty && !_isYouTubeUrl(streamUrl)) {
        try {
          await _player.setUrl(streamUrl);
          await _player.play();
          return;
        } catch (_) {
          // Stream URL failed — fall through to YouTube
        }
      }

      // Strategy 2: YouTube deep link
      if (track.originalYoutubeId.isNotEmpty) {
        final openedYouTube = await _openYouTube(track.originalYoutubeId);
        if (openedYouTube) return;
      }

      // Strategy 3: Open stream URL in browser
      if (streamUrl.isNotEmpty) {
        final uri = Uri.parse(streamUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      _playError =
          'Could not play "${track.title}". Tap the track options (⋮) to open in YouTube manually.';
      _nowPlaying = null;
      notifyListeners();
    } catch (e) {
      _isLoadingStream = false;
      _playError =
          'Could not play "${track.title}". Tap the track options (⋮) to open in YouTube manually.';
      notifyListeners();
    }
  }

  Future<bool> _openYouTube(String youtubeId) async {
    final ytApp = Uri.parse('vnd.youtube:$youtubeId');
    final ytWeb = Uri.parse('https://www.youtube.com/watch?v=$youtubeId');

    if (await canLaunchUrl(ytApp)) {
      await launchUrl(ytApp);
      return true;
    } else if (await canLaunchUrl(ytWeb)) {
      await launchUrl(ytWeb, mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }

  bool _isYouTubeUrl(String url) =>
      url.contains('youtube.com') || url.contains('youtu.be');

  // ── Playback controls ──────────────────────────────────────────────────────
  Future<void> togglePlayPause() async {
    _isPlaying ? await _player.pause() : await _player.play();
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

  @override
  void dispose() {
    _stopTelemetrySync();
    _player.dispose();
    super.dispose();
  }
}
