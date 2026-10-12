import 'package:baby_family/data/model/notification/app_notification.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/notification.dart';
import 'package:baby_family/data/service/notification.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';
import 'package:baby_family/utils/constants/enum.dart';

class NotificationServiceImp extends MockServiceImp
    implements INotificationService {
  NotificationServiceImp(
    super.sessionRepository,
    super.clock,
    this._repository,
  );

  final INotificationRepository _repository;

  bool _mine(JsonMap row) {
    final recipient = row['recipientUserId'] as String?;
    return recipient == null || recipient == myUserId;
  }

  @override
  Future<List<AppNotification>> notifications({
    NotificationGroup group = NotificationGroup.all,
  }) async {
    await ready();
    return _repository
        .notifications(familyId)
        .where(_mine)
        .map(AppNotification.fromJson)
        .where((item) => group == NotificationGroup.all || item.group == group)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<int> unreadCount() async =>
      (await notifications()).where((item) => item.unread).length;

  @override
  Future<void> markRead(String id) async {
    await ready();
    _repository.updateNotification(id, {'unread': false});
  }

  @override
  Future<void> markAllRead() async {
    for (final item in await notifications()) {
      if (item.unread) {
        _repository.updateNotification(item.id, {'unread': false});
      }
    }
  }
}
