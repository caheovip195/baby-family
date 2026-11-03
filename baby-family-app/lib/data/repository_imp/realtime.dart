import 'dart:async';
import 'dart:math' as math;

import 'package:baby_family/data/dto/realtime_event.dart';
import 'package:baby_family/data/remote/interceptor/authorization_interceptor.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/realtime.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/server.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/flavor_config.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Socket.IO tới server realtime (BF-20261101-001): chỉ transport websocket,
/// cùng host/cổng với API. Mỗi lần (kết nối lại) handshake lấy access token
/// mới nhất qua luồng gia hạn của [AuthorizationInterceptor]; token sắp hết
/// hạn thì gửi `auth.refresh`; server ngắt (`auth.expired`/`auth.error`) thì
/// gia hạn bắt buộc rồi kết nối lại (lùi dần).
class RealtimeRepositoryImp extends BaseRepositoryImp
    implements IRealtimeRepository {
  RealtimeRepositoryImp({String? endPoint}) : _endPointOverride = endPoint;

  final String? _endPointOverride;

  /// Đọc lúc kết nối (cấu hình flavor đã sẵn sàng).
  String get _endPoint => _endPointOverride ?? FlavorConfig.instance.endPoint;

  /// Sự kiện server được chuyển cho tầng trên.
  static const _forwarded = [
    'ready',
    'chat.message',
    'chat.read',
    'chat.typing',
  ];

  final _events = StreamController<RealtimeEvent>.broadcast();
  final _statuses = StreamController<RealtimeStatus>.broadcast();
  final _random = math.Random();

  io.Socket? _socket;
  RealtimeStatus _status = RealtimeStatus.idle;
  bool _wanted = false;
  bool _forceRenew = false;
  int _attempts = 0;
  Timer? _retryTimer;
  Timer? _refreshTimer;

  /// Gốc host của API (`http://host:port/api` → `http://host:port`).
  @visibleForTesting
  static String originOf(String endPoint) => Uri.parse(endPoint).origin;

  @override
  Stream<RealtimeEvent> get events => _events.stream;

  @override
  Stream<RealtimeStatus> get statusChanges => _statuses.stream;

  @override
  RealtimeStatus get status => _status;

  @override
  void connect() {
    _wanted = true;
    final socket = _socket;
    if (socket != null) {
      if (!socket.connected) {
        _retryTimer?.cancel();
        _retryTimer = null;
        socket.connect();
      }
      return;
    }
    if (_endPoint.isEmpty) {
      return;
    }
    _setStatus(RealtimeStatus.connecting);
    final created = io.io(
      originOf(_endPoint),
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setPath(Api.realtimeSocketPath)
          .disableAutoConnect()
          .enableForceNew()
          .enableReconnection()
          .setReconnectionDelay(kValueRealtimeReconnectDelay.inMilliseconds)
          .setReconnectionDelayMax(
            kValueRealtimeReconnectDelayMax.inMilliseconds,
          )
          .setRandomizationFactor(0.5)
          .setAuthFn((callback) => unawaited(_handshake(callback)))
          .build(),
    );
    _socket = created;
    created
      ..onConnect((_) {
        _attempts = 0;
        _setStatus(RealtimeStatus.connected);
      })
      ..onConnectError((Object? error) {
        Logger().w('Realtime: kết nối lỗi: $error');
        if (_wanted) {
          _setStatus(RealtimeStatus.reconnecting);
        }
      })
      ..onDisconnect((Object? reason) {
        _refreshTimer?.cancel();
        if (!_wanted) {
          _setStatus(RealtimeStatus.idle);
          return;
        }
        _setStatus(RealtimeStatus.reconnecting);
        // Server chủ động ngắt (token hết hạn / sai): thư viện không tự nối
        // lại → tự lên lịch.
        if (reason == 'io server disconnect') {
          _retryLater();
        }
      })
      ..on('auth.expired', (_) => _forceRenew = true)
      ..on('auth.error', (_) => _forceRenew = true);
    for (final name in _forwarded) {
      created.on(name, (Object? data) {
        _events.add(
          RealtimeEvent(
            name,
            data is Map ? Map<String, dynamic>.from(data) : const {},
          ),
        );
      });
    }
    created.connect();
  }

  @override
  void disconnect() {
    _wanted = false;
    _retryTimer?.cancel();
    _retryTimer = null;
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _attempts = 0;
    final socket = _socket;
    _socket = null;
    socket?.dispose();
    _setStatus(RealtimeStatus.idle);
  }

  @override
  void emit(String event, JsonMap data) {
    final socket = _socket;
    if (socket != null && socket.connected) {
      socket.emit(event, data);
    }
  }

  void _setStatus(RealtimeStatus status) {
    if (_status == status) {
      return;
    }
    _status = status;
    _statuses.add(status);
  }

  /// Handshake: gửi access token mới nhất (gia hạn nếu cần).
  Future<void> _handshake(void Function(Map<dynamic, dynamic>) callback) async {
    final certificate = await AuthorizationInterceptor.currentCertificate(
      forceRenew: _forceRenew,
    );
    _forceRenew = false;
    _scheduleRefresh(certificate?.expiredAccessTokenDateTime);
    try {
      callback({'token': certificate?.accessToken ?? ''});
    } on Object catch (error) {
      // Socket đã bị huỷ trong lúc chờ token.
      Logger().w('Realtime: bỏ handshake: $error');
    }
  }

  void _retryLater() {
    _retryTimer?.cancel();
    final base = kValueRealtimeReconnectDelay.inMilliseconds * (1 << _attempts);
    final capped = math.min(
      base,
      kValueRealtimeReconnectDelayMax.inMilliseconds,
    );
    _attempts = math.min(_attempts + 1, 10);
    final delay = Duration(
      milliseconds: capped ~/ 2 + _random.nextInt(capped ~/ 2 + 1),
    );
    _retryTimer = Timer(delay, () {
      _retryTimer = null;
      final socket = _socket;
      if (_wanted && socket != null && !socket.connected) {
        socket.connect();
      }
    });
  }

  /// Làm mới token trên kết nối đang mở trước khi server ngắt vì hết hạn.
  void _scheduleRefresh(DateTime? expiresAt) {
    _refreshTimer?.cancel();
    if (expiresAt == null) {
      return;
    }
    final wait = expiresAt
        .subtract(kValueRealtimeTokenRefreshBefore)
        .difference(DateTime.now());
    // Gia hạn chưa được (mất mạng) → token cũ, thời điểm đã qua: không lặp
    // dồn dập, thử lại sau một nhịp.
    const floor = kValueRealtimeReconnectDelayMax;
    _refreshTimer = Timer(wait < floor ? floor : wait, () {
      unawaited(_refresh());
    });
  }

  Future<void> _refresh() async {
    final socket = _socket;
    if (socket == null || !socket.connected) {
      return;
    }
    final certificate = await AuthorizationInterceptor.currentCertificate();
    final token = certificate?.accessToken;
    if (token == null || !identical(socket, _socket) || !socket.connected) {
      return;
    }
    socket.emitWithAck(
      'auth.refresh',
      {'token': token},
      ack: (Object? result) {
        if (result is Map && result['ok'] == true) {
          _scheduleRefresh(certificate?.expiredAccessTokenDateTime);
          return;
        }
        // Server không nhận token mới: kết nối lại bằng handshake mới.
        if (identical(socket, _socket) && _wanted) {
          socket
            ..disconnect()
            ..connect();
        }
      },
    );
  }
}
