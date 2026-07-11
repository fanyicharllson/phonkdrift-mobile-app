// This is a generated file - do not edit.
//
// Generated from auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use registerRequestDescriptor instead')
const RegisterRequest$json = {
  '1': 'RegisterRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `RegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRequestDescriptor = $convert.base64Decode(
    'Cg9SZWdpc3RlclJlcXVlc3QSGgoIdXNlcm5hbWUYASABKAlSCHVzZXJuYW1lEhQKBWVtYWlsGA'
    'IgASgJUgVlbWFpbBIaCghwYXNzd29yZBgDIAEoCVIIcGFzc3dvcmQ=');

@$core.Deprecated('Use registerResponseDescriptor instead')
const RegisterResponse$json = {
  '1': 'RegisterResponse',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RegisterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerResponseDescriptor = $convert.base64Decode(
    'ChBSZWdpc3RlclJlc3BvbnNlEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIYCgdtZXNzYWdlGA'
    'IgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use verifyRequestDescriptor instead')
const VerifyRequest$json = {
  '1': 'VerifyRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `VerifyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyRequestDescriptor = $convert.base64Decode(
    'Cg1WZXJpZnlSZXF1ZXN0EhQKBWVtYWlsGAEgASgJUgVlbWFpbBISCgRjb2RlGAIgASgJUgRjb2'
    'Rl');

@$core.Deprecated('Use verifyResponseDescriptor instead')
const VerifyResponse$json = {
  '1': 'VerifyResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'token', '3': 3, '4': 1, '5': 9, '10': 'token'},
    {'1': 'expires_at', '3': 4, '4': 1, '5': 3, '10': 'expiresAt'},
    {'1': 'user_id', '3': 5, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `VerifyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyResponseDescriptor = $convert.base64Decode(
    'Cg5WZXJpZnlSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB21lc3NhZ2UYAi'
    'ABKAlSB21lc3NhZ2USFAoFdG9rZW4YAyABKAlSBXRva2VuEh0KCmV4cGlyZXNfYXQYBCABKANS'
    'CWV4cGlyZXNBdBIXCgd1c2VyX2lkGAUgASgJUgZ1c2VySWQ=');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWlsEhoKCHBhc3N3b3JkGAIgASgJUg'
    'hwYXNzd29yZA==');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'expires_at', '3': 3, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhQKBXRva2VuGAEgASgJUgV0b2tlbhIXCgd1c2VyX2lkGAIgASgJUg'
    'Z1c2VySWQSHQoKZXhwaXJlc19hdBgDIAEoA1IJZXhwaXJlc0F0');

@$core.Deprecated('Use validateTokenRequestDescriptor instead')
const ValidateTokenRequest$json = {
  '1': 'ValidateTokenRequest',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `ValidateTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateTokenRequestDescriptor =
    $convert.base64Decode(
        'ChRWYWxpZGF0ZVRva2VuUmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4=');

@$core.Deprecated('Use validateTokenResponseDescriptor instead')
const ValidateTokenResponse$json = {
  '1': 'ValidateTokenResponse',
  '2': [
    {'1': 'is_valid', '3': 1, '4': 1, '5': 8, '10': 'isValid'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'user', '3': 4, '4': 1, '5': 11, '6': '.auth.User', '10': 'user'},
  ],
};

/// Descriptor for `ValidateTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateTokenResponseDescriptor = $convert.base64Decode(
    'ChVWYWxpZGF0ZVRva2VuUmVzcG9uc2USGQoIaXNfdmFsaWQYASABKAhSB2lzVmFsaWQSFwoHdX'
    'Nlcl9pZBgCIAEoCVIGdXNlcklkEhoKCHVzZXJuYW1lGAMgASgJUgh1c2VybmFtZRIeCgR1c2Vy'
    'GAQgASgLMgouYXV0aC5Vc2VyUgR1c2Vy');

@$core.Deprecated('Use resendCodeRequestDescriptor instead')
const ResendCodeRequest$json = {
  '1': 'ResendCodeRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `ResendCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resendCodeRequestDescriptor = $convert
    .base64Decode('ChFSZXNlbmRDb2RlUmVxdWVzdBIUCgVlbWFpbBgBIAEoCVIFZW1haWw=');

@$core.Deprecated('Use resendCodeResponseDescriptor instead')
const ResendCodeResponse$json = {
  '1': 'ResendCodeResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ResendCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resendCodeResponseDescriptor = $convert.base64Decode(
    'ChJSZXNlbmRDb2RlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYW'
    'dlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use getUserRequestDescriptor instead')
const GetUserRequest$json = {
  '1': 'GetUserRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserRequestDescriptor = $convert
    .base64Decode('Cg5HZXRVc2VyUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQ=');

@$core.Deprecated('Use getUserResponseDescriptor instead')
const GetUserResponse$json = {
  '1': 'GetUserResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.auth.User', '10': 'user'},
  ],
};

/// Descriptor for `GetUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRVc2VyUmVzcG9uc2USHgoEdXNlchgBIAEoCzIKLmF1dGguVXNlclIEdXNlcg==');

@$core.Deprecated('Use updateProfileRequestDescriptor instead')
const UpdateProfileRequest$json = {
  '1': 'UpdateProfileRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'phonk_level', '3': 2, '4': 1, '5': 9, '10': 'phonkLevel'},
  ],
};

/// Descriptor for `UpdateProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProfileRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVQcm9maWxlUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSHwoLcGhvbm'
    'tfbGV2ZWwYAiABKAlSCnBob25rTGV2ZWw=');

