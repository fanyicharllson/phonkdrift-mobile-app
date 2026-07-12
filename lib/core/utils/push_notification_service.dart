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

  // A push can arrive (via getInitialMessage on a cold start from a tapped
  // notification) before HomeScreen exists to subscribe to the stream above —
  // broadcast streams don't replay, so that event would otherwise be lost.
  // These buffers let a late subscriber catch up once.
  TrendingPushPayload? _pendingTrending;
  bool _pendingProfileUpdated = false;

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
      final payload = TrendingPushPayload(trackId: isBatch ? null : id);
      _pendingTrending = payload;
      _trendingController.add(payload);
    } else if (type == 'profile_updated') {
      _pendingProfileUpdated = true;
      _profileUpdatedController.add(null);
    }
  }

  /// Call once, right after subscribing to [onTrendingPush], to pick up a
  /// push that arrived before the listener existed (e.g. cold start via a
  /// tapped notification). Returns null if there's nothing pending.
  TrendingPushPayload? consumePendingTrending() {
    final pending = _pendingTrending;
    _pendingTrending = null;
    return pending;
  }

  /// Same idea as [consumePendingTrending], for the profile-updated push.
  bool consumePendingProfileUpdated() {
    final pending = _pendingProfileUpdated;
    _pendingProfileUpdated = false;
    return pending;
  }
}
