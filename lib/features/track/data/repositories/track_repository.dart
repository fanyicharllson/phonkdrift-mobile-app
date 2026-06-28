import 'package:grpc/grpc.dart';
import '../../../../core/network/grpc_client.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../../../core/utils/storage_helper.dart';

class TrackException implements Exception {
  const TrackException(this.message);
  final String message;
  @override
  String toString() => message;
}

class TrackRepository {
  TrackRepository._();
  static final TrackRepository instance = TrackRepository._();

  final _client = PhonkGrpcClient.instance;
  final _storage = StorageHelper.instance;

  // ── Auth options helper — token attached to every track call ───────────────
  Future<CallOptions> _authOptions() async {
    final token = await _storage.getToken() ?? '';
    return _client.authCallOptions(token);
  }

  // ── Get For You / Trending tracks ─────────────────────────────────────────
  Future<List<TrackMetadata>> getForYouTracks({int limit = 20}) async {
    try {
      final options = await _authOptions();
      final res = await _client.track.getTrendingTracks(
        TrendingRequest(limit: limit),
        options: options,
      );
      return res.tracks;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    } catch (e) {
      throw TrackException('Could not load tracks. Try again.');
    }
  }

  // ── Search tracks ──────────────────────────────────────────────────────────
  Future<List<TrackMetadata>> searchTracks({
    required String query,
    int page = 1,
  }) async {
    try {
      final options = await _authOptions();
      final res = await _client.track.searchTrack(
        SearchRequest(query: query, page: page),
        options: options,
      );
      return res.tracks;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    } catch (e) {
      throw TrackException('Search failed. Try again.');
    }
  }

  // ── Get stream URL ─────────────────────────────────────────────────────────
  Future<StreamResponse> getStreamUrl(TrackMetadata track) async {
    try {
      final options = await _authOptions();
      final res = await _client.track.getStreamURL(
        StreamRequest(
          trackId: track.trackId,
          originalYoutubeId: track.originalYoutubeId,
        ),
        options: options,
      );
      return res;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    } catch (e) {
      throw TrackException('Could not get stream. Try again.');
    }
  }

  // ── Recently played ────────────────────────────────────────────────────────
  Future<List<TrackMetadata>> getRecentlyPlayed({int limit = 20}) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      if (userId.isEmpty) return [];

      final options = await _authOptions();
      final res = await _client.track.getRecentlyPlayed(
        RecentlyPlayedRequest(userId: userId, limit: limit),
        options: options,
      );
      return res.tracks;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    } catch (e) {
      throw TrackException('Could not load history.');
    }
  }

  // ── Sync playback telemetry ────────────────────────────────────────────────
  Future<void> syncTelemetry({
    required String trackId,
    required int positionSeconds,
    required bool isCompleted,
  }) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      if (userId.isEmpty) return;

      final options = await _authOptions();
      await _client.track.syncPlaybackTelemetry(
        PlaybackTelemetryRequest(
          userId: userId,
          trackId: trackId,
          lastPositionSeconds: positionSeconds,
          isCompleted: isCompleted,
        ),
        options: options,
      );
    } catch (_) {
      // Telemetry failures are silent — never block playback
    }
  }

  // ── Like / dislike track ───────────────────────────────────────────────────
  Future<bool> setTrackInteraction({
    required String trackId,
    required bool isLiked,
  }) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      if (userId.isEmpty) return false;

      final options = await _authOptions();
      final res = await _client.track.setTrackInteraction(
        InteractionRequest(
          userId: userId,
          trackId: trackId,
          isLiked: isLiked,
        ),
        options: options,
      );
      return res.success;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    }
  }

  // ── Create playlist ────────────────────────────────────────────────────────
  Future<PlaylistResponse> createPlaylist({
    required String name,
    String coverImageUrl = '',
  }) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      final options = await _authOptions();
      return await _client.track.createPlaylist(
        CreatePlaylistRequest(
          userId: userId,
          name: name,
          coverImageUrl: coverImageUrl,
        ),
        options: options,
      );
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    }
  }

  // ── Add to playlist ────────────────────────────────────────────────────────
  Future<bool> addToPlaylist({
    required String playlistId,
    required String trackId,
  }) async {
    try {
      final options = await _authOptions();
      final res = await _client.track.addToPlaylist(
        PlaylistTrackRequest(playlistId: playlistId, trackId: trackId),
        options: options,
      );
      return res.success;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    }
  }

  String _grpcMessage(GrpcError e) =>
      e.message?.isNotEmpty == true ? e.message! : 'Something went wrong';
}