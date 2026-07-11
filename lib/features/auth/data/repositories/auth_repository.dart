import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/network/grpc_client.dart';
import '../../../../core/network/generated/auth.pb.dart';
import '../../../../core/utils/storage_helper.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BanStatus {
  const BanStatus({required this.isBanned, required this.reason});

  final bool isBanned;
  final String reason;
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}

class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  final _client = PhonkGrpcClient.instance;
  final _storage = StorageHelper.instance;

  // ── Register ───────────────────────────────────────────────────────────────
  Future<RegisterResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.auth.registerUser(
        RegisterRequest(username: username, email: email, password: password),
      );
      await _storage.savePendingEmail(email);
      return res;
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.auth.loginUser(
        LoginRequest(email: email, password: password),
      );

      // Save session first with empty username
      await _storage.saveSession(
        token: res.token,
        userId: res.userId,
        username: '',
        expiresAt: res.expiresAt.toInt(),
      );

      try {
        final userRes = await _client.auth.getUser(
          GetUserRequest(userId: res.userId),
          options: CallOptions(
            metadata: {'authorization': 'Bearer ${res.token}'},
            timeout: const Duration(seconds: 40),
          ),
        );

        await _storage.saveUsername(userRes.user.username);
        if (userRes.user.phonkLevel.isNotEmpty) {
          await _storage.savePhonkLevel(userRes.user.phonkLevel);
        }
      } catch (e) {
        debugPrint('GET_USER_ERROR: $e');
      }

      return res;
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  // ── Verify email code ──────────────────────────────────────────────────────
  Future<VerifyResponse> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      final res = await _client.auth.verifyCode(
        VerifyRequest(email: email, code: code),
      );
      if (res.success) {
        await _storage.saveSession(
          token: res.token,
          userId: res.userId,
          username: '',
          expiresAt: res.expiresAt.toInt(),
        );

        // Fetch username after verify too
        try {
          final userRes = await _client.auth.getUser(
            GetUserRequest(userId: res.userId),
            options: _client.authCallOptions(res.token),
          );
          await _storage.saveUsername(userRes.user.username);
          if (userRes.user.phonkLevel.isNotEmpty) {
            await _storage.savePhonkLevel(userRes.user.phonkLevel);
          }
        } catch (_) {}
      }
      return res;
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  // ── Resend code ────────────────────────────────────────────────────────────
  Future<ResendCodeResponse> resendCode({required String email}) async {
    try {
      return await _client.auth.resendCode(ResendCodeRequest(email: email));
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  // ── Get user ───────────────────────────────────────────────────────────────
  Future<GetUserResponse> getUser({required String userId}) async {
    try {
      final token = await _storage.getToken() ?? '';
      return await _client.auth.getUser(
        GetUserRequest(userId: userId),
        options: _client.authCallOptions(token),
      );
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  // ── Ban status ────────────────────────────────────────────────────────────
  Future<BanStatus> checkBanStatus() async {
    try {
      final userId = await _storage.getUserId() ?? '';
      if (userId.isEmpty) {
        return const BanStatus(isBanned: false, reason: '');
      }

      final token = await _storage.getToken() ?? '';
      final res = await _client.auth.getUserStatus(
        GetUserStatusRequest(userId: userId),
        options: _client.authCallOptions(token),
      );

      return BanStatus(isBanned: res.isBanned, reason: res.banReason);
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  // ── Update phonk level ─────────────────────────────────────────────────────
  Future<UpdateProfileResponse> updatePhonkLevel({
    required String userId,
    required String phonkLevel,
  }) async {
    try {
      final token = await _storage.getToken() ?? '';
      final res = await _client.auth.updateProfile(
        UpdateProfileRequest(userId: userId, phonkLevel: phonkLevel),
        options: _client.authCallOptions(token),
      );
      if (res.success) await _storage.savePhonkLevel(phonkLevel);
      return res;
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  // ── Forgot / Reset password ────────────────────────────────────────────────
  Future<ForgotPasswordResponse> forgotPassword({required String email}) async {
    try {
      return await _client.auth.forgotPassword(
        ForgotPasswordRequest(email: email),
      );
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  Future<VerifyResetCodeResponse> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      return await _client.auth.verifyResetCode(
        VerifyResetCodeRequest(email: email, code: code),
      );
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  Future<ResetPasswordResponse> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      return await _client.auth.resetPassword(
        ResetPasswordRequest(
          email: email,
          code: code,
          newPassword: newPassword,
        ),
      );
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  // ── Feedback ───────────────────────────────────────────────────────────────
  Future<SubmitFeedbackResponse> submitFeedback({
    required int rating,
    String comment = '',
  }) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      final token = await _storage.getToken() ?? '';
      return await _client.auth.submitFeedback(
        SubmitFeedbackRequest(
          userId: userId,
          rating: rating,
          comment: comment,
          appVersion: AppConfig.appVersion,
        ),
        options: _client.authCallOptions(token),
      );
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  // Add these imports at top

  // Add these methods to AuthRepository class:

  Future<String> uploadAvatar(File imageFile) async {
    final token = await _storage.getToken() ?? '';
    if (token.isEmpty) throw AuthException('Not authenticated.');

    final uri = Uri.parse(
      'http://${AppConfig.grpcHost}:${AppConfig.restPort}/api/v1/users/me/avatar',
    );

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('avatar', imageFile.path));

    final streamed = await request.send().timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw AuthException('Upload timed out. Try again.'),
    );

    final response = await http.Response.fromStream(streamed);
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      final url = body['avatar_url'] as String? ?? '';
      if (url.isNotEmpty) await _storage.write('pd_avatar_url', url);
      return url;
    }

    final errMsg = body['error'] as String? ?? 'Upload failed.';
    throw AuthException(errMsg);
  }

  Future<String> updateUsername(String newUsername) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      final token = await _storage.getToken() ?? '';
      final res = await _client.auth.updateUsername(
        UpdateUsernameRequest(userId: userId, newUsername: newUsername),
        options: _client.authCallOptions(token),
      );
      if (res.success) {
        await _storage.saveUsername(res.user.username);
        return res.user.username;
      }
      throw AuthException('Could not update username.');
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      final token = await _storage.getToken() ?? '';
      final res = await _client.auth.changePassword(
        ChangePasswordRequest(
          userId: userId,
          oldPassword: oldPassword,
          newPassword: newPassword,
        ),
        options: _client.authCallOptions(token),
      );
      if (!res.success) {
        throw AuthException(
          res.message.isNotEmpty ? res.message : 'Password change failed.',
        );
      }
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  Future<void> updatePhonkLevel2(String level) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      final token = await _storage.getToken() ?? '';
      final res = await _client.auth.updateProfile(
        UpdateProfileRequest(userId: userId, phonkLevel: level),
        options: _client.authCallOptions(token),
      );
      if (res.success) await _storage.savePhonkLevel(level);
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  // ── FCM Token ──────────────────────────────────────────────────────────────
  Future<void> updateFCMToken(String fcmToken) async {
    try {
      final userId = await _storage.getUserId() ?? '';
      final token = await _storage.getToken() ?? '';
      if (userId.isEmpty || token.isEmpty) return;
      await _client.auth.updateFCMToken(
        UpdateFCMTokenRequest(userId: userId, fcmToken: fcmToken),
        options: _client.authCallOptions(token),
      );
    } catch (_) {}
  }

  // ── Local helpers ──────────────────────────────────────────────────────────
  Future<bool> isLoggedIn() => _storage.isLoggedIn();
  Future<void> logout() => _storage.clearSession();
  Future<String?> getPendingEmail() => _storage.getPendingEmail();

  String _grpcMessage(GrpcError e) =>
      e.message?.isNotEmpty == true ? e.message! : 'Something went wrong';
}
