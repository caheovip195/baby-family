import 'package:baby_family/data/model/notification/app_notification.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/notification.dart';
import 'package:baby_family/data/repository_imp/notification.dart';
import 'package:baby_family/data/service/notification.dart';
import 'package:baby_family/data/service_imp/notification.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final notificationRepositoryProvider = Provider<INotificationRepository>(
  (ref) => NotificationRepositoryImp(ref.watch(mockStoreProvider)),
);

final notificationServiceProvider = Provider<INotificationService>(
  (ref) => NotificationServiceImp(
    ref.watch(sessionRepositoryProvider),
    ref.watch(appClockProvider),
    ref.watch(notificationRepositoryProvider),
  ),
);

final notificationsProvider = FutureProvider<List<AppNotification>>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(notificationServiceProvider).notifications();
});

/// Chấm đỏ trên chuông HOME-01.
final unreadNotificationCountProvider = FutureProvider<int>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(notificationServiceProvider).unreadCount();
});
