import 'dart:async';
import 'package:flutter/foundation.dart';

/// The full set of push data.type values the backend can send. [unknown]
/// is the required fallback for any type this build doesn't recognize yet —
/// new types get added here as features ship, never crash on an old build.
enum PushEventType {
  trendingTrack, // data.type "trending", real track id
  trendingBatch, // data.type "trending", id empty or "trending_batch"
  engagement, // data.type "engagement", track id
  profileUpdated, // data.type "profile_updated"
  chatMessage, // data.type "chat_message"
  chatReply, // data.type "chat_reply"
  communityJoin, // data.type "community_join"
  announcement, // data.type empty — admin manual broadcast
  unknown, // anything not recognized above
}

class PushEvent {
  const PushEvent({required this.type, this.id = ''});
  final PushEventType type;
  final String id;
}

/// Lightweight bus for FCM push events that need to reach UI widgets.
///
/// Splits pushes into two streams because they mean very different things:
/// - [onPushTapped]: the user explicitly tapped a notification (app was
///   backgrounded or fully killed). Safe — expected, even — to navigate on.
/// - [onPushReceived]: a push arrived while the app was already open, with
///   no tap at all. Never drives navigation (that would yank the user away
///   from whatever they were doing); only used for quiet side effects like
///   silently refreshing profile data.
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final _tappedController = StreamController<PushEvent>.broadcast();
  final _receivedController = StreamController<PushEvent>.broadcast();
  final _profileUpdatedController = StreamController<void>.broadcast();

  // A tap can arrive (via getInitialMessage on a cold start) before
  // HomeScreen exists to subscribe — broadcast streams don't replay, so
  // this buffer lets a late subscriber catch up once.
  PushEvent? _pendingTappedEvent;

  Stream<PushEvent> get onPushTapped => _tappedController.stream;
  Stream<PushEvent> get onPushReceived => _receivedController.stream;

  /// Profile refresh doesn't care whether the push was tapped or just
  /// received while the app was open — either way there's fresh data to
  /// pull, and it's non-navigational so there's no "only on tap" concern.
  Stream<void> get onProfileUpdated => _profileUpdatedController.stream;

  /// Call from FirebaseMessaging.onMessage — push arrived, app already open.
  void handleForegroundPush(Map<String, dynamic> data) {
    final event = _parse(data);
    _receivedController.add(event);
    if (event.type == PushEventType.profileUpdated) {
      _profileUpdatedController.add(null);
    }
  }

  /// Call from FirebaseMessaging.onMessageOpenedApp / getInitialMessage —
  /// the user tapped the notification.
  void handleTappedPush(Map<String, dynamic> data) {
    final event = _parse(data);
    _pendingTappedEvent = event;
    _tappedController.add(event);
    if (event.type == PushEventType.profileUpdated) {
      _profileUpdatedController.add(null);
    }
  }

  /// Call once, right after subscribing to [onPushTapped], to pick up a tap
  /// that arrived before the listener existed (e.g. cold start).
  PushEvent? consumePendingTappedEvent() {
    final pending = _pendingTappedEvent;
    _pendingTappedEvent = null;
    return pending;
  }

  PushEvent _parse(Map<String, dynamic> data) {
    final rawType = (data['type'] as String? ?? '').trim();
    final id = (data['id'] as String? ?? '').trim();

    switch (rawType) {
      case 'trending':
        final isBatch = id.isEmpty || id == 'trending_batch';
        return isBatch
            ? const PushEvent(type: PushEventType.trendingBatch)
            : PushEvent(type: PushEventType.trendingTrack, id: id);
      case 'engagement':
        return PushEvent(type: PushEventType.engagement, id: id);
      case 'profile_updated':
        return const PushEvent(type: PushEventType.profileUpdated);
      case 'chat_message':
        return PushEvent(type: PushEventType.chatMessage, id: id);
      case 'chat_reply':
        return PushEvent(type: PushEventType.chatReply, id: id);
      case 'community_join':
        return PushEvent(type: PushEventType.communityJoin, id: id);
      case '':
        return const PushEvent(type: PushEventType.announcement);
      default:
        // New type we don't handle yet — never crash, never navigate, but
        // make it visible in logs so it doesn't just vanish unnoticed.
        debugPrint('PushNotificationService: unhandled data.type "$rawType"');
        return const PushEvent(type: PushEventType.unknown);
    }
  }
}
