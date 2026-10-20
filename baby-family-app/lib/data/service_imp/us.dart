import 'package:baby_family/data/dto/couple_today.dart';
import 'package:baby_family/data/model/us/bridge_next_step.dart';
import 'package:baby_family/data/model/us/bridge_option.dart';
import 'package:baby_family/data/model/us/bridge_session.dart';
import 'package:baby_family/data/model/us/couple_request.dart';
import 'package:baby_family/data/model/us/couple_settings.dart';
import 'package:baby_family/data/model/us/couple_week.dart';
import 'package:baby_family/data/model/us/daily_question.dart';
import 'package:baby_family/data/model/us/journal_entry.dart';
import 'package:baby_family/data/model/us/mood_checkin.dart';
import 'package:baby_family/data/model/us/rewrite_suggestion.dart';
import 'package:baby_family/data/model/us/safety_hotline.dart';
import 'package:baby_family/data/model/us/thanks.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/care.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';

class UsServiceImp extends MockServiceImp implements IUsService {
  UsServiceImp(
    super.sessionRepository,
    super.clock,
    this._repository,
    this._familyRepository,
    this._careRepository,
  );

  final IUsRepository _repository;
  final IFamilyRepository _familyRepository;
  final ICareRepository _careRepository;

  String? get _partnerUserId => _familyRepository
      .members(familyId)
      .where(
        (row) =>
            row['role'] != FamilyRole.relative.name &&
            row['userId'] != myUserId &&
            row['status'] == MemberStatus.active.name,
      )
      .map((row) => row['userId'] as String?)
      .firstOrNull;

  static DateTime _date(JsonMap row, String key) =>
      DateTime.parse(row[key] as String);

  bool _alive(JsonMap row) {
    final expires = row['expiresAt'] as String?;
    return expires == null || DateTime.parse(expires).isAfter(now);
  }

  MoodCheckin? _latestCheckin(String? userId, {bool sharedOnly = false}) {
    final rows =
        _repository
            .checkins(familyId)
            .where(
              (row) =>
                  row['userId'] == userId &&
                  _alive(row) &&
                  (!sharedOnly || row['shared'] == true),
            )
            .toList()
          ..sort(
            (a, b) => _date(b, 'createdAt').compareTo(_date(a, 'createdAt')),
          );
    return rows.isEmpty ? null : MoodCheckin.fromJson(rows.first);
  }

  @override
  Future<CoupleToday> coupleToday() async {
    await ready();
    final thanks = await this.thanks();
    return CoupleToday(
      myCheckin: _latestCheckin(myUserId),
      partnerCheckin: _latestCheckin(_partnerUserId, sharedOnly: true),
      openRequests: await requests(openOnly: true),
      question: _question(),
      recentThanks: thanks,
    );
  }

  DailyQuestion? _question() {
    final questions = _repository.dailyQuestions();
    if (questions.isEmpty) {
      return null;
    }
    final dayIndex = today.difference(DateTime(today.year)).inDays;
    final answers = _repository
        .questionAnswers(familyId)
        .where((row) => MockServiceImp.sameDay(_date(row, 'date'), today))
        .toList();
    String? answerOf(String? userId) => answers
        .where((row) => row['userId'] == userId)
        .map((row) => row['answer'] as String?)
        .firstOrNull;
    final mine = answerOf(myUserId);
    final partner = answerOf(_partnerUserId);
    return DailyQuestion(
      id: 'q-${today.toIso8601String()}',
      date: today,
      text: questions[dayIndex % questions.length],
      myAnswer: mine,
      // Hidden until both have answered.
      partnerAnswer: mine == null ? null : partner,
      partnerAnswered: partner != null,
    );
  }

  @override
  Future<MoodCheckin> checkIn({
    required MoodCode mood,
    int energy = 3,
    List<CoupleNeed> needs = const [],
    String? note,
    bool shared = true,
  }) async {
    await ready();
    final midnight = DateTime(today.year, today.month, today.day, 23, 59);
    final sixHours = now.add(kValueMoodLifetime);
    return MoodCheckin.fromJson(
      _repository.addCheckin({
        'familyId': familyId,
        'userId': myUserId,
        'mood': mood.name,
        'energy': energy,
        'needs': [for (final need in needs) need.name],
        'note': ?note,
        'shared': shared,
        'createdAt': now.toIso8601String(),
        'expiresAt': (sixHours.isBefore(midnight) ? sixHours : midnight)
            .toIso8601String(),
      }),
    );
  }

