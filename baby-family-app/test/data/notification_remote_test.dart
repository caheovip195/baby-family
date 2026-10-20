import 'package:baby_family/data/model/notification/notification_page.dart';
import 'package:baby_family/data/model/notification/notification_record.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/notification.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/notification_remote.dart';
import 'package:baby_family/data/service_imp/notification_remote.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

/// Hộp thông báo giả của server (BF-20261018-011).
class _FakeInbox implements INotificationRemoteRepository {
  List<NotificationRecord> items = const [];
  final reads = <String>[];

  @override
  Future<NotificationPage?> notifications({String? cursor, int? limit}) async =>
      NotificationPage(items: items);

  @override
  Future<int> unreadCount() async =>
      items.where((item) => item.readAt == null).length;

  @override
  Future<void> markRead({List<String>? ids}) async =>
      reads.add(ids == null ? 'all' : ids.join(','));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakeInbox remote;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    remote = _FakeInbox();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({
      kValueSessionKeyServerFamilyId: 'srv-family',
      kValueSessionKeyServerUserId: 'srv-me',
    });
  });

  NotificationRemoteServiceImp service() => NotificationRemoteServiceImp(
    container.read(sessionRepositoryProvider),
    container.read(appClockProvider),
    container.read(notificationRepositoryProvider),
    container.read(familyRepositoryProvider),
    remote,
    l10n: () => lookupAppLocalizations(const Locale('vi')),
  );

  test(
    'NOTI-01: server items are rendered locally and route into the app',
    () async {
      remote.items = [
        NotificationRecord(
          id: 'n1',
          tab: 'FAMILY',
          templateCode: 'NOTI_COMMENT_CREATED',
          params: const {
            'actorUserId': 'srv-partner',
            'entityId': 'mem-1',
            'count': 3,
          },
          createdAt: DateTime.utc(2026, 10, 10, 2),
          deepLink: 'babyfamily://memories/mem-1',
        ),
        NotificationRecord(
          id: 'n2',
          tab: 'US',
          templateCode: 'NOTI_REQUEST_CREATED',
          params: const {'actorUserId': 'srv-partner', 'entityId': 'req-9'},
          createdAt: DateTime.utc(2026, 10, 10, 3),
          readAt: DateTime.utc(2026, 10, 10, 4),
          deepLink: 'babyfamily://us',
        ),
        NotificationRecord(
          id: 'n4',
          tab: 'US',
          templateCode: 'NOTI_EVENT_REMINDER',
          params: const {'eventId': 'ev-1', 'eventType': 'COUPLE'},
          createdAt: DateTime.utc(2026, 10, 8),
          readAt: DateTime.utc(2026, 10, 8, 1),
        ),
        NotificationRecord(
          id: 'n5',
          tab: 'FAMILY',
          templateCode: 'NOTI_BADGE_EARNED',
          params: const {'badgeCode': 'FIRST_WEEK'},
          createdAt: DateTime.utc(2026, 10, 7),
          readAt: DateTime.utc(2026, 10, 7, 1),
        ),
        NotificationRecord(
          id: 'n3',
          tab: 'FAMILY',
          templateCode: 'NOTI_SOMETHING_NEW',
          createdAt: DateTime.utc(2026, 10, 9),
        ),
      ];
      final inbox = await service().notifications();
      expect(inbox.map((item) => item.id), ['n2', 'n1', 'n3', 'n4', 'n5']);
      expect(inbox.last.route, '/care/badges');
      final reminder = inbox[3];
      expect(reminder.text, 'Bạn có một lịch hẹn sắp tới');
      expect(reminder.route, '/calendar');
      final comment = inbox.firstWhere((item) => item.id == 'n1');
      expect(comment.text, 'Có 3 bình luận mới trên một ký ức');
      expect(comment.route, '/memory/mem-1');
      expect(comment.unread, isTrue);
      expect(comment.kind, NotificationKind.comment);
      final request = inbox.firstWhere((item) => item.id == 'n2');
      expect(request.group, NotificationGroup.us);
      expect(request.route, '/us/request/req-9');
      expect(request.unread, isFalse);
      expect(request.text, endsWith('vừa gửi cho bạn một lời nhờ'));
      // A template newer than the app falls back to a generic sentence.
      expect(inbox[2].text, 'Bạn có một cập nhật mới');

      final us = await service().notifications(group: NotificationGroup.us);
      expect(us.map((item) => item.id), ['n2', 'n4']);
      expect(await service().unreadCount(), 2);
    },
  );

  test(
    'NOTI-01: marking read goes to the server and refreshes the screens',
    () async {
      final inbox = service();
      final revision = container.read(mockStoreProvider).revision;
      await inbox.markRead('n1');
      await inbox.markAllRead();
      expect(remote.reads, ['n1', 'all']);
      expect(container.read(mockStoreProvider).revision, greaterThan(revision));
    },
  );
}
