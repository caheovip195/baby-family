import 'package:rxdart/rxdart.dart';

/// Phát sự kiện toàn app từ nơi không có `ref` (interceptor, handler FCM).
class BroadcastManager {
  factory BroadcastManager() => _singleton ??= BroadcastManager._();

  BroadcastManager._();

  static BroadcastManager? _singleton;

  final PublishSubject<void> _sessionExpiredSubject = PublishSubject<void>();

  final PublishSubject<String> _deepLinkSubject = PublishSubject<String>();

  /// Phiên bị server chấm dứt (401) và chứng chỉ đã bị xoá.
  Stream<void> get sessionExpiredStream => _sessionExpiredSubject.stream;

  /// Deep link cần mở (từ thông báo đẩy, link mời...).
  Stream<String> get deepLinkStream => _deepLinkSubject.stream;

  void notifySessionExpired() {
    _sessionExpiredSubject.add(null);
  }

  void addDeepLink(String link) {
    _deepLinkSubject.add(link);
  }

  void close() {
    _sessionExpiredSubject.close();
    _deepLinkSubject.close();
  }
}
