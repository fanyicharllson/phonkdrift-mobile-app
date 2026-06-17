import 'package:grpc/grpc.dart';
import '../constants/app_config.dart';
import 'generated/auth.pbgrpc.dart';
import 'generated/track.pbgrpc.dart';

/// Centralized gRPC channel + stub manager for PhonkDrift.
/// All feature repositories consume stubs from here — never
/// create raw channels outside this file.
class PhonkGrpcClient {
  PhonkGrpcClient._();

  static final PhonkGrpcClient instance = PhonkGrpcClient._();

  // ── Private channels ──────────────────────────────────────────────────────
  ClientChannel? _authChannel;
  ClientChannel? _trackChannel;

  // ── Public stubs ──────────────────────────────────────────────────────────
  AuthServiceClient? _authStub;
  TrackServiceClient? _trackStub;

  // ── Channel options ────────────────────────────────────────────────────────
  ChannelOptions get _channelOptions => const ChannelOptions(
        // TODO: swap to ChannelCredentials.secure() once TLS cert is on VPS
        credentials: ChannelCredentials.insecure(),
        idleTimeout: Duration(minutes: 5),
        connectionTimeout: AppConfig.grpcConnectTimeout,
      );

  // ── Initialisation ─────────────────────────────────────────────────────────
  /// Call once in main() before runApp.
  void init() {
    _authChannel = ClientChannel(
      AppConfig.grpcHost,
      port: AppConfig.authGrpcPort,
      options: _channelOptions,
    );

    _trackChannel = ClientChannel(
      AppConfig.grpcHost,
      port: AppConfig.trackGrpcPort,
      options: _channelOptions,
    );

    _authStub = AuthServiceClient(
      _authChannel!,
      options: CallOptions(timeout: AppConfig.grpcCallTimeout),
    );

    _trackStub = TrackServiceClient(
      _trackChannel!,
      options: CallOptions(timeout: AppConfig.grpcCallTimeout),
    );
  }

  // ── Stub accessors ─────────────────────────────────────────────────────────
  AuthServiceClient get auth {
    assert(_authStub != null, 'PhonkGrpcClient.init() was not called');
    return _authStub!;
  }

  TrackServiceClient get track {
    assert(_trackStub != null, 'PhonkGrpcClient.init() was not called');
    return _trackStub!;
  }

  /// Attach a bearer token to every outgoing call.
  CallOptions authCallOptions(String token) => CallOptions(
        metadata: {'authorization': 'Bearer $token'},
        timeout: AppConfig.grpcCallTimeout,
      );

  // ── Teardown ───────────────────────────────────────────────────────────────
  Future<void> dispose() async {
    await _authChannel?.shutdown();
    await _trackChannel?.shutdown();
    _authStub = null;
    _trackStub = null;
  }
}
