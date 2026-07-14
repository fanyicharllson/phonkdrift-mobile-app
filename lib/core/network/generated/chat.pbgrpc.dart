// This is a generated file - do not edit.
//
// Generated from chat.proto.

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

import 'chat.pb.dart' as $0;

export 'chat.pb.dart';

/// The community chat service — a single global room, gated behind
/// community membership, with realtime delivery via server-streaming.
@$pb.GrpcServiceName('chat.ChatService')
class ChatServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ChatServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.JoinCommunityResponse> joinCommunity(
    $0.JoinCommunityRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$joinCommunity, request, options: options);
  }

  $grpc.ResponseFuture<$0.LeaveCommunityResponse> leaveCommunity(
    $0.LeaveCommunityRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$leaveCommunity, request, options: options);
  }

  $grpc.ResponseFuture<$0.IsCommunityMemberResponse> isCommunityMember(
    $0.IsCommunityMemberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$isCommunityMember, request, options: options);
  }

  $grpc.ResponseFuture<$0.SendMessageResponse> sendMessage(
    $0.SendMessageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendMessage, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetMessagesResponse> getMessages(
    $0.GetMessagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMessages, request, options: options);
  }

  $grpc.ResponseStream<$0.ChatMessage> subscribeToChat(
    $0.SubscribeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribeToChat, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.GetCommunityStatsResponse> getCommunityStats(
    $0.GetCommunityStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCommunityStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetCommunityMembersResponse> getCommunityMembers(
    $0.GetCommunityMembersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCommunityMembers, request, options: options);
  }

  // method descriptors

  static final _$joinCommunity =
      $grpc.ClientMethod<$0.JoinCommunityRequest, $0.JoinCommunityResponse>(
          '/chat.ChatService/JoinCommunity',
          ($0.JoinCommunityRequest value) => value.writeToBuffer(),
          $0.JoinCommunityResponse.fromBuffer);
  static final _$leaveCommunity =
      $grpc.ClientMethod<$0.LeaveCommunityRequest, $0.LeaveCommunityResponse>(
          '/chat.ChatService/LeaveCommunity',
          ($0.LeaveCommunityRequest value) => value.writeToBuffer(),
          $0.LeaveCommunityResponse.fromBuffer);
  static final _$isCommunityMember = $grpc.ClientMethod<
          $0.IsCommunityMemberRequest, $0.IsCommunityMemberResponse>(
      '/chat.ChatService/IsCommunityMember',
      ($0.IsCommunityMemberRequest value) => value.writeToBuffer(),
      $0.IsCommunityMemberResponse.fromBuffer);
  static final _$sendMessage =
      $grpc.ClientMethod<$0.SendMessageRequest, $0.SendMessageResponse>(
          '/chat.ChatService/SendMessage',
          ($0.SendMessageRequest value) => value.writeToBuffer(),
          $0.SendMessageResponse.fromBuffer);
  static final _$getMessages =
      $grpc.ClientMethod<$0.GetMessagesRequest, $0.GetMessagesResponse>(
          '/chat.ChatService/GetMessages',
          ($0.GetMessagesRequest value) => value.writeToBuffer(),
          $0.GetMessagesResponse.fromBuffer);
  static final _$subscribeToChat =
      $grpc.ClientMethod<$0.SubscribeRequest, $0.ChatMessage>(
          '/chat.ChatService/SubscribeToChat',
          ($0.SubscribeRequest value) => value.writeToBuffer(),
          $0.ChatMessage.fromBuffer);
  static final _$getCommunityStats = $grpc.ClientMethod<
          $0.GetCommunityStatsRequest, $0.GetCommunityStatsResponse>(
      '/chat.ChatService/GetCommunityStats',
      ($0.GetCommunityStatsRequest value) => value.writeToBuffer(),
      $0.GetCommunityStatsResponse.fromBuffer);
  static final _$getCommunityMembers = $grpc.ClientMethod<
          $0.GetCommunityMembersRequest, $0.GetCommunityMembersResponse>(
      '/chat.ChatService/GetCommunityMembers',
      ($0.GetCommunityMembersRequest value) => value.writeToBuffer(),
      $0.GetCommunityMembersResponse.fromBuffer);
}

@$pb.GrpcServiceName('chat.ChatService')
abstract class ChatServiceBase extends $grpc.Service {
  $core.String get $name => 'chat.ChatService';

  ChatServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.JoinCommunityRequest, $0.JoinCommunityResponse>(
            'JoinCommunity',
            joinCommunity_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.JoinCommunityRequest.fromBuffer(value),
            ($0.JoinCommunityResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LeaveCommunityRequest,
            $0.LeaveCommunityResponse>(
        'LeaveCommunity',
        leaveCommunity_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LeaveCommunityRequest.fromBuffer(value),
        ($0.LeaveCommunityResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.IsCommunityMemberRequest,
            $0.IsCommunityMemberResponse>(
        'IsCommunityMember',
        isCommunityMember_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.IsCommunityMemberRequest.fromBuffer(value),
        ($0.IsCommunityMemberResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.SendMessageRequest, $0.SendMessageResponse>(
            'SendMessage',
            sendMessage_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SendMessageRequest.fromBuffer(value),
            ($0.SendMessageResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetMessagesRequest, $0.GetMessagesResponse>(
            'GetMessages',
            getMessages_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetMessagesRequest.fromBuffer(value),
            ($0.GetMessagesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubscribeRequest, $0.ChatMessage>(
        'SubscribeToChat',
        subscribeToChat_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SubscribeRequest.fromBuffer(value),
        ($0.ChatMessage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCommunityStatsRequest,
            $0.GetCommunityStatsResponse>(
        'GetCommunityStats',
        getCommunityStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCommunityStatsRequest.fromBuffer(value),
        ($0.GetCommunityStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCommunityMembersRequest,
            $0.GetCommunityMembersResponse>(
        'GetCommunityMembers',
        getCommunityMembers_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCommunityMembersRequest.fromBuffer(value),
        ($0.GetCommunityMembersResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.JoinCommunityResponse> joinCommunity_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.JoinCommunityRequest> $request) async {
    return joinCommunity($call, await $request);
  }

  $async.Future<$0.JoinCommunityResponse> joinCommunity(
      $grpc.ServiceCall call, $0.JoinCommunityRequest request);

  $async.Future<$0.LeaveCommunityResponse> leaveCommunity_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LeaveCommunityRequest> $request) async {
    return leaveCommunity($call, await $request);
  }

  $async.Future<$0.LeaveCommunityResponse> leaveCommunity(
      $grpc.ServiceCall call, $0.LeaveCommunityRequest request);

  $async.Future<$0.IsCommunityMemberResponse> isCommunityMember_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.IsCommunityMemberRequest> $request) async {
    return isCommunityMember($call, await $request);
  }

  $async.Future<$0.IsCommunityMemberResponse> isCommunityMember(
      $grpc.ServiceCall call, $0.IsCommunityMemberRequest request);

  $async.Future<$0.SendMessageResponse> sendMessage_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SendMessageRequest> $request) async {
    return sendMessage($call, await $request);
  }

  $async.Future<$0.SendMessageResponse> sendMessage(
      $grpc.ServiceCall call, $0.SendMessageRequest request);

  $async.Future<$0.GetMessagesResponse> getMessages_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMessagesRequest> $request) async {
    return getMessages($call, await $request);
  }

  $async.Future<$0.GetMessagesResponse> getMessages(
      $grpc.ServiceCall call, $0.GetMessagesRequest request);

  $async.Stream<$0.ChatMessage> subscribeToChat_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SubscribeRequest> $request) async* {
    yield* subscribeToChat($call, await $request);
  }

  $async.Stream<$0.ChatMessage> subscribeToChat(
      $grpc.ServiceCall call, $0.SubscribeRequest request);

  $async.Future<$0.GetCommunityStatsResponse> getCommunityStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCommunityStatsRequest> $request) async {
    return getCommunityStats($call, await $request);
  }

  $async.Future<$0.GetCommunityStatsResponse> getCommunityStats(
      $grpc.ServiceCall call, $0.GetCommunityStatsRequest request);

  $async.Future<$0.GetCommunityMembersResponse> getCommunityMembers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCommunityMembersRequest> $request) async {
    return getCommunityMembers($call, await $request);
  }

  $async.Future<$0.GetCommunityMembersResponse> getCommunityMembers(
      $grpc.ServiceCall call, $0.GetCommunityMembersRequest request);
}
