import 'package:baby_family/data/repository/push_token.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

/// FCM qua `firebase_messaging`. Firebase chưa khởi tạo (giả lập, môi trường
/// thiếu cấu hình) → không có quyền/token, không ném lỗi.
class PushTokenRepositoryImp extends BaseRepositoryImp
    implements IPushTokenRepository {
  bool get _ready => Firebase.apps.isNotEmpty;

  static bool _allowed(NotificationSettings settings) =>
      settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;

  @override
  Future<bool> requestPermission() async {
    if (!_ready) {
      return false;
    }
    try {
      return _allowed(await FirebaseMessaging.instance.requestPermission());
    } on Object catch (error) {
      Logger().w('Xin quyền thông báo thất bại: $error');
      return false;
    }
  }

  @override
  Future<bool> isAuthorized() async {
    if (!_ready) {
      return false;
    }
    try {
      return _allowed(
        await FirebaseMessaging.instance.getNotificationSettings(),
      );
    } on Object {
      return false;
    }
  }

  @override
  Future<String?> token() async {
    if (!_ready) {
      return null;
    }
    try {
      return await FirebaseMessaging.instance.getToken();
    } on Object catch (error) {
      Logger().w('Lấy push token thất bại: $error');
      return null;
    }
  }

  @override
  Stream<String> get onTokenRefresh => _ready
      ? FirebaseMessaging.instance.onTokenRefresh
      : const Stream<String>.empty();

  static String? _linkOf(RemoteMessage? message) {
    final link = message?.data['deepLink'];
    return link is String && link.isNotEmpty ? link : null;
  }

  @override
  Future<String?> initialLink() async {
    if (!_ready) {
      return null;
    }
    try {
      return _linkOf(await FirebaseMessaging.instance.getInitialMessage());
    } on Object catch (error) {
      Logger().w('Đọc thông báo mở app thất bại: $error');
      return null;
    }
  }

  @override
  Stream<({String title, String body, String? link})> get onForeground => _ready
      ? FirebaseMessaging.onMessage.map(
          (message) => (
            title: message.notification?.title ?? '',
            body: message.notification?.body ?? '',
            link: _linkOf(message),
          ),
        )
      : const Stream.empty();

  @override
  Stream<String> get onOpenedLink => _ready
      ? FirebaseMessaging.onMessageOpenedApp
            .map(_linkOf)
            .where((link) => link != null)
            .cast<String>()
      : const Stream<String>.empty();
}
