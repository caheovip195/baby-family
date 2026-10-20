import 'package:baby_family/data/model/notification/app_notification.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/notification.dart';
import 'package:baby_family/data/repository/notification_remote.dart';
import 'package:baby_family/data/repository_imp/notification.dart';
import 'package:baby_family/data/repository_imp/notification_remote.dart';
import 'package:baby_family/data/service/notification.dart';
import 'package:baby_family/data/service_imp/notification.dart';
import 'package:baby_family/data/service_imp/notification_remote.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final notificationRepositoryProvider = Provider<INotificationRepository>(
  (ref) => NotificationRepositoryImp(ref.watch(mockStoreProvider)),
);

final notificationRemoteRepositoryProvider =
    Provider<INotificationRemoteRepository>(
      (ref) => NotificationRemoteRepositoryImp(),
    );

/// Bản mock, hoặc hộp thông báo của server khi chạy với `BABY_FAMILY_API_URL`.
final notificationServiceProvider = Provider<INotificationService>(
  (ref) => kValueUseRemoteSession
      ? NotificationRemoteServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(notificationRepositoryProvider),
          ref.watch(familyRepositoryProvider),
          ref.watch(notificationRemoteRepositoryProvider),
        )
      : NotificationServiceImp(
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