  @override
  Future<List<CoupleRequest>> requests({bool openOnly = false}) async {
    await ready();
    final rows =
        _repository
            .requests(familyId)
            .map(CoupleRequest.fromJson)
            .where((request) => !openOnly || request.status.isOpen)
            .toList()
          ..sort((a, b) => b.sentAt.compareTo(a.sentAt));
    return rows;
  }

  @override
  Future<CoupleRequest?> request(String id) async {
    await ready();
    final row = _repository.request(id);
    return row == null ? null : CoupleRequest.fromJson(row);
  }

  @override
  Future<CoupleRequest> sendRequest({
    RequestKind kind = RequestKind.task,
    String? templateCode,
    CoupleNeed? needCode,
    String title = '',
    String? message,
    List<String> childIds = const [],
    String? dueLabel,
    DateTime? dueAt,
    int? durationMin,
    RequestUrgency urgency = RequestUrgency.normal,
  }) async {
    await ready();
    final open = (await requests(
      openOnly: true,
    )).where((request) => request.senderId == myUserId).length;
    if (open >= kValueMaxOpenRequests) {
      throw StateError('BR-067: at most $kValueMaxOpenRequests open requests');
    }
    return CoupleRequest.fromJson(
      _repository.addRequest({
        'familyId': familyId,
        'kind': kind.name,
        'templateCode': ?templateCode,
        'needCode': ?needCode?.name,
        'title': title.trim(),
        'message': ?message,
        'childIds': childIds,
        'dueLabel': ?dueLabel,
        'dueAt': (dueAt ?? now).toIso8601String(),
        'durationMin': ?durationMin,
        'urgency': urgency.name,
        'status': RequestStatus.sent.name,
        'senderId': myUserId,
        'receiverId': _partnerUserId ?? '',
        'sentAt': now.toIso8601String(),
      }),
    );
  }

  void _patch(String id, JsonMap patch) {
    _repository.updateRequest(id, patch);
  }

  @override
  Future<void> markSeen(String id) async {
    final current = await request(id);
    if (current != null && current.status == RequestStatus.sent) {
      _patch(id, {
        'status': RequestStatus.seen.name,
        'seenAt': now.toIso8601String(),
      });
    }
  }

  @override
  Future<void> accept(String id) async {
    await ready();
    _patch(id, {
      'status': RequestStatus.accepted.name,
      'acceptedAt': now.toIso8601String(),
    });
  }

  @override
  Future<void> decline(String id, {String? reason}) async {
    await ready();
    _patch(id, {
      'status': RequestStatus.declined.name,
      'declinedAt': now.toIso8601String(),
      'declineReason': ?reason,
    });
  }

  @override
  Future<void> markDone(String id) async {
    final current = await request(id);
    if (current == null) {
      return;
    }
    _patch(id, {
      'status': RequestStatus.done.name,
      'doneAt': now.toIso8601String(),
    });
    if (current.kind == RequestKind.task) {
      _careRepository.addHearts({
        'familyId': familyId,
        'userId': current.receiverId,
        'hearts': kValueRequestDoneHearts,
        'requestId': id,
        'title': current.title,
        'at': now.toIso8601String(),
      });
    }
  }

  @override
  Future<void> acknowledge(String id) async {
    await ready();
    _patch(id, {'status': RequestStatus.acknowledged.name});
  }

  @override
  Future<void> cancel(String id) async {
    await ready();
    _patch(id, {'status': RequestStatus.cancelled.name});
  }

  @override
  Future<void> setReminder(String id, DateTime at) async {
    await ready();
    _patch(id, {'remindAt': at.toIso8601String()});
  }

  @override
  Future<Thanks> sendThanks({
    required String body,
    String? sticker,
    String? missionId,
    String? memoryId,
    bool proposeFamilyMoment = false,
  }) async {
    await ready();
    return Thanks.fromJson(
      _repository.addThanks({
        'familyId': familyId,
        'fromUserId': myUserId,
        'toUserId': _partnerUserId ?? '',
        'body': body.trim(),
        'sticker': ?sticker,
        'missionId': ?missionId,
        'memoryId': ?memoryId,
        'createdAt': now.toIso8601String(),
        if (proposeFamilyMoment) 'shareRequested': true,
      }),
    );
  }

