import 'package:flutter/material.dart';

/// Global navigator access for code that runs without a BuildContext of its
/// own — e.g. auto-playing the next track after the current one finishes.
class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static BuildContext? get context => key.currentContext;
}