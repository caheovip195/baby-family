import 'package:baby_family/data/repository/base.dart';

abstract class INotificationRepository extends IBaseRepository {
  List<JsonMap> notifications(String familyId);

  void updateNotification(String id, JsonMap patch);

  /// Báo các màn đang đọc kho đọc lại — dùng sau thao tác trên server.
  void touch();

  JsonMap addNotification(JsonMap notification);
}
