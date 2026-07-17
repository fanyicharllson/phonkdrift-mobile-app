class AppConfig {
  AppConfig._();

  // === gRPC GATEWAY — single entry point, gateway routes internally ===
  static const String grpcHost = '167.71.34.119';
  static const int grpcPort = 30050;
  static const int restPort = 30080; // API Gateway NodePort — all services route through here

  // === APP META ===
  static const String appName = 'PhonkDrift';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Welcome to the drift station';

  // === STORAGE KEYS ===
  static const String keyAuthToken = 'pd_auth_token';
  static const String keyUserId = 'pd_user_id';
  static const String keyUsername = 'pd_username';
  static const String keyTokenExpiry = 'pd_token_expiry';
  static const String keyPhonkLevel = 'pd_phonk_level';
  static const String keyPendingVerifyEmail = 'pd_pending_email';
  static const String keyOnboardingSeen = 'pd_onboarding_seen';
  static const String keyCommunityJoinedBefore = 'pd_community_joined_before';
  static const String keyFeedbackPromptsEnabled = 'pd_feedback_prompts_enabled';

  // === gRPC TIMEOUTS ===
  static const Duration grpcConnectTimeout = Duration(seconds: 10);
  static const Duration grpcCallTimeout = Duration(seconds: 30);
}
