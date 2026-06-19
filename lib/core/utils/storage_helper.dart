import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_config.dart';

class StorageHelper {
  StorageHelper._();
  static final StorageHelper instance = StorageHelper._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ── Write ──────────────────────────────────────────────────────────────────
  Future<void> saveToken(String token) =>
      _storage.write(key: AppConfig.keyAuthToken, value: token);

  Future<void> saveUserId(String userId) =>
      _storage.write(key: AppConfig.keyUserId, value: userId);

  Future<void> saveUsername(String username) =>
      _storage.write(key: AppConfig.keyUsername, value: username);

  Future<void> saveTokenExpiry(int expiresAt) =>
      _storage.write(key: AppConfig.keyTokenExpiry, value: '$expiresAt');

  Future<void> savePhonkLevel(String level) =>
      _storage.write(key: AppConfig.keyPhonkLevel, value: level);

  Future<void> savePendingEmail(String email) =>
      _storage.write(key: AppConfig.keyPendingVerifyEmail, value: email);

  Future<void> markOnboardingSeen() =>
      _storage.write(key: AppConfig.keyOnboardingSeen, value: 'true');

  Future<void> saveSession({
    required String token,
    required String userId,
    required String username,
    required int expiresAt,
  }) async {
    await Future.wait([
      saveToken(token),
      saveUserId(userId),
      saveUsername(username),
      saveTokenExpiry(expiresAt),
    ]);
  }

  // ── Read ───────────────────────────────────────────────────────────────────
  Future<String?> getToken() => _storage.read(key: AppConfig.keyAuthToken);
  Future<String?> getUserId() => _storage.read(key: AppConfig.keyUserId);
  Future<String?> getUsername() => _storage.read(key: AppConfig.keyUsername);
  Future<String?> getPhonkLevel() => _storage.read(key: AppConfig.keyPhonkLevel);
  Future<String?> getPendingEmail() =>
      _storage.read(key: AppConfig.keyPendingVerifyEmail);

  Future<bool> hasSeenOnboarding() async {
    try {
      final val = await _storage.read(key: AppConfig.keyOnboardingSeen);
      return val == 'true';
    } catch (_) {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      final expiry = await _storage.read(key: AppConfig.keyTokenExpiry);
      if (token == null || expiry == null) return false;
      final expiryMs = int.tryParse(expiry) ?? 0;
      return DateTime.now().millisecondsSinceEpoch < expiryMs * 1000;
    } catch (_) {
      return false;
    }
  }

  // ── Clear ──────────────────────────────────────────────────────────────────
  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: AppConfig.keyAuthToken),
      _storage.delete(key: AppConfig.keyUserId),
      _storage.delete(key: AppConfig.keyUsername),
      _storage.delete(key: AppConfig.keyTokenExpiry),
      _storage.delete(key: AppConfig.keyPhonkLevel),
    ]);
  }

  Future<void> clearAll() => _storage.deleteAll();
}
