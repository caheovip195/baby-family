import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/notification.dart';
import 'package:baby_family/data/repository_imp/mock_repository.dart';

class NotificationRepositoryImp extends MockRepositoryImp
    implements INotificationRepository {
  NotificationRepositoryImp(super.store);

  @override
  List<JsonMap> notifications(String familyId) =>
      rows('notifications', (row) => row['familyId'] == familyId);

  @override
  void updateNotification(String id, JsonMap patch) =>
      this.patch('notifications', id, patch);

  @override
  JsonMap addNotification(JsonMap notification) =>
      insert('notifications', notification);
}
