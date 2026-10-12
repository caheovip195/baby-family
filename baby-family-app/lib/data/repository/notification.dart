import 'package:baby_family/data/repository/base.dart';

abstract class INotificationRepository extends IBaseRepository {
  List<JsonMap> notifications(String familyId);

  void updateNotification(String id, JsonMap patch);

  JsonMap addNotification(JsonMap notification);
}
