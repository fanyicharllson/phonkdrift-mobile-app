import 'dart:async';

/// Payload emitted for a 'trending' push.
/// [trackId] is null when type is 'trending_batch' (navigate to trending list).
class TrendingPushPayload {
  const TrendingPushPayload({this.trackId});
  final String? trackId;
}

/// Lightweight bus for FCM push events that need to reach UI widgets.
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final _trendingController = StreamController<TrendingPushPayload>.broadcast();
  final _profileUpdatedController = StreamController<void>.broadcast();

  /// Emits when a 'trending' or 'trending_batch' push arrives.
  Stream<TrendingPushPayload> get onTrendingPush => _trendingController.stream;

  /// Emits when a 'profile_updated' push arrives.
  Stream<void> get onProfileUpdated => _profileUpdatedController.stream;

  void handlePush(Map<String, dynamic> data) {
    final type = data['type'] as String? ?? '';
    if (type == 'trending') {
      final id = data['id'] as String? ?? '';
      // 'trending_batch' id or empty → go to trending list, not a specific track.
      final isBatch = id.isEmpty || id == 'trending_batch';
      _trendingController.add(TrendingPushPayload(trackId: isBatch ? null : id));
    } else if (type == 'profile_updated') {
      _profileUpdatedController.add(null);
    }
  }
}
