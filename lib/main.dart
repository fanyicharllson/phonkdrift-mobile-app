import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'core/constants/app_theme.dart';
import 'core/navigation/app_navigator.dart';
import 'core/network/grpc_client.dart';
import 'core/utils/push_notification_service.dart';
import 'core/widgets/account_ban_monitor.dart';
import 'features/auth/presentation/screens/router_screen.dart';

/// Runs in a separate isolate — keep it top-level and dependency-free.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  PushNotificationService.instance.handlePush(message.data);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // These three must complete before the UI can start.
  await Future.wait([
    Firebase.initializeApp(),
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
    JustAudioBackground.init(
      androidNotificationChannelId: 'com.phonkdrift.phonkdrift_mobile.audio',
      androidNotificationChannelName: 'Playback',
      androidNotificationIcon: 'drawable/ic_notification',
      androidNotificationOngoing: true,
    ),
  ]);

  // Transparent status bar — synchronous, no await needed.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Boot gRPC channels — synchronous.
  PhonkGrpcClient.instance.init();

  // Register background FCM handler — must be before runApp.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(
    (msg) => PushNotificationService.instance.handlePush(msg.data),
  );
  // Tapped while app was backgrounded.
  FirebaseMessaging.onMessageOpenedApp.listen(
    (msg) => PushNotificationService.instance.handlePush(msg.data),
  );

  // Get the app on screen immediately.
  runApp(const PhonkDriftApp());

  // Tapped from killed state — check after first frame so navigatorKey is ready.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      PushNotificationService.instance.handlePush(initial.data);
    }
  });

  // Defer permission prompt — doesn't block launch at all.
  FirebaseMessaging.instance.requestPermission();
}

class PhonkDriftApp extends StatelessWidget {
  const PhonkDriftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhonkDrift',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigator.key,
      builder: (context, child) => AccountBanMonitor(
        navigatorKey: AppNavigator.key,
        child: child ?? const SizedBox.shrink(),
      ),
      theme: AppTheme.darkTheme,
      home: const RouterScreen(),
    );
  }
}