  @override
  Future<void> respondThanksShare(
    String thanksId, {
    required bool approve,
  }) async {
    await ready();
    _repository.updateThanks(thanksId, {
      'shareRequested': false,
      'postedToFamily': approve,
    });
  }

  @override
  Future<List<Thanks>> thanks() async {
    await ready();
    return _repository.thanks(familyId).map(Thanks.fromJson).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> answerQuestion(String answer) async {
    await ready();
    _repository.addQuestionAnswer({
      'familyId': familyId,
      'userId': myUserId,
      'date': today.toIso8601String(),
      'answer': answer.trim(),
    });
  }

  // ------------------------------------------------------------ batch 2

  @override
  Future<List<Thanks>> thanksWall({DateTime? month}) async {
    await ready();
    final rows = _repository.thanks(familyId).where((row) {
      if (month == null) {
        return true;
      }
      final at = DateTime.parse(row['createdAt'] as String);
      return at.year == month.year && at.month == month.month;
    }).toList();
    int order(JsonMap row) => (row['wallOrder'] as int?) ?? 1 << 20;
    rows.sort((a, b) {
      final byOrder = order(a).compareTo(order(b));
      return byOrder != 0
          ? byOrder
          : (b['createdAt'] as String).compareTo(a['createdAt'] as String);
    });
    return rows.map(Thanks.fromJson).toList();
  }

  @override
  Future<void> toggleThanksHeart(String thanksId) async {
    await ready();
    final row = _repository
        .thanks(familyId)
        .where((item) => item['id'] == thanksId)
        .firstOrNull;
    if (row == null) {
      return;
    }
    final reacted = [...((row['reactedByUserIds'] as List?) ?? const [])];
    reacted.contains(myUserId)
        ? reacted.remove(myUserId)
        : reacted.add(myUserId);
    _repository.updateThanks(thanksId, {'reactedByUserIds': reacted});
  }

  @override
  Future<List<JournalEntry>> journal() async {
    await ready();
    return _repository.journal(myUserId).map(JournalEntry.fromJson).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<JournalEntry> addJournalEntry({
    required JournalMood mood,
    required String title,
    String body = '',
    String? photoAsset,
  }) async {
    await ready();
    return JournalEntry.fromJson(
      _repository.addJournal({
        'familyId': familyId,
        'userId': myUserId,
        'createdAt': now.toIso8601String(),
        'showTime': true,
        'mood': mood.name,
        'title': title.trim(),
        'body': body.trim(),
        'photoAsset': ?photoAsset,
      }),
    );
  }

  @override
  Future<void> shareJournalExcerpt(String entryId) async {
    await ready();
    _repository.updateJournal(entryId, {'sharedExcerpt': true});
  }

  @override
  Future<CoupleSettings> coupleSettings() async {
    await ready();
    return CoupleSettings.fromJson(_repository.coupleSettings());
  }

  @override
  Future<void> saveCoupleSettings(CoupleSettings settings) async {
    await ready();
    _repository.saveCoupleSettings(settings.toJson());
  }

  // ------------------------------------------------------------ batch 3

  JsonMap get _bridgeCatalog => Map<String, dynamic>.from(
    (_repository.catalog()['bridge'] as Map?) ?? const {},
  );

  @override
  Future<List<BridgeOption>> bridgeOptions(String group) async {
    await ready();
    final partner = _familyRepository
        .members(familyId)
        .where(
          (row) =>
              row['role'] != FamilyRole.relative.name &&
              row['userId'] != myUserId,
        )
        .map((row) => row['callName'] as String?)
        .firstOrNull;
    return [
      for (final row in (_bridgeCatalog[group] as List?) ?? const [])
        BridgeOption.fromJson({
          ...Map<String, dynamic>.from(row as Map),
          'title': (row['title'] as String).replaceAll(
            '{partner}',
            partner ?? '',
          ),
        }),
    ];
  }

  @override
  Future<BridgeSession?> bridgeDraft() async {
    await ready();
    final row = _repository
        .bridgeSessions(familyId)
        .where(
          (row) =>
              row['status'] == BridgeStatus.draft.name &&
              row['initiatorUserId'] == myUserId,
        )
        .firstOrNull;
    return row == null ? null : BridgeSession.fromJson(row);
  }

  @override
  Future<void> saveBridgeDraft(BridgeSession draft) async {
    await ready();
    if (_repository.bridgeSession(draft.id) == null) {
      _repository.addBridgeSession({...draft.toJson(), 'familyId': familyId});
    } else {
      _repository.updateBridgeSession(draft.id, draft.toJson());
    }
  }

  @override
  Future<BridgeSession?> bridgeSession(String id) async {
    await ready();
    final row = _repository.bridgeSession(id);
    return row == null ? null : BridgeSession.fromJson(row);
  }

  @override
  Future<List<BridgeSession>> bridgeSessions() async {
    await ready();
    return _repository
        .bridgeSessions(familyId)
        .where((row) => row['status'] != BridgeStatus.draft.name)
        .map(BridgeSession.fromJson)
        .toList();
  }

  void _bridge(String id, JsonMap patch) =>
      _repository.updateBridgeSession(id, patch);

  @override
  Future<void> sendBridgeInvite(String draftId) async {
    await ready();
    _bridge(draftId, {'status': BridgeStatus.invited.name});
  }

  @override
  Future<void> joinBridge(String sessionId) async {
    await ready();
    _bridge(sessionId, {
      'status': BridgeStatus.active.name,
      'startedAt': now.toIso8601String(),
    });
  }

  @override
  Future<void> pauseBridge(String sessionId) async {
    await ready();
    _bridge(sessionId, {'status': BridgeStatus.paused.name});
  }

  Future<void> _patchMyShare(String sessionId, JsonMap patch) async {
    final session = await bridgeSession(sessionId);
    if (session == null) {
      return;
    }
    _bridge(sessionId, {
      'shares': [
        for (final share in session.shares)
          share.userId == myUserId
              ? {...share.toJson(), ...patch}
              : share.toJson(),
      ],
    });
  }

  @override
  Future<void> markBridgeUnderstood(String sessionId) async {
    await _patchMyShare(sessionId, {'understood': true, 'readDone': true});
    final session = await bridgeSession(sessionId);
    if (session != null && session.shares.every((share) => share.understood)) {
      _bridge(sessionId, {'status': BridgeStatus.nextStep.name});
    }
  }

  @override
  Future<void> clarifyBridgeShare(String sessionId, String message) async {
    await ready();
    await _patchMyShare(sessionId, {'message': message});
  }

  @override
  Future<void> chooseNextStep(String sessionId, BridgeNextStep step) async {
    await ready();
    _bridge(sessionId, {
      'status': BridgeStatus.nextStep.name,
      'nextStep': step.toJson(),
    });
  }

  @override
  Future<void> confirmNextStep(String sessionId) async {
    final session = await bridgeSession(sessionId);
    final step = session?.nextStep;
    if (step == null) {
      return;
    }
    _bridge(sessionId, {
      'nextStep': step
          .copyWith(agreedUserIds: {...step.agreedUserIds, myUserId}.toList())
          .toJson(),
    });
  }

  @override
  Future<void> closeBridge(String sessionId) async {
    final session = await bridgeSession(sessionId);
    if (session == null) {
      return;
    }
    final agreed = {...session.closeAgreedUserIds, myUserId}.toList();
    _bridge(sessionId, {
      'closeAgreedUserIds': agreed,
      if (agreed.length >= 2) 'status': BridgeStatus.closed.name,
    });
  }

  @override
  Future<RewriteSuggestion?> rewriteSuggestion() async {
    await ready();
    final row = _repository.bridgeRewrite();
    return row.isEmpty ? null : RewriteSuggestion.fromJson(row);
  }

  @override
  Future<List<SafetyHotline>> safetyHotlines() async {
    await ready();
    return [
      for (final row
          in (_repository.catalog()['safetyHotlines'] as List?) ?? const [])
        SafetyHotline.fromJson(Map<String, dynamic>.from(row as Map)),
    ];
  }

  @override
  Future<CoupleWeek?> coupleWeek() async {
    await ready();
    final row = _repository.coupleWeek();
    return row.isEmpty ? null : CoupleWeek.fromJson(row);
  }
}
