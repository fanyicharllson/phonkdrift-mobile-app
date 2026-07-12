import 'package:grpc/grpc.dart';
import '../../../../core/network/grpc_client.dart';
import '../../../../core/network/generated/track.pb.dart';
import '../../../../core/utils/storage_helper.dart';

class ResolvedPlaybackUrl {
  const ResolvedPlaybackUrl({
    required this.url,
    required this.linkExpiresAtEpochSeconds,
    required this.fromStorage,
  });

  final String url;
  final int linkExpiresAtEpochSeconds;
  final bool fromStorage;

  bool get isTemporary => !fromStorage;
}

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
  final Map<String, StreamResponse> _streamCache = {};

  // ── Auth options helper — token attached to every track call ───────────────
  Future<CallOptions> _authOptions() async {
    final token = await _storage.getToken() ?? '';
    return _client.authCallOptions(token);
  }

  // ── Get For You / Trending tracks ─────────────────────────────────────────
  Future<List<TrackMetadata>> getForYouTracks({int limit = 20}) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      final opts = await _authOptions();
      final res = await _client.track.getForYou(
        ForYouRequest(userId: userId, limit: limit),
        options: opts,
      );
      return res.tracks;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    }
  }

  // ── Search tracks ──────────────────────────────────────────────────────────
  Future<List<TrackMetadata>> searchTracks({
    required String query,
    int page = 0,
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

  // ── Resolve playable URL (storage first, fallback to temporary stream) ────
  Future<ResolvedPlaybackUrl> resolvePlaybackUrl(TrackMetadata track) async {
    final storageUrl = track.storageUrl.trim();
    if (storageUrl.isNotEmpty) {
      return ResolvedPlaybackUrl(
        url: storageUrl,
        linkExpiresAtEpochSeconds: 0,
        fromStorage: true,
      );
    }

    final nowEpochSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final key = '${track.trackId}|${track.originalYoutubeId}';
    final cached = _streamCache[key];

    if (cached != null &&
        cached.streamUrl.isNotEmpty &&
        cached.linkExpiresAt.toInt() > nowEpochSeconds + 5) {
      return ResolvedPlaybackUrl(
        url: cached.streamUrl,
        linkExpiresAtEpochSeconds: cached.linkExpiresAt.toInt(),
        fromStorage: false,
      );
    }

    final fetched = await getStreamUrl(track);
    if (fetched.streamUrl.isEmpty) {
      throw const TrackException('Empty stream URL from server.');
    }

    if (fetched.linkExpiresAt.toInt() > nowEpochSeconds) {
      _streamCache[key] = fetched;
    }

    return ResolvedPlaybackUrl(
      url: fetched.streamUrl,
      linkExpiresAtEpochSeconds: fetched.linkExpiresAt.toInt(),
      fromStorage: false,
    );
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
        InteractionRequest(userId: userId, trackId: trackId, isLiked: isLiked),
        options: options,
      );
      return res.success;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    }
  }

  // ── Liked tracks ────────────────────────────────────────────────────────────
  Future<List<TrackMetadata>> getLikedTracks({int page = 0, int limit = 50}) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      if (userId.isEmpty) return [];

      final options = await _authOptions();
      final res = await _client.track.getLikedTracks(
        GetLikedTracksRequest(userId: userId, limit: limit, page: page),
        options: options,
      );
      return res.tracks;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    }
  }

  // ── User playlists ─────────────────────────────────────────────────────────
  Future<List<PlaylistSummary>> getUserPlaylists() async {
    try {
      final userId = await _storage.getUserId() ?? '';
      if (userId.isEmpty) return [];

      final options = await _authOptions();
      final res = await _client.track.getUserPlaylists(
        GetUserPlaylistsRequest(userId: userId),
        options: options,
      );
      return res.playlists;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    }
  }

  // ── Get single playlist (with tracks) ──────────────────────────────────────
  Future<GetPlaylistResponse> getPlaylist(String playlistId) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      final options = await _authOptions();
      return await _client.track.getPlaylist(
        GetPlaylistRequest(playlistId: playlistId, userId: userId),
        options: options,
      );
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
      final userId = await _storage.getUserId() ?? '';
      final options = await _authOptions();
      final res = await _client.track.addToPlaylist(
        PlaylistTrackRequest(
          playlistId: playlistId,
          trackId: trackId,
          userId: userId,
        ),
        options: options,
      );
      return res.success;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    }
  }

  // ── Remove track from playlist ─────────────────────────────────────────────
  Future<bool> removeTrackFromPlaylist({
    required String playlistId,
    required String trackId,
  }) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      final options = await _authOptions();
      final res = await _client.track.removeTrackFromPlaylist(
        PlaylistTrackRequest(
          playlistId: playlistId,
          trackId: trackId,
          userId: userId,
        ),
        options: options,
      );
      return res.success;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMessage(e));
    }
  }

  // ── Delete playlist ─────────────────────────────────────────────────────────
  Future<bool> deletePlaylist(String playlistId) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      final options = await _authOptions();
      final res = await _client.track.deletePlaylist(
        DeletePlaylistRequest(playlistId: playlistId, userId: userId),
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