@$core.Deprecated('Use updateProfileResponseDescriptor instead')
const UpdateProfileResponse$json = {
  '1': 'UpdateProfileResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'user', '3': 2, '4': 1, '5': 11, '6': '.auth.User', '10': 'user'},
  ],
};

/// Descriptor for `UpdateProfileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProfileResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQcm9maWxlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIeCgR1c2'
    'VyGAIgASgLMgouYXV0aC5Vc2VyUgR1c2Vy');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {'1': 'avatar_url', '3': 4, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'phonk_level', '3': 5, '4': 1, '5': 9, '10': 'phonkLevel'},
    {'1': 'is_banned', '3': 6, '4': 1, '5': 8, '10': 'isBanned'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm'
    '5hbWUSFAoFZW1haWwYAyABKAlSBWVtYWlsEh0KCmF2YXRhcl91cmwYBCABKAlSCWF2YXRhclVy'
    'bBIfCgtwaG9ua19sZXZlbBgFIAEoCVIKcGhvbmtMZXZlbBIbCglpc19iYW5uZWQYBiABKAhSCG'
    'lzQmFubmVk');

@$core.Deprecated('Use forgotPasswordRequestDescriptor instead')
const ForgotPasswordRequest$json = {
  '1': 'ForgotPasswordRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `ForgotPasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forgotPasswordRequestDescriptor =
    $convert.base64Decode(
        'ChVGb3Jnb3RQYXNzd29yZFJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWls');

@$core.Deprecated('Use forgotPasswordResponseDescriptor instead')
const ForgotPasswordResponse$json = {
  '1': 'ForgotPasswordResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ForgotPasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forgotPasswordResponseDescriptor =
    $convert.base64Decode(
        'ChZGb3Jnb3RQYXNzd29yZFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbW'
        'Vzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use resetPasswordRequestDescriptor instead')
const ResetPasswordRequest$json = {
  '1': 'ResetPasswordRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'new_password', '3': 3, '4': 1, '5': 9, '10': 'newPassword'},
  ],
};

/// Descriptor for `ResetPasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetPasswordRequestDescriptor = $convert.base64Decode(
    'ChRSZXNldFBhc3N3b3JkUmVxdWVzdBIUCgVlbWFpbBgBIAEoCVIFZW1haWwSEgoEY29kZRgCIA'
    'EoCVIEY29kZRIhCgxuZXdfcGFzc3dvcmQYAyABKAlSC25ld1Bhc3N3b3Jk');

@$core.Deprecated('Use resetPasswordResponseDescriptor instead')
const ResetPasswordResponse$json = {
  '1': 'ResetPasswordResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ResetPasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetPasswordResponseDescriptor = $convert.base64Decode(
    'ChVSZXNldFBhc3N3b3JkUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZX'
    'NzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use verifyResetCodeRequestDescriptor instead')
const VerifyResetCodeRequest$json = {
  '1': 'VerifyResetCodeRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `VerifyResetCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyResetCodeRequestDescriptor =
    $convert.base64Decode(
        'ChZWZXJpZnlSZXNldENvZGVSZXF1ZXN0EhQKBWVtYWlsGAEgASgJUgVlbWFpbBISCgRjb2RlGA'
        'IgASgJUgRjb2Rl');

@$core.Deprecated('Use verifyResetCodeResponseDescriptor instead')
const VerifyResetCodeResponse$json = {
  '1': 'VerifyResetCodeResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'reset_token', '3': 2, '4': 1, '5': 9, '10': 'resetToken'},
  ],
};

