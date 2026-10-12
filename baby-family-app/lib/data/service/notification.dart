import 'package:baby_family/data/model/notification/app_notification.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// NOTI-01 + chuông trên HOME-01.
abstract class INotificationService extends IBaseService {
  /// Thông báo của tôi, mới nhất trước. [group] = all → tất cả.
  Future<List<AppNotification>> notifications({
    NotificationGroup group = NotificationGroup.all,
  });

  Future<int> unreadCount();

  Future<void> markRead(String id);

  Future<void> markAllRead();
}
