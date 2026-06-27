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

  Future<CallOptions> get _authOptions async {
    final token = await _storage.getToken() ?? '';
    return _client.authCallOptions(token);
  }

  /// Workaround: search "phonk" to populate For You section
  Future<List<TrackMetadata>> getForYouTracks({int page = 1}) async {
    try {
      final res = await _client.track.searchTrack(
        SearchRequest(query: 'phonk', page: page),
      );
      return res.tracks;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMsg(e));
    }
  }

  Future<List<TrackMetadata>> searchTracks(String query, {int page = 1}) async {
    try {
      final res = await _client.track.searchTrack(
        SearchRequest(query: query, page: page),
      );
      return res.tracks;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMsg(e));
    }
  }

  Future<List<TrackMetadata>> getRecentlyPlayed({int limit = 10}) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      if (userId.isEmpty) return [];
      final opts = await _authOptions;
      final res = await _client.track.getRecentlyPlayed(
        RecentlyPlayedRequest(userId: userId, limit: limit),
        options: opts,
      );
      return res.tracks;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMsg(e));
    }
  }

  Future<String> getStreamUrl(TrackMetadata track) async {
    try {
      final res = await _client.track.getStreamURL(
        StreamRequest(
          trackId: track.trackId,
          originalYoutubeId: track.originalYoutubeId,
        ),
      );
      return res.streamUrl;
    } on GrpcError catch (e) {
      throw TrackException(_grpcMsg(e));
    }
  }

  Future<void> syncTelemetry({
    required String trackId,
    required int positionSeconds,
    required bool isCompleted,
  }) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      if (userId.isEmpty) return;
      final opts = await _authOptions;
      await _client.track.syncPlaybackTelemetry(
        PlaybackTelemetryRequest(
          userId: userId,
          trackId: trackId,
          lastPositionSeconds: positionSeconds,
          isCompleted: isCompleted,
        ),
        options: opts,
      );
    } catch (_) {
      // Telemetry is fire-and-forget — never crash for this
    }
  }

  String _grpcMsg(GrpcError e) =>
      e.message?.isNotEmpty == true ? e.message! : 'Something went wrong';
}
