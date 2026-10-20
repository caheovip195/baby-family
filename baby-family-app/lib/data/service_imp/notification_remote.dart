import 'package:baby_family/data/model/notification/app_notification.dart';
import 'package:baby_family/data/model/notification/notification_record.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/notification.dart';
import 'package:baby_family/data/repository/notification_remote.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/service_imp/notification.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';

/// NOTI-01 qua server thật (BF-20261018-011): hộp thông báo của chính tôi, số
/// chưa đọc, đánh dấu đã đọc. Server trả `templateCode` + `params` an toàn; app
/// dựng câu bằng l10n (Skill 10) và đổi `deepLink`/id thành route của app.
/// Thông báo nhạy cảm (Papa & Mama) không có nội dung, chỉ nêu tên người gửi.
class NotificationRemoteServiceImp extends NotificationServiceImp {
  NotificationRemoteServiceImp(
    ISessionRepository sessionRepository,
    AppClock clock,
    this._store,
    this._family,
    this._remote, {
    AppLocalizations Function()? l10n,
  }) : _l10n = l10n ?? currentL10n,
       super(sessionRepository, clock, _store);

  final INotificationRepository _store;
  final IFamilyRepository _family;
  final INotificationRemoteRepository _remote;
  final AppLocalizations Function() _l10n;

  /// Hộp thư lưu 90 ngày (đặc tả 7.21) — đọc tối đa ngần này trang.
  static const _maxPages = 10;

  String? get _serverFamilyId =>
      sessionRepository.session()[kValueSessionKeyServerFamilyId] as String?;

  @override
  Future<List<AppNotification>> notifications({
    NotificationGroup group = NotificationGroup.all,
  }) async {
    if (_serverFamilyId == null) {
      return super.notifications(group: group);
    }
    await ready();
    final items = <AppNotification>[];
    String? cursor;
    for (var page = 0; page < _maxPages; page++) {
      final result = await _remote.notifications(
        cursor: cursor,
        limit: kValueRemoteFeedPageSize,
      );
      for (final record in result?.items ?? const <NotificationRecord>[]) {
        final item = _toNotification(record);
        if (item != null &&
            (group == NotificationGroup.all || item.group == group)) {
          items.add(item);
        }
      }
      final next = result?.nextCursor;
      if (next == null || next == cursor) {
        break;
      }
      cursor = next;
    }
    return items..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<int> unreadCount() async {
    if (_serverFamilyId == null) {
      return super.unreadCount();
    }
    return _remote.unreadCount();
  }

  @override
  Future<void> markRead(String id) async {
    if (_serverFamilyId == null) {
      return super.markRead(id);
    }
    await _remote.markRead(ids: [id]);
    _store.touch();
  }

  @override
  Future<void> markAllRead() async {
    if (_serverFamilyId == null) {
      return super.markAllRead();
    }
    await _remote.markRead();
    _store.touch();
  }

  AppNotification? _toNotification(NotificationRecord record) {
    final id = record.id;
    if (id == null) {
      return null;
    }
    final code = record.templateCode ?? '';
    final params = record.params;
    final entityId = params['entityId'] as String?;
    final name = _actorName(params['actorUserId'] as String?);
    final count = (params['count'] as num?)?.toInt() ?? 1;
    final l10n = _l10n();
    final (kind, text, route) = switch (code) {
      'NOTI_MEMORY_PUBLISHED' => (
        NotificationKind.memory,
        l10n.notiMemoryPublished(name),
        _memoryRoute(record, entityId),
      ),
      'NOTI_COMMENT_CREATED' => (
        NotificationKind.comment,
        l10n.notiCommentCreated(name, count),
        _memoryRoute(record, entityId),
      ),
      'NOTI_REACTION_CHANGED' => (
        NotificationKind.comment,
        l10n.notiReactionChanged(name, count),
        _memoryRoute(record, entityId),
      ),
      'NOTI_REQUEST_CREATED' => (
        NotificationKind.request,
        l10n.notiRequestCreated(name),
        _requestRoute(entityId),
      ),
      'NOTI_REQUEST_ACCEPTED' => (
        NotificationKind.request,
        l10n.notiRequestAccepted(name),
        _requestRoute(entityId),
      ),
      'NOTI_REQUEST_DONE' => (
        NotificationKind.request,
        l10n.notiRequestDone(name),
        _requestRoute(entityId),
      ),
      'NOTI_REQUEST_DECLINED' => (
        NotificationKind.request,
        l10n.notiRequestDeclined(name),
        _requestRoute(entityId),
      ),
      'NOTI_REQUEST_ACKNOWLEDGED' => (
        NotificationKind.request,
        l10n.notiRequestAcknowledged(name),
        _requestRoute(entityId),
      ),
      'NOTI_CHECKIN_SHARED' => (
        NotificationKind.support,
        l10n.notiCheckinShared(name),
        '/main/us',
      ),
      'NOTI_APPRECIATION_CREATED' => (
        NotificationKind.support,
        l10n.notiAppreciationCreated,
        '/us/thanks',
      ),
      // CAL-02: sự kiện riêng tư (Hai ta, ghi chú) không có tiêu đề.
      'NOTI_EVENT_REMINDER' => (
        NotificationKind.mission,
        switch (params['title']) {
          final String title when title.isNotEmpty => l10n.notiEventReminder(
            title,
          ),
          _ => l10n.notiEventReminderPrivate,
        },
        '/calendar',
      ),
      'NOTI_BADGE_EARNED' => (
        NotificationKind.tree,
        l10n.notiBadgeEarned,
        '/care/badges',
      ),
      _ => (NotificationKind.system, l10n.notiGeneric, null),
    };
    return AppNotification(
      id: id,
      group: record.tab == 'US'
          ? NotificationGroup.us
          : NotificationGroup.family,
      kind: kind,
      text: text,
      createdAt: (record.createdAt ?? now).toLocal(),
      unread: record.readAt == null,
      route: route,
    );
  }

  /// `babyfamily://memories/{id}` hoặc `entityId` → MEM-07.
  static String? _memoryRoute(NotificationRecord record, String? entityId) {
    final link = record.deepLink ?? '';
    const prefix = 'babyfamily://memories/';
    final id = link.startsWith(prefix)
        ? link.substring(prefix.length)
        : entityId;
    return id == null || id.isEmpty ? null : '/memory/$id';
  }

  static String _requestRoute(String? requestId) =>
      requestId == null ? '/main/us' : '/us/request/$requestId';

  /// Người thao tác (thường là bạn đời) → tên gọi trên máy; không rõ → câu chung.
  String _actorName(String? serverUserId) {
    final members = _family.members(familyId);
    final serverMe = sessionRepository.session()[kValueSessionKeyServerUserId];
    final member = serverUserId != null && serverUserId == serverMe
        ? members.where((row) => row['userId'] == myUserId).firstOrNull
        : members
              .where(
                (row) =>
                    row['userId'] != myUserId &&
                    row['role'] != FamilyRole.relative.name,
              )
              .firstOrNull;
    final name = (member?['callName'] ?? member?['displayName']) as String?;
    return name == null || name.trim().isEmpty ? _l10n().notiSomeone : name;
  }
}
