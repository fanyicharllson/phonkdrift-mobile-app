import 'dart:async';

import 'package:flutter/material.dart';

import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/screens/banned_screen.dart';

class AccountBanMonitor extends StatefulWidget {
  const AccountBanMonitor({
    super.key,
    required this.navigatorKey,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  State<AccountBanMonitor> createState() => _AccountBanMonitorState();
}

class _AccountBanMonitorState extends State<AccountBanMonitor>
    with WidgetsBindingObserver {
  static const Duration _pollInterval = Duration(minutes: 1);

  Timer? _timer;
  bool _isChecking = false;
  bool _isRedirectingToBan = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkBanStatus());
    _timer = Timer.periodic(_pollInterval, (_) => _checkBanStatus());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkBanStatus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkBanStatus() async {
    if (_isChecking) return;
    _isChecking = true;

    try {
      final isLoggedIn = await AuthRepository.instance.isLoggedIn();
      if (!mounted) return;

      if (!isLoggedIn) {
        _isRedirectingToBan = false;
        return;
      }

      final banStatus = await AuthRepository.instance.checkBanStatus();
      if (!mounted) return;

      if (!banStatus.isBanned) {
        _isRedirectingToBan = false;
        return;
      }

      if (_isRedirectingToBan) {
        return;
      }

      final navigator = widget.navigatorKey.currentState;
      if (navigator == null) return;

      _isRedirectingToBan = true;
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => BannedScreen(reason: banStatus.reason),
        ),
        (_) => false,
      );
    } catch (_) {
      // Keep the current session visible if the ban check cannot reach the server.
    } finally {
      _isChecking = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
