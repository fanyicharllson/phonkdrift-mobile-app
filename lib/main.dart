import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'core/constants/app_theme.dart';
import 'core/network/grpc_client.dart';
import 'core/widgets/account_ban_monitor.dart';
import 'features/auth/presentation/screens/router_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Now-playing notification (status bar + lock screen controls)
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.phonkdrift.phonkdrift_mobile.audio',
    androidNotificationChannelName: 'Playback',
    androidNotificationIcon: 'drawable/ic_notification',
    androidNotificationOngoing: true,
  );

  // Boot gRPC channels
  PhonkGrpcClient.instance.init();

  runApp(const PhonkDriftApp());
}

class PhonkDriftApp extends StatelessWidget {
  const PhonkDriftApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhonkDrift',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      builder: (context, child) => AccountBanMonitor(
        navigatorKey: navigatorKey,
        child: child ?? const SizedBox.shrink(),
      ),
      theme: AppTheme.darkTheme,
      home: const RouterScreen(),
    );
  }
}