/// Descriptor for `VerifyResetCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyResetCodeResponseDescriptor =
    $convert.base64Decode(
        'ChdWZXJpZnlSZXNldENvZGVSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEh8KC3'
        'Jlc2V0X3Rva2VuGAIgASgJUgpyZXNldFRva2Vu');

@$core.Deprecated('Use uploadAvatarRequestDescriptor instead')
const UploadAvatarRequest$json = {
  '1': 'UploadAvatarRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'avatar_url', '3': 2, '4': 1, '5': 9, '10': 'avatarUrl'},
  ],
};

/// Descriptor for `UploadAvatarRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadAvatarRequestDescriptor = $convert.base64Decode(
    'ChNVcGxvYWRBdmF0YXJSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIdCgphdmF0YX'
    'JfdXJsGAIgASgJUglhdmF0YXJVcmw=');

@$core.Deprecated('Use uploadAvatarResponseDescriptor instead')
const UploadAvatarResponse$json = {
  '1': 'UploadAvatarResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'avatar_url', '3': 2, '4': 1, '5': 9, '10': 'avatarUrl'},
  ],
};

/// Descriptor for `UploadAvatarResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadAvatarResponseDescriptor = $convert.base64Decode(
    'ChRVcGxvYWRBdmF0YXJSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEh0KCmF2YX'
    'Rhcl91cmwYAiABKAlSCWF2YXRhclVybA==');

@$core.Deprecated('Use changePasswordRequestDescriptor instead')
const ChangePasswordRequest$json = {
  '1': 'ChangePasswordRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'old_password', '3': 2, '4': 1, '5': 9, '10': 'oldPassword'},
    {'1': 'new_password', '3': 3, '4': 1, '5': 9, '10': 'newPassword'},
  ],
};

/// Descriptor for `ChangePasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordRequestDescriptor = $convert.base64Decode(
    'ChVDaGFuZ2VQYXNzd29yZFJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEiEKDG9sZF'
    '9wYXNzd29yZBgCIAEoCVILb2xkUGFzc3dvcmQSIQoMbmV3X3Bhc3N3b3JkGAMgASgJUgtuZXdQ'
    'YXNzd29yZA==');

@$core.Deprecated('Use changePasswordResponseDescriptor instead')
const ChangePasswordResponse$json = {
  '1': 'ChangePasswordResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ChangePasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordResponseDescriptor =
    $convert.base64Decode(
        'ChZDaGFuZ2VQYXNzd29yZFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbW'
        'Vzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use updateUsernameRequestDescriptor instead')
const UpdateUsernameRequest$json = {
  '1': 'UpdateUsernameRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'new_username', '3': 2, '4': 1, '5': 9, '10': 'newUsername'},
  ],
};

/// Descriptor for `UpdateUsernameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUsernameRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVVc2VybmFtZVJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEiEKDG5ld1'
    '91c2VybmFtZRgCIAEoCVILbmV3VXNlcm5hbWU=');

@$core.Deprecated('Use updateUsernameResponseDescriptor instead')
const UpdateUsernameResponse$json = {
  '1': 'UpdateUsernameResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'user', '3': 2, '4': 1, '5': 11, '6': '.auth.User', '10': 'user'},
  ],
};

/// Descriptor for `UpdateUsernameResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUsernameResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVVc2VybmFtZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSHgoEdX'
        'NlchgCIAEoCzIKLmF1dGguVXNlclIEdXNlcg==');

@$core.Deprecated('Use submitFeedbackRequestDescriptor instead')
const SubmitFeedbackRequest$json = {
  '1': 'SubmitFeedbackRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'rating', '3': 2, '4': 1, '5': 5, '10': 'rating'},
    {'1': 'comment', '3': 3, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'app_version', '3': 4, '4': 1, '5': 9, '10': 'appVersion'},
  ],
};

/// Descriptor for `SubmitFeedbackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitFeedbackRequestDescriptor = $convert.base64Decode(
    'ChVTdWJtaXRGZWVkYmFja1JlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhYKBnJhdG'
    'luZxgCIAEoBVIGcmF0aW5nEhgKB2NvbW1lbnQYAyABKAlSB2NvbW1lbnQSHwoLYXBwX3ZlcnNp'
    'b24YBCABKAlSCmFwcFZlcnNpb24=');

