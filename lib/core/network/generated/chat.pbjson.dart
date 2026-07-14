// This is a generated file - do not edit.
//
// Generated from chat.proto.

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

@$core.Deprecated('Use joinCommunityRequestDescriptor instead')
const JoinCommunityRequest$json = {
  '1': 'JoinCommunityRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `JoinCommunityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinCommunityRequestDescriptor =
    $convert.base64Decode(
        'ChRKb2luQ29tbXVuaXR5UmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQ=');

@$core.Deprecated('Use joinCommunityResponseDescriptor instead')
const JoinCommunityResponse$json = {
  '1': 'JoinCommunityResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `JoinCommunityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinCommunityResponseDescriptor =
    $convert.base64Decode(
        'ChVKb2luQ29tbXVuaXR5UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use leaveCommunityRequestDescriptor instead')
const LeaveCommunityRequest$json = {
  '1': 'LeaveCommunityRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `LeaveCommunityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveCommunityRequestDescriptor =
    $convert.base64Decode(
        'ChVMZWF2ZUNvbW11bml0eVJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklk');

@$core.Deprecated('Use leaveCommunityResponseDescriptor instead')
const LeaveCommunityResponse$json = {
  '1': 'LeaveCommunityResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `LeaveCommunityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveCommunityResponseDescriptor =
    $convert.base64Decode(
        'ChZMZWF2ZUNvbW11bml0eVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use isCommunityMemberRequestDescriptor instead')
const IsCommunityMemberRequest$json = {
  '1': 'IsCommunityMemberRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `IsCommunityMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List isCommunityMemberRequestDescriptor =
    $convert.base64Decode(
        'ChhJc0NvbW11bml0eU1lbWJlclJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklk');

@$core.Deprecated('Use isCommunityMemberResponseDescriptor instead')
const IsCommunityMemberResponse$json = {
  '1': 'IsCommunityMemberResponse',
  '2': [
    {'1': 'is_member', '3': 1, '4': 1, '5': 8, '10': 'isMember'},
  ],
};

/// Descriptor for `IsCommunityMemberResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List isCommunityMemberResponseDescriptor =
    $convert.base64Decode(
        'ChlJc0NvbW11bml0eU1lbWJlclJlc3BvbnNlEhsKCWlzX21lbWJlchgBIAEoCFIIaXNNZW1iZX'
        'I=');

@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage$json = {
  '1': 'ChatMessage',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'avatar_url', '3': 4, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'content', '3': 5, '4': 1, '5': 9, '10': 'content'},
    {'1': 'media_url', '3': 6, '4': 1, '5': 9, '10': 'mediaUrl'},
    {'1': 'message_type', '3': 7, '4': 1, '5': 9, '10': 'messageType'},
    {'1': 'reply_to_id', '3': 8, '4': 1, '5': 9, '10': 'replyToId'},
    {'1': 'reply_to_user_id', '3': 9, '4': 1, '5': 9, '10': 'replyToUserId'},
    {
      '1': 'reply_to_username',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'replyToUsername'
    },
    {
      '1': 'reply_to_content_snippet',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'replyToContentSnippet'
    },
    {'1': 'created_at', '3': 12, '4': 1, '5': 3, '10': 'createdAt'},
  ],
};

/// Descriptor for `ChatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageDescriptor = $convert.base64Decode(
    'CgtDaGF0TWVzc2FnZRIOCgJpZBgBIAEoCVICaWQSFwoHdXNlcl9pZBgCIAEoCVIGdXNlcklkEh'
    'oKCHVzZXJuYW1lGAMgASgJUgh1c2VybmFtZRIdCgphdmF0YXJfdXJsGAQgASgJUglhdmF0YXJV'
    'cmwSGAoHY29udGVudBgFIAEoCVIHY29udGVudBIbCgltZWRpYV91cmwYBiABKAlSCG1lZGlhVX'
    'JsEiEKDG1lc3NhZ2VfdHlwZRgHIAEoCVILbWVzc2FnZVR5cGUSHgoLcmVwbHlfdG9faWQYCCAB'
    'KAlSCXJlcGx5VG9JZBInChByZXBseV90b191c2VyX2lkGAkgASgJUg1yZXBseVRvVXNlcklkEi'
    'oKEXJlcGx5X3RvX3VzZXJuYW1lGAogASgJUg9yZXBseVRvVXNlcm5hbWUSNwoYcmVwbHlfdG9f'
    'Y29udGVudF9zbmlwcGV0GAsgASgJUhVyZXBseVRvQ29udGVudFNuaXBwZXQSHQoKY3JlYXRlZF'
    '9hdBgMIAEoA1IJY3JlYXRlZEF0');

@$core.Deprecated('Use sendMessageRequestDescriptor instead')
const SendMessageRequest$json = {
  '1': 'SendMessageRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
    {'1': 'media_url', '3': 3, '4': 1, '5': 9, '10': 'mediaUrl'},
    {'1': 'message_type', '3': 4, '4': 1, '5': 9, '10': 'messageType'},
    {'1': 'reply_to_id', '3': 5, '4': 1, '5': 9, '10': 'replyToId'},
  ],
};

/// Descriptor for `SendMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendMessageRequestDescriptor = $convert.base64Decode(
    'ChJTZW5kTWVzc2FnZVJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhgKB2NvbnRlbn'
    'QYAiABKAlSB2NvbnRlbnQSGwoJbWVkaWFfdXJsGAMgASgJUghtZWRpYVVybBIhCgxtZXNzYWdl'
    'X3R5cGUYBCABKAlSC21lc3NhZ2VUeXBlEh4KC3JlcGx5X3RvX2lkGAUgASgJUglyZXBseVRvSW'
    'Q=');

