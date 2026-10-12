import 'package:baby_family/data/model/notification/app_notification.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/notification.dart';
import 'package:baby_family/data/service/notification.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:hooks_riverpod/legacy.dart';

/// NOTI-01 Thông báo (Pencil VljHC): lọc Tất cả / Papa & Mama / Gia đình,
/// nhóm theo ngày, đánh dấu đã đọc.
final notificationsControllerProvider =
    ChangeNotifierProvider.autoDispose<NotificationsController>(
      NotificationsController.new,
    );

class NotificationsController extends BaseNotifier {
  NotificationsController(super.ref) {
    ref
      ..listen(mockRevisionProvider, (_, _) => load())
      ..listen(appLanguageProvider, (_, _) => load());
    load();
  }

  INotificationService get notificationService =>
      ref.read(notificationServiceProvider);

  NotificationGroup group = NotificationGroup.all;
  List<AppNotification> items = const [];
  DateTime now = DateTime(0);
  bool hasError = false;
  bool loaded = false;
  int _revision = 0;

  /// Thông báo theo ngày (mới nhất trước).
  List<(DateTime, List<AppNotification>)> get days {
    final result = <(DateTime, List<AppNotification>)>[];
    for (final item in items) {
      final day = item.createdAt.dateOnly;
      if (result.isNotEmpty && result.last.$1 == day) {
        result.last.$2.add(item);
      } else {
        result.add((day, [item]));
      }
    }
    return result;
  }

  Future<void> load() async {
    final revision = ++_revision;
    hasError = false;
    try {
      final loadedItems = await notificationService.notifications(group: group);
      if (isDisposed || revision != _revision) {
        return;
      }
      items = loadedItems;
      now = ref.read(appClockProvider).now();
      loaded = true;
    } on Object {
      if (isDisposed || revision != _revision) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  void selectGroup(NotificationGroup value) {
    if (group == value) {
      return;
    }
    group = value;
    notifyListeners();
    load();
  }

  Future<void> markAllRead() => notificationService.markAllRead();

  Future<void> open(AppNotification item) async {
    if (item.unread) {
      await notificationService.markRead(item.id);
    }
  }
}