@$core.Deprecated('Use submitFeedbackResponseDescriptor instead')
const SubmitFeedbackResponse$json = {
  '1': 'SubmitFeedbackResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'feedback_id', '3': 2, '4': 1, '5': 9, '10': 'feedbackId'},
  ],
};

/// Descriptor for `SubmitFeedbackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitFeedbackResponseDescriptor =
    $convert.base64Decode(
        'ChZTdWJtaXRGZWVkYmFja1Jlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSHwoLZm'
        'VlZGJhY2tfaWQYAiABKAlSCmZlZWRiYWNrSWQ=');

@$core.Deprecated('Use feedbackEntryDescriptor instead')
const FeedbackEntry$json = {
  '1': 'FeedbackEntry',
  '2': [
    {'1': 'feedback_id', '3': 1, '4': 1, '5': 9, '10': 'feedbackId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'email', '3': 4, '4': 1, '5': 9, '10': 'email'},
    {'1': 'rating', '3': 5, '4': 1, '5': 5, '10': 'rating'},
    {'1': 'comment', '3': 6, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'app_version', '3': 7, '4': 1, '5': 9, '10': 'appVersion'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 3, '10': 'createdAt'},
  ],
};

/// Descriptor for `FeedbackEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedbackEntryDescriptor = $convert.base64Decode(
    'Cg1GZWVkYmFja0VudHJ5Eh8KC2ZlZWRiYWNrX2lkGAEgASgJUgpmZWVkYmFja0lkEhcKB3VzZX'
    'JfaWQYAiABKAlSBnVzZXJJZBIaCgh1c2VybmFtZRgDIAEoCVIIdXNlcm5hbWUSFAoFZW1haWwY'
    'BCABKAlSBWVtYWlsEhYKBnJhdGluZxgFIAEoBVIGcmF0aW5nEhgKB2NvbW1lbnQYBiABKAlSB2'
    'NvbW1lbnQSHwoLYXBwX3ZlcnNpb24YByABKAlSCmFwcFZlcnNpb24SHQoKY3JlYXRlZF9hdBgI'
    'IAEoA1IJY3JlYXRlZEF0');

@$core.Deprecated('Use listFeedbackAdminRequestDescriptor instead')
const ListFeedbackAdminRequest$json = {
  '1': 'ListFeedbackAdminRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListFeedbackAdminRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFeedbackAdminRequestDescriptor =
    $convert.base64Decode(
        'ChhMaXN0RmVlZGJhY2tBZG1pblJlcXVlc3QSEgoEcGFnZRgBIAEoBVIEcGFnZRIUCgVsaW1pdB'
        'gCIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use listFeedbackAdminResponseDescriptor instead')
const ListFeedbackAdminResponse$json = {
  '1': 'ListFeedbackAdminResponse',
  '2': [
    {
      '1': 'feedback',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.auth.FeedbackEntry',
      '10': 'feedback'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListFeedbackAdminResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFeedbackAdminResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0RmVlZGJhY2tBZG1pblJlc3BvbnNlEi8KCGZlZWRiYWNrGAEgAygLMhMuYXV0aC5GZW'
        'VkYmFja0VudHJ5UghmZWVkYmFjaxIUCgV0b3RhbBgCIAEoBVIFdG90YWw=');

@$core.Deprecated('Use banUserRequestDescriptor instead')
const BanUserRequest$json = {
  '1': 'BanUserRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `BanUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List banUserRequestDescriptor = $convert.base64Decode(
    'Cg5CYW5Vc2VyUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSFgoGcmVhc29uGAIgAS'
    'gJUgZyZWFzb24=');

@$core.Deprecated('Use banUserResponseDescriptor instead')
const BanUserResponse$json = {
  '1': 'BanUserResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `BanUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List banUserResponseDescriptor = $convert.base64Decode(
    'Cg9CYW5Vc2VyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGA'
    'IgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use unbanUserRequestDescriptor instead')
const UnbanUserRequest$json = {
  '1': 'UnbanUserRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `UnbanUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbanUserRequestDescriptor = $convert.base64Decode(
    'ChBVbmJhblVzZXJSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZA==');

@$core.Deprecated('Use unbanUserResponseDescriptor instead')
const UnbanUserResponse$json = {
  '1': 'UnbanUserResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UnbanUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbanUserResponseDescriptor = $convert.base64Decode(
    'ChFVbmJhblVzZXJSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB21lc3NhZ2'
    'UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use pushNotificationRequestDescriptor instead')
const PushNotificationRequest$json = {
  '1': 'PushNotificationRequest',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'body', '3': 2, '4': 1, '5': 9, '10': 'body'},
    {'1': 'target_user_id', '3': 3, '4': 1, '5': 9, '10': 'targetUserId'},
    {'1': 'data_type', '3': 4, '4': 1, '5': 9, '10': 'dataType'},
    {'1': 'data_id', '3': 5, '4': 1, '5': 9, '10': 'dataId'},
  ],
};

/// Descriptor for `PushNotificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushNotificationRequestDescriptor = $convert.base64Decode(
    'ChdQdXNoTm90aWZpY2F0aW9uUmVxdWVzdBIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSEgoEYm9keR'
    'gCIAEoCVIEYm9keRIkCg50YXJnZXRfdXNlcl9pZBgDIAEoCVIMdGFyZ2V0VXNlcklkEhsKCWRh'
    'dGFfdHlwZRgEIAEoCVIIZGF0YVR5cGUSFwoHZGF0YV9pZBgFIAEoCVIGZGF0YUlk');

