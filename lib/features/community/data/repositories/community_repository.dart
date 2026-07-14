import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import '../../../../core/network/grpc_client.dart';
import '../../../../core/network/generated/chat.pb.dart';
import '../../../../core/network/generated/chat.pbgrpc.dart';
import '../../../../core/utils/storage_helper.dart';

class CommunityException implements Exception {
  const CommunityException(this.message);
  final String message;
  @override
  String toString() => message;
}

class CommunityRepository {
  CommunityRepository._();
  static final CommunityRepository instance = CommunityRepository._();

  final _client = PhonkGrpcClient.instance;
  final _storage = StorageHelper.instance;

  Future<CallOptions> get _authOptions async {
    final token = await _storage.getToken() ?? '';
    return _client.authCallOptions(token);
  }

  Future<String> get _userId async =>
      await _storage.getUserId() ?? '';

  Future<bool> isMember() async {
    try {
      final uid = await _userId;
      final opts = await _authOptions;
      final res = await _client.chat.isCommunityMember(
        IsCommunityMemberRequest(userId: uid),
        options: opts,
      );
      return res.isMember;
    } on GrpcError catch (e) {
      throw CommunityException(_msg(e));
    }
  }

  Future<bool> joinCommunity() async {
    try {
      final uid = await _userId;
      final opts = await _authOptions;
      final res = await _client.chat.joinCommunity(
        JoinCommunityRequest(userId: uid),
        options: opts,
      );
      return res.success;
    } on GrpcError catch (e) {
      throw CommunityException(_msg(e));
    }
  }

  Future<bool> leaveCommunity() async {
    try {
      final uid = await _userId;
      final opts = await _authOptions;
      final res = await _client.chat.leaveCommunity(
        LeaveCommunityRequest(userId: uid),
        options: opts,
      );
      return res.success;
    } on GrpcError catch (e) {
      throw CommunityException(_msg(e));
    }
  }

  Future<List<ChatMessage>> getMessages({
    Int64? beforeTimestamp,
    int limit = 30,
  }) async {
    try {
      final uid = await _userId;
      final opts = await _authOptions;
      final res = await _client.chat.getMessages(
        GetMessagesRequest(
          userId: uid,
          beforeTimestamp: beforeTimestamp,
          limit: limit,
        ),
        options: opts,
      );
      return res.messages;
    } on GrpcError catch (e) {
      throw CommunityException(_msg(e));
    }
  }

  Future<ChatMessage> sendMessage({
    required String content,
    String replyToId = '',
    String messageType = 'text',
    String mediaUrl = '',
  }) async {
    try {
      final uid = await _userId;
      final opts = await _authOptions;
      final res = await _client.chat.sendMessage(
        SendMessageRequest(
          userId: uid,
          content: content,
          messageType: messageType,
          mediaUrl: mediaUrl,
          replyToId: replyToId,
        ),
        options: opts,
      );
      if (!res.success) throw const CommunityException('Message failed to send.');
      return res.message;
    } on GrpcError catch (e) {
      throw CommunityException(_msg(e));
    }
  }

  ResponseStream<ChatMessage> subscribeToChat() {
    return _client.chat.subscribeToChat(
      SubscribeRequest(userId: ''), // gateway sets from token
    );
  }

  Future<GetCommunityStatsResponse> getStats() async {
    try {
      final uid = await _userId;
      final opts = await _authOptions;
      return await _client.chat.getCommunityStats(
        GetCommunityStatsRequest(userId: uid),
        options: opts,
      );
    } on GrpcError catch (e) {
      throw CommunityException(_msg(e));
    }
  }

  Future<GetCommunityMembersResponse> getMembers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final uid = await _userId;
      final opts = await _authOptions;
      return await _client.chat.getCommunityMembers(
        GetCommunityMembersRequest(userId: uid, page: page, limit: limit),
        options: opts,
      );
    } on GrpcError catch (e) {
      throw CommunityException(_msg(e));
    }
  }

  String _msg(GrpcError e) =>
      e.message?.isNotEmpty == true ? e.message! : 'Something went wrong';
}