@$core.Deprecated('Use sendMessageResponseDescriptor instead')
const SendMessageResponse$json = {
  '1': 'SendMessageResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'message',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.chat.ChatMessage',
      '10': 'message'
    },
  ],
};

/// Descriptor for `SendMessageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendMessageResponseDescriptor = $convert.base64Decode(
    'ChNTZW5kTWVzc2FnZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSKwoHbWVzc2'
    'FnZRgCIAEoCzIRLmNoYXQuQ2hhdE1lc3NhZ2VSB21lc3NhZ2U=');

@$core.Deprecated('Use getMessagesRequestDescriptor instead')
const GetMessagesRequest$json = {
  '1': 'GetMessagesRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'before_timestamp', '3': 2, '4': 1, '5': 3, '10': 'beforeTimestamp'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetMessagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMessagesRequestDescriptor = $convert.base64Decode(
    'ChJHZXRNZXNzYWdlc1JlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEikKEGJlZm9yZV'
    '90aW1lc3RhbXAYAiABKANSD2JlZm9yZVRpbWVzdGFtcBIUCgVsaW1pdBgDIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use getMessagesResponseDescriptor instead')
const GetMessagesResponse$json = {
  '1': 'GetMessagesResponse',
  '2': [
    {
      '1': 'messages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.chat.ChatMessage',
      '10': 'messages'
    },
  ],
};

/// Descriptor for `GetMessagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMessagesResponseDescriptor = $convert.base64Decode(
    'ChNHZXRNZXNzYWdlc1Jlc3BvbnNlEi0KCG1lc3NhZ2VzGAEgAygLMhEuY2hhdC5DaGF0TWVzc2'
    'FnZVIIbWVzc2FnZXM=');

@$core.Deprecated('Use subscribeRequestDescriptor instead')
const SubscribeRequest$json = {
  '1': 'SubscribeRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `SubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeRequestDescriptor = $convert.base64Decode(
    'ChBTdWJzY3JpYmVSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZA==');

@$core.Deprecated('Use getCommunityStatsRequestDescriptor instead')
const GetCommunityStatsRequest$json = {
  '1': 'GetCommunityStatsRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetCommunityStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCommunityStatsRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRDb21tdW5pdHlTdGF0c1JlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklk');

@$core.Deprecated('Use getCommunityStatsResponseDescriptor instead')
const GetCommunityStatsResponse$json = {
  '1': 'GetCommunityStatsResponse',
  '2': [
    {'1': 'total_members', '3': 1, '4': 1, '5': 5, '10': 'totalMembers'},
  ],
};

/// Descriptor for `GetCommunityStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCommunityStatsResponseDescriptor =
    $convert.base64Decode(
        'ChlHZXRDb21tdW5pdHlTdGF0c1Jlc3BvbnNlEiMKDXRvdGFsX21lbWJlcnMYASABKAVSDHRvdG'
        'FsTWVtYmVycw==');

@$core.Deprecated('Use communityMemberDescriptor instead')
const CommunityMember$json = {
  '1': 'CommunityMember',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'avatar_url', '3': 3, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'joined_at', '3': 4, '4': 1, '5': 3, '10': 'joinedAt'},
    {'1': 'badge', '3': 5, '4': 1, '5': 9, '10': 'badge'},
  ],
};

/// Descriptor for `CommunityMember`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communityMemberDescriptor = $convert.base64Decode(
    'Cg9Db21tdW5pdHlNZW1iZXISFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhoKCHVzZXJuYW1lGA'
    'IgASgJUgh1c2VybmFtZRIdCgphdmF0YXJfdXJsGAMgASgJUglhdmF0YXJVcmwSGwoJam9pbmVk'
    'X2F0GAQgASgDUghqb2luZWRBdBIUCgViYWRnZRgFIAEoCVIFYmFkZ2U=');

@$core.Deprecated('Use getCommunityMembersRequestDescriptor instead')
const GetCommunityMembersRequest$json = {
  '1': 'GetCommunityMembersRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'page', '3': 2, '4': 1, '5': 5, '10': 'page'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetCommunityMembersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCommunityMembersRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXRDb21tdW5pdHlNZW1iZXJzUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSEg'
        'oEcGFnZRgCIAEoBVIEcGFnZRIUCgVsaW1pdBgDIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use getCommunityMembersResponseDescriptor instead')
const GetCommunityMembersResponse$json = {
  '1': 'GetCommunityMembersResponse',
  '2': [
    {
      '1': 'members',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.chat.CommunityMember',
      '10': 'members'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `GetCommunityMembersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCommunityMembersResponseDescriptor =
    $convert.base64Decode(
        'ChtHZXRDb21tdW5pdHlNZW1iZXJzUmVzcG9uc2USLwoHbWVtYmVycxgBIAMoCzIVLmNoYXQuQ2'
        '9tbXVuaXR5TWVtYmVyUgdtZW1iZXJzEhQKBXRvdGFsGAIgASgFUgV0b3RhbA==');