@$core.Deprecated('Use pushNotificationResponseDescriptor instead')
const PushNotificationResponse$json = {
  '1': 'PushNotificationResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'sent_count', '3': 2, '4': 1, '5': 5, '10': 'sentCount'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `PushNotificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushNotificationResponseDescriptor = $convert.base64Decode(
    'ChhQdXNoTm90aWZpY2F0aW9uUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIdCg'
    'pzZW50X2NvdW50GAIgASgFUglzZW50Q291bnQSGAoHbWVzc2FnZRgDIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use updateFCMTokenRequestDescriptor instead')
const UpdateFCMTokenRequest$json = {
  '1': 'UpdateFCMTokenRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'fcm_token', '3': 2, '4': 1, '5': 9, '10': 'fcmToken'},
  ],
};

/// Descriptor for `UpdateFCMTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateFCMTokenRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVGQ01Ub2tlblJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhsKCWZjbV'
    '90b2tlbhgCIAEoCVIIZmNtVG9rZW4=');

@$core.Deprecated('Use updateFCMTokenResponseDescriptor instead')
const UpdateFCMTokenResponse$json = {
  '1': 'UpdateFCMTokenResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `UpdateFCMTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateFCMTokenResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVGQ01Ub2tlblJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use getUserStatusRequestDescriptor instead')
const GetUserStatusRequest$json = {
  '1': 'GetUserStatusRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetUserStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserStatusRequestDescriptor =
    $convert.base64Decode(
        'ChRHZXRVc2VyU3RhdHVzUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQ=');

@$core.Deprecated('Use getUserStatusResponseDescriptor instead')
const GetUserStatusResponse$json = {
  '1': 'GetUserStatusResponse',
  '2': [
    {'1': 'is_banned', '3': 1, '4': 1, '5': 8, '10': 'isBanned'},
    {'1': 'ban_reason', '3': 2, '4': 1, '5': 9, '10': 'banReason'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'phonk_level', '3': 4, '4': 1, '5': 9, '10': 'phonkLevel'},
  ],
};

/// Descriptor for `GetUserStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserStatusResponseDescriptor = $convert.base64Decode(
    'ChVHZXRVc2VyU3RhdHVzUmVzcG9uc2USGwoJaXNfYmFubmVkGAEgASgIUghpc0Jhbm5lZBIdCg'
    'piYW5fcmVhc29uGAIgASgJUgliYW5SZWFzb24SGgoIdXNlcm5hbWUYAyABKAlSCHVzZXJuYW1l'
    'Eh8KC3Bob25rX2xldmVsGAQgASgJUgpwaG9ua0xldmVs');

@$core.Deprecated('Use getUserCountRequestDescriptor instead')
const GetUserCountRequest$json = {
  '1': 'GetUserCountRequest',
};

/// Descriptor for `GetUserCountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserCountRequestDescriptor =
    $convert.base64Decode('ChNHZXRVc2VyQ291bnRSZXF1ZXN0');

@$core.Deprecated('Use getUserCountResponseDescriptor instead')
const GetUserCountResponse$json = {
  '1': 'GetUserCountResponse',
  '2': [
    {'1': 'total_users', '3': 1, '4': 1, '5': 5, '10': 'totalUsers'},
  ],
};

/// Descriptor for `GetUserCountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserCountResponseDescriptor = $convert.base64Decode(
    'ChRHZXRVc2VyQ291bnRSZXNwb25zZRIfCgt0b3RhbF91c2VycxgBIAEoBVIKdG90YWxVc2Vycw'
    '==');
