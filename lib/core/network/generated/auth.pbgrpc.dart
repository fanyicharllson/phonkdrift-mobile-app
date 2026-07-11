// This is a generated file - do not edit.
//
// Generated from auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'auth.pb.dart' as $0;

export 'auth.pb.dart';

/// The authentication and profile manager service
@$pb.GrpcServiceName('auth.AuthService')
class AuthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AuthServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.RegisterResponse> registerUser(
    $0.RegisterRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$registerUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.LoginResponse> loginUser(
    $0.LoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$loginUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.ValidateTokenResponse> validateToken(
    $0.ValidateTokenRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$validateToken, request, options: options);
  }

  $grpc.ResponseFuture<$0.VerifyResponse> verifyCode(
    $0.VerifyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$verifyCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.ResendCodeResponse> resendCode(
    $0.ResendCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resendCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUserResponse> getUser(
    $0.GetUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateProfileResponse> updateProfile(
    $0.UpdateProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateProfile, request, options: options);
  }

  $grpc.ResponseFuture<$0.ForgotPasswordResponse> forgotPassword(
    $0.ForgotPasswordRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$forgotPassword, request, options: options);
  }

  $grpc.ResponseFuture<$0.ResetPasswordResponse> resetPassword(
    $0.ResetPasswordRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resetPassword, request, options: options);
  }

  $grpc.ResponseFuture<$0.VerifyResetCodeResponse> verifyResetCode(
    $0.VerifyResetCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$verifyResetCode, request, options: options);
  }

  /// Profile management
  $grpc.ResponseFuture<$0.UploadAvatarResponse> uploadAvatar(
    $0.UploadAvatarRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$uploadAvatar, request, options: options);
  }

  $grpc.ResponseFuture<$0.ChangePasswordResponse> changePassword(
    $0.ChangePasswordRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$changePassword, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateUsernameResponse> updateUsername(
    $0.UpdateUsernameRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateUsername, request, options: options);
  }

  /// Feedback
  $grpc.ResponseFuture<$0.SubmitFeedbackResponse> submitFeedback(
    $0.SubmitFeedbackRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$submitFeedback, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListFeedbackAdminResponse> listFeedbackAdmin(
    $0.ListFeedbackAdminRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listFeedbackAdmin, request, options: options);
  }

  /// Admin operations
  $grpc.ResponseFuture<$0.BanUserResponse> banUser(
    $0.BanUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$banUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.UnbanUserResponse> unbanUser(
    $0.UnbanUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$unbanUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.PushNotificationResponse> sendPushNotification(
    $0.PushNotificationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendPushNotification, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateFCMTokenResponse> updateFCMToken(
    $0.UpdateFCMTokenRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateFCMToken, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUserStatusResponse> getUserStatus(
    $0.GetUserStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUserStatus, request, options: options);
  }

  /// Admin stats
  $grpc.ResponseFuture<$0.GetUserCountResponse> getUserCount(
    $0.GetUserCountRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUserCount, request, options: options);
  }

  // method descriptors

  static final _$registerUser =
      $grpc.ClientMethod<$0.RegisterRequest, $0.RegisterResponse>(
          '/auth.AuthService/RegisterUser',
          ($0.RegisterRequest value) => value.writeToBuffer(),
          $0.RegisterResponse.fromBuffer);
  static final _$loginUser =
      $grpc.ClientMethod<$0.LoginRequest, $0.LoginResponse>(
          '/auth.AuthService/LoginUser',
          ($0.LoginRequest value) => value.writeToBuffer(),
          $0.LoginResponse.fromBuffer);
  static final _$validateToken =
      $grpc.ClientMethod<$0.ValidateTokenRequest, $0.ValidateTokenResponse>(
          '/auth.AuthService/ValidateToken',
          ($0.ValidateTokenRequest value) => value.writeToBuffer(),
          $0.ValidateTokenResponse.fromBuffer);
  static final _$verifyCode =
      $grpc.ClientMethod<$0.VerifyRequest, $0.VerifyResponse>(
          '/auth.AuthService/VerifyCode',
          ($0.VerifyRequest value) => value.writeToBuffer(),
          $0.VerifyResponse.fromBuffer);
  static final _$resendCode =
      $grpc.ClientMethod<$0.ResendCodeRequest, $0.ResendCodeResponse>(
          '/auth.AuthService/ResendCode',
          ($0.ResendCodeRequest value) => value.writeToBuffer(),
          $0.ResendCodeResponse.fromBuffer);
  static final _$getUser =
      $grpc.ClientMethod<$0.GetUserRequest, $0.GetUserResponse>(
          '/auth.AuthService/GetUser',
          ($0.GetUserRequest value) => value.writeToBuffer(),
          $0.GetUserResponse.fromBuffer);
  static final _$updateProfile =
      $grpc.ClientMethod<$0.UpdateProfileRequest, $0.UpdateProfileResponse>(
          '/auth.AuthService/UpdateProfile',
          ($0.UpdateProfileRequest value) => value.writeToBuffer(),
          $0.UpdateProfileResponse.fromBuffer);
  static final _$forgotPassword =
      $grpc.ClientMethod<$0.ForgotPasswordRequest, $0.ForgotPasswordResponse>(
          '/auth.AuthService/ForgotPassword',
          ($0.ForgotPasswordRequest value) => value.writeToBuffer(),
          $0.ForgotPasswordResponse.fromBuffer);
  static final _$resetPassword =
      $grpc.ClientMethod<$0.ResetPasswordRequest, $0.ResetPasswordResponse>(
          '/auth.AuthService/ResetPassword',
          ($0.ResetPasswordRequest value) => value.writeToBuffer(),
          $0.ResetPasswordResponse.fromBuffer);
  static final _$verifyResetCode =
      $grpc.ClientMethod<$0.VerifyResetCodeRequest, $0.VerifyResetCodeResponse>(
          '/auth.AuthService/VerifyResetCode',
          ($0.VerifyResetCodeRequest value) => value.writeToBuffer(),
          $0.VerifyResetCodeResponse.fromBuffer);
  static final _$uploadAvatar =
      $grpc.ClientMethod<$0.UploadAvatarRequest, $0.UploadAvatarResponse>(
          '/auth.AuthService/UploadAvatar',
          ($0.UploadAvatarRequest value) => value.writeToBuffer(),
          $0.UploadAvatarResponse.fromBuffer);
  static final _$changePassword =
      $grpc.ClientMethod<$0.ChangePasswordRequest, $0.ChangePasswordResponse>(
          '/auth.AuthService/ChangePassword',
          ($0.ChangePasswordRequest value) => value.writeToBuffer(),
          $0.ChangePasswordResponse.fromBuffer);
  static final _$updateUsername =
      $grpc.ClientMethod<$0.UpdateUsernameRequest, $0.UpdateUsernameResponse>(
          '/auth.AuthService/UpdateUsername',
          ($0.UpdateUsernameRequest value) => value.writeToBuffer(),
          $0.UpdateUsernameResponse.fromBuffer);
  static final _$submitFeedback =
      $grpc.ClientMethod<$0.SubmitFeedbackRequest, $0.SubmitFeedbackResponse>(
          '/auth.AuthService/SubmitFeedback',
          ($0.SubmitFeedbackRequest value) => value.writeToBuffer(),
          $0.SubmitFeedbackResponse.fromBuffer);
  static final _$listFeedbackAdmin = $grpc.ClientMethod<
          $0.ListFeedbackAdminRequest, $0.ListFeedbackAdminResponse>(
      '/auth.AuthService/ListFeedbackAdmin',
      ($0.ListFeedbackAdminRequest value) => value.writeToBuffer(),
      $0.ListFeedbackAdminResponse.fromBuffer);
  static final _$banUser =
      $grpc.ClientMethod<$0.BanUserRequest, $0.BanUserResponse>(
          '/auth.AuthService/BanUser',
          ($0.BanUserRequest value) => value.writeToBuffer(),
          $0.BanUserResponse.fromBuffer);
  static final _$unbanUser =
      $grpc.ClientMethod<$0.UnbanUserRequest, $0.UnbanUserResponse>(
          '/auth.AuthService/UnbanUser',
          ($0.UnbanUserRequest value) => value.writeToBuffer(),
          $0.UnbanUserResponse.fromBuffer);
  static final _$sendPushNotification = $grpc.ClientMethod<
          $0.PushNotificationRequest, $0.PushNotificationResponse>(
      '/auth.AuthService/SendPushNotification',
      ($0.PushNotificationRequest value) => value.writeToBuffer(),
      $0.PushNotificationResponse.fromBuffer);
  static final _$updateFCMToken =
      $grpc.ClientMethod<$0.UpdateFCMTokenRequest, $0.UpdateFCMTokenResponse>(
          '/auth.AuthService/UpdateFCMToken',
          ($0.UpdateFCMTokenRequest value) => value.writeToBuffer(),
          $0.UpdateFCMTokenResponse.fromBuffer);
  static final _$getUserStatus =
      $grpc.ClientMethod<$0.GetUserStatusRequest, $0.GetUserStatusResponse>(
          '/auth.AuthService/GetUserStatus',
          ($0.GetUserStatusRequest value) => value.writeToBuffer(),
          $0.GetUserStatusResponse.fromBuffer);
  static final _$getUserCount =
      $grpc.ClientMethod<$0.GetUserCountRequest, $0.GetUserCountResponse>(
          '/auth.AuthService/GetUserCount',
          ($0.GetUserCountRequest value) => value.writeToBuffer(),
          $0.GetUserCountResponse.fromBuffer);
}

@$pb.GrpcServiceName('auth.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'auth.AuthService';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterRequest, $0.RegisterResponse>(
        'RegisterUser',
        registerUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterRequest.fromBuffer(value),
        ($0.RegisterResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.LoginResponse>(
        'LoginUser',
        loginUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ValidateTokenRequest, $0.ValidateTokenResponse>(
            'ValidateToken',
            validateToken_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ValidateTokenRequest.fromBuffer(value),
            ($0.ValidateTokenResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VerifyRequest, $0.VerifyResponse>(
        'VerifyCode',
        verifyCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.VerifyRequest.fromBuffer(value),
        ($0.VerifyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ResendCodeRequest, $0.ResendCodeResponse>(
        'ResendCode',
        resendCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ResendCodeRequest.fromBuffer(value),
        ($0.ResendCodeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUserRequest, $0.GetUserResponse>(
        'GetUser',
        getUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetUserRequest.fromBuffer(value),
        ($0.GetUserResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateProfileRequest, $0.UpdateProfileResponse>(
            'UpdateProfile',
            updateProfile_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateProfileRequest.fromBuffer(value),
            ($0.UpdateProfileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ForgotPasswordRequest,
            $0.ForgotPasswordResponse>(
        'ForgotPassword',
        forgotPassword_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ForgotPasswordRequest.fromBuffer(value),
        ($0.ForgotPasswordResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ResetPasswordRequest, $0.ResetPasswordResponse>(
            'ResetPassword',
            resetPassword_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ResetPasswordRequest.fromBuffer(value),
            ($0.ResetPasswordResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VerifyResetCodeRequest,
            $0.VerifyResetCodeResponse>(
        'VerifyResetCode',
        verifyResetCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VerifyResetCodeRequest.fromBuffer(value),
        ($0.VerifyResetCodeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UploadAvatarRequest, $0.UploadAvatarResponse>(
            'UploadAvatar',
            uploadAvatar_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UploadAvatarRequest.fromBuffer(value),
            ($0.UploadAvatarResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ChangePasswordRequest,
            $0.ChangePasswordResponse>(
        'ChangePassword',
        changePassword_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ChangePasswordRequest.fromBuffer(value),
        ($0.ChangePasswordResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateUsernameRequest,
            $0.UpdateUsernameResponse>(
        'UpdateUsername',
        updateUsername_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateUsernameRequest.fromBuffer(value),
        ($0.UpdateUsernameResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubmitFeedbackRequest,
            $0.SubmitFeedbackResponse>(
        'SubmitFeedback',
        submitFeedback_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SubmitFeedbackRequest.fromBuffer(value),
        ($0.SubmitFeedbackResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListFeedbackAdminRequest,
            $0.ListFeedbackAdminResponse>(
        'ListFeedbackAdmin',
        listFeedbackAdmin_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListFeedbackAdminRequest.fromBuffer(value),
        ($0.ListFeedbackAdminResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BanUserRequest, $0.BanUserResponse>(
        'BanUser',
        banUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.BanUserRequest.fromBuffer(value),
        ($0.BanUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UnbanUserRequest, $0.UnbanUserResponse>(
        'UnbanUser',
        unbanUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UnbanUserRequest.fromBuffer(value),
        ($0.UnbanUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PushNotificationRequest,
            $0.PushNotificationResponse>(
        'SendPushNotification',
        sendPushNotification_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PushNotificationRequest.fromBuffer(value),
        ($0.PushNotificationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateFCMTokenRequest,
            $0.UpdateFCMTokenResponse>(
        'UpdateFCMToken',
        updateFCMToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateFCMTokenRequest.fromBuffer(value),
        ($0.UpdateFCMTokenResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetUserStatusRequest, $0.GetUserStatusResponse>(
            'GetUserStatus',
            getUserStatus_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetUserStatusRequest.fromBuffer(value),
            ($0.GetUserStatusResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetUserCountRequest, $0.GetUserCountResponse>(
            'GetUserCount',
            getUserCount_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetUserCountRequest.fromBuffer(value),
            ($0.GetUserCountResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegisterResponse> registerUser_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RegisterRequest> $request) async {
    return registerUser($call, await $request);
  }

  $async.Future<$0.RegisterResponse> registerUser(
      $grpc.ServiceCall call, $0.RegisterRequest request);

  $async.Future<$0.LoginResponse> loginUser_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.LoginRequest> $request) async {
    return loginUser($call, await $request);
  }

  $async.Future<$0.LoginResponse> loginUser(
      $grpc.ServiceCall call, $0.LoginRequest request);

  $async.Future<$0.ValidateTokenResponse> validateToken_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ValidateTokenRequest> $request) async {
    return validateToken($call, await $request);
  }

  $async.Future<$0.ValidateTokenResponse> validateToken(
      $grpc.ServiceCall call, $0.ValidateTokenRequest request);

  $async.Future<$0.VerifyResponse> verifyCode_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.VerifyRequest> $request) async {
    return verifyCode($call, await $request);
  }

  $async.Future<$0.VerifyResponse> verifyCode(
      $grpc.ServiceCall call, $0.VerifyRequest request);

  $async.Future<$0.ResendCodeResponse> resendCode_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ResendCodeRequest> $request) async {
    return resendCode($call, await $request);
  }

  $async.Future<$0.ResendCodeResponse> resendCode(
      $grpc.ServiceCall call, $0.ResendCodeRequest request);

  $async.Future<$0.GetUserResponse> getUser_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetUserRequest> $request) async {
    return getUser($call, await $request);
  }

  $async.Future<$0.GetUserResponse> getUser(
      $grpc.ServiceCall call, $0.GetUserRequest request);

  $async.Future<$0.UpdateProfileResponse> updateProfile_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateProfileRequest> $request) async {
    return updateProfile($call, await $request);
  }

  $async.Future<$0.UpdateProfileResponse> updateProfile(
      $grpc.ServiceCall call, $0.UpdateProfileRequest request);

  $async.Future<$0.ForgotPasswordResponse> forgotPassword_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ForgotPasswordRequest> $request) async {
    return forgotPassword($call, await $request);
  }

  $async.Future<$0.ForgotPasswordResponse> forgotPassword(
      $grpc.ServiceCall call, $0.ForgotPasswordRequest request);

  $async.Future<$0.ResetPasswordResponse> resetPassword_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ResetPasswordRequest> $request) async {
    return resetPassword($call, await $request);
  }

  $async.Future<$0.ResetPasswordResponse> resetPassword(
      $grpc.ServiceCall call, $0.ResetPasswordRequest request);

  $async.Future<$0.VerifyResetCodeResponse> verifyResetCode_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VerifyResetCodeRequest> $request) async {
    return verifyResetCode($call, await $request);
  }

  $async.Future<$0.VerifyResetCodeResponse> verifyResetCode(
      $grpc.ServiceCall call, $0.VerifyResetCodeRequest request);

  $async.Future<$0.UploadAvatarResponse> uploadAvatar_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UploadAvatarRequest> $request) async {
    return uploadAvatar($call, await $request);
  }

  $async.Future<$0.UploadAvatarResponse> uploadAvatar(
      $grpc.ServiceCall call, $0.UploadAvatarRequest request);

  $async.Future<$0.ChangePasswordResponse> changePassword_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ChangePasswordRequest> $request) async {
    return changePassword($call, await $request);
  }

  $async.Future<$0.ChangePasswordResponse> changePassword(
      $grpc.ServiceCall call, $0.ChangePasswordRequest request);

  $async.Future<$0.UpdateUsernameResponse> updateUsername_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateUsernameRequest> $request) async {
    return updateUsername($call, await $request);
  }

  $async.Future<$0.UpdateUsernameResponse> updateUsername(
      $grpc.ServiceCall call, $0.UpdateUsernameRequest request);

  $async.Future<$0.SubmitFeedbackResponse> submitFeedback_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SubmitFeedbackRequest> $request) async {
    return submitFeedback($call, await $request);
  }

  $async.Future<$0.SubmitFeedbackResponse> submitFeedback(
      $grpc.ServiceCall call, $0.SubmitFeedbackRequest request);

  $async.Future<$0.ListFeedbackAdminResponse> listFeedbackAdmin_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListFeedbackAdminRequest> $request) async {
    return listFeedbackAdmin($call, await $request);
  }

  $async.Future<$0.ListFeedbackAdminResponse> listFeedbackAdmin(
      $grpc.ServiceCall call, $0.ListFeedbackAdminRequest request);

  $async.Future<$0.BanUserResponse> banUser_Pre($grpc.ServiceCall $call,
      $async.Future<$0.BanUserRequest> $request) async {
    return banUser($call, await $request);
  }

  $async.Future<$0.BanUserResponse> banUser(
      $grpc.ServiceCall call, $0.BanUserRequest request);

  $async.Future<$0.UnbanUserResponse> unbanUser_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UnbanUserRequest> $request) async {
    return unbanUser($call, await $request);
  }

  $async.Future<$0.UnbanUserResponse> unbanUser(
      $grpc.ServiceCall call, $0.UnbanUserRequest request);

  $async.Future<$0.PushNotificationResponse> sendPushNotification_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PushNotificationRequest> $request) async {
    return sendPushNotification($call, await $request);
  }

  $async.Future<$0.PushNotificationResponse> sendPushNotification(
      $grpc.ServiceCall call, $0.PushNotificationRequest request);

  $async.Future<$0.UpdateFCMTokenResponse> updateFCMToken_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateFCMTokenRequest> $request) async {
    return updateFCMToken($call, await $request);
  }

  $async.Future<$0.UpdateFCMTokenResponse> updateFCMToken(
      $grpc.ServiceCall call, $0.UpdateFCMTokenRequest request);

  $async.Future<$0.GetUserStatusResponse> getUserStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUserStatusRequest> $request) async {
    return getUserStatus($call, await $request);
  }

  $async.Future<$0.GetUserStatusResponse> getUserStatus(
      $grpc.ServiceCall call, $0.GetUserStatusRequest request);

  $async.Future<$0.GetUserCountResponse> getUserCount_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUserCountRequest> $request) async {
    return getUserCount($call, await $request);
  }

  $async.Future<$0.GetUserCountResponse> getUserCount(
      $grpc.ServiceCall call, $0.GetUserCountRequest request);
}
