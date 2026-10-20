import 'package:baby_family/data/model/notification/notification_page.dart';
import 'package:baby_family/data/repository/notification_remote.dart';
import 'package:baby_family/data/repository_imp/base.dart';

class NotificationRemoteRepositoryImp extends BaseRepositoryImp
    implements INotificationRemoteRepository {
  @override
  Future<NotificationPage?> notifications({String? cursor, int? limit}) async {
    final rs = await client!.getNotifications(cursor: cursor, limit: limit);
    return rs.page;
  }

  @override
  Future<int> unreadCount() async {
    final rs = await client!.getUnreadNotificationCount();
    return rs.count?.count ?? 0;
  }

  @override
  Future<void> markRead({List<String>? ids}) =>
      client!.markNotificationsRead(ids == null ? {'all': true} : {'ids': ids});
}
