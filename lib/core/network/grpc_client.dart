import 'package:grpc/grpc.dart';
import '../constants/app_config.dart';
import 'generated/auth.pbgrpc.dart';
import 'generated/track.pbgrpc.dart';
import 'generated/chat.pbgrpc.dart';


/// Single ClientChannel → API Gateway (167.71.34.119:30050).
/// The Go gateway handles internal routing to auth-service / track-service.
/// Never create channels outside this file.
class PhonkGrpcClient {
  PhonkGrpcClient._();
  static final PhonkGrpcClient instance = PhonkGrpcClient._();

  ClientChannel? _channel;
  AuthServiceClient? _authStub;
  TrackServiceClient? _trackStub;
  ChatServiceClient? _chatStub;


  void init() {
    _channel = ClientChannel(
      AppConfig.grpcHost,
      port: AppConfig.grpcPort,
      options: const ChannelOptions(
        // TODO: swap to ChannelCredentials.secure() when TLS is on VPS
        credentials: ChannelCredentials.insecure(),
        idleTimeout: Duration(minutes: 5),
        connectionTimeout: AppConfig.grpcConnectTimeout,
      ),
    );

    final defaultOptions = CallOptions(timeout: AppConfig.grpcCallTimeout);
    _authStub = AuthServiceClient(_channel!, options: defaultOptions);
    _trackStub = TrackServiceClient(_channel!, options: defaultOptions);
    _chatStub = ChatServiceClient(_channel!, options: defaultOptions);

  }

  AuthServiceClient get auth {
    assert(_authStub != null, 'PhonkGrpcClient.init() not called');
    return _authStub!;
  }

  TrackServiceClient get track {
    assert(_trackStub != null, 'PhonkGrpcClient.init() not called');
    return _trackStub!;
  }

  ChatServiceClient get chat {
  assert(_chatStub != null, 'PhonkGrpcClient.init() not called');
  return _chatStub!;
}

  /// Attaches Bearer token to protected calls (GetUser, UpdateProfile, etc.)
  CallOptions authCallOptions(String token) => CallOptions(
        metadata: {'authorization': 'Bearer $token'},
        timeout: AppConfig.grpcCallTimeout,
      );

  Future<void> dispose() async {
    await _channel?.shutdown();
    _authStub = null;
    _trackStub = null;
    _chatStub = null;
  }
}
