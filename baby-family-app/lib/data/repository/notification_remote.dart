import 'package:baby_family/data/model/notification/notification_page.dart';
import 'package:baby_family/data/repository/base.dart';

/// Hộp thông báo trên server (NOTI-01, tài liệu kỹ thuật mục 13).
abstract class INotificationRemoteRepository extends IBaseRepository {
  Future<NotificationPage?> notifications({String? cursor, int? limit});

  Future<int> unreadCount();

  /// [ids] = null → đánh dấu tất cả đã đọc.
  Future<void> markRead({List<String>? ids});
}
