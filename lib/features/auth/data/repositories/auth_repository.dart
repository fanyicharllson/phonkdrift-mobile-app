import 'package:grpc/grpc.dart';
import '../../../../core/network/grpc_client.dart';
import '../../../../core/network/generated/auth.pb.dart';
import '../../../../core/utils/storage_helper.dart';

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
      await _storage.saveSession(
        token: res.token,
        userId: res.userId,
        username: '',
        expiresAt: res.expiresAt.toInt(),
      );
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
        ResetPasswordRequest(email: email, code: code, newPassword: newPassword),
      );
    } on GrpcError catch (e) {
      throw AuthException(_grpcMessage(e));
    }
  }

  // ── Local helpers ──────────────────────────────────────────────────────────
  Future<bool> isLoggedIn() => _storage.isLoggedIn();
  Future<void> logout() => _storage.clearSession();
  Future<String?> getPendingEmail() => _storage.getPendingEmail();

  String _grpcMessage(GrpcError e) =>
      e.message?.isNotEmpty == true ? e.message! : 'Something went wrong';
}
