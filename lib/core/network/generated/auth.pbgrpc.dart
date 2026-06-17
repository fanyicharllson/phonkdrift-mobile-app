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
}
