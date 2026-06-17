import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus { idle, loading, success, error }

class AuthController extends ChangeNotifier {
  final _repo = AuthRepository.instance;

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  String? _pendingEmail;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get pendingEmail => _pendingEmail;
  bool get isLoading => _status == AuthStatus.loading;

  // ── Register ───────────────────────────────────────────────────────────────
  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      await _repo.register(username: username, email: email, password: password);
      _pendingEmail = email;
      _setSuccess();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (_) {
      _setError('Network error. Check your connection.');
      return false;
    }
  }

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      await _repo.login(email: email, password: password);
      _setSuccess();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (_) {
      _setError('Network error. Check your connection.');
      return false;
    }
  }

  // ── Verify code ────────────────────────────────────────────────────────────
  Future<bool> verifyCode({required String email, required String code}) async {
    _setLoading();
    try {
      final res = await _repo.verifyCode(email: email, code: code);
      if (res.success) {
        _setSuccess();
        return true;
      }
      _setError(res.message.isNotEmpty ? res.message : 'Invalid code');
      return false;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (_) {
      _setError('Network error. Check your connection.');
      return false;
    }
  }

  // ── Resend code ────────────────────────────────────────────────────────────
  Future<bool> resendCode({required String email}) async {
    _setLoading();
    try {
      final res = await _repo.resendCode(email: email);
      _setIdle();
      return res.success;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (_) {
      _setError('Failed to resend code.');
      return false;
    }
  }

  // ── Update phonk level ─────────────────────────────────────────────────────
  Future<bool> updatePhonkLevel({
    required String userId,
    required String level,
  }) async {
    _setLoading();
    try {
      final res = await _repo.updatePhonkLevel(userId: userId, phonkLevel: level);
      _setSuccess();
      return res.success;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (_) {
      _setError('Failed to update profile.');
      return false;
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await _repo.logout();
    _status = AuthStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  // ── Session check ──────────────────────────────────────────────────────────
  Future<bool> isLoggedIn() => _repo.isLoggedIn();

  // ── State helpers ──────────────────────────────────────────────────────────
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = AuthStatus.success;
    notifyListeners();
  }

  void _setError(String msg) {
    _status = AuthStatus.error;
    _errorMessage = msg;
    notifyListeners();
  }

  void _setIdle() {
    _status = AuthStatus.idle;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _status = AuthStatus.idle;
    notifyListeners();
  }
}
