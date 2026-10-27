import 'package:baby_family/data/model/us/appreciation_record.dart';
import 'package:baby_family/data/model/us/appreciation_wall.dart';
import 'package:baby_family/data/model/us/checkin_record.dart';
import 'package:baby_family/data/model/us/checkin_today.dart';
import 'package:baby_family/data/model/us/journal_entry_record.dart';
import 'package:baby_family/data/model/us/journal_list.dart';
import 'package:baby_family/data/model/us/request_created.dart';
import 'package:baby_family/data/model/us/request_list.dart';
import 'package:baby_family/data/model/us/request_record.dart';
import 'package:baby_family/data/model/us/us_settings_record.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/couple_remote.dart';
import 'package:baby_family/data/repository_imp/base.dart';

class CoupleRemoteRepositoryImp extends BaseRepositoryImp
    implements ICoupleRemoteRepository {
  @override
  Future<CheckinRecord?> createCheckin(
    String familyId,
    JsonMap body, {
    String? idempotencyKey,
  }) async {
    final rs = await client!.createCheckin(
      familyId,
      body,
      idempotencyKey: idempotencyKey,
    );
    return rs.checkin;
  }

  @override
  Future<CheckinToday?> checkinsToday(String familyId) async {
    final rs = await client!.getCheckinsToday(familyId);
    return rs.today;
  }

  @override
  Future<RequestCreated?> createRequest(
    String familyId,
    String idempotencyKey,
    JsonMap body,
  ) async {
    final rs = await client!.createRequest(familyId, idempotencyKey, body);
    return rs.created;
  }

  @override
  Future<RequestList?> requests(
    String familyId, {
    String? box,
    String? cursor,
    int? limit,
  }) async {
    final rs = await client!.getRequests(
      familyId,
      box: box,
      cursor: cursor,
      limit: limit,
    );
    return rs.page;
  }

  @override
  Future<AppreciationRecord?> createAppreciation(
    String familyId,
    JsonMap body, {
    String? idempotencyKey,
  }) async {
    final rs = await client!.createAppreciation(
      familyId,
      body,
      idempotencyKey: idempotencyKey,
    );
    return rs.appreciation;
  }

  @override
  Future<AppreciationWall?> appreciations(
    String familyId, {
    String? cursor,
    int? limit,
    String? month,
  }) async {
    final rs = await client!.getAppreciations(
      familyId,
      cursor: cursor,
      limit: limit,
      month: month,
    );
    return rs.wall;
  }

  @override
  Future<AppreciationRecord?> reactAppreciation(
    String familyId,
    String appreciationId,
    String reaction,
  ) async {
    final rs = await client!.reactAppreciation(familyId, appreciationId, {
      'reaction': reaction,
    });
    return rs.appreciation;
  }

  @override
  Future<JournalList?> journal(
    String familyId, {
    String? cursor,
    int? limit,
  }) async {
    final rs = await client!.getJournal(familyId, cursor: cursor, limit: limit);
    return rs.page;
  }

  @override
  Future<JournalEntryRecord?> createJournalEntry(
    String familyId,
    JsonMap body, {
    String? idempotencyKey,
  }) async {
    final rs = await client!.createJournalEntry(
      familyId,
      body,
      idempotencyKey: idempotencyKey,
    );
    return rs.entry;
  }

  @override
  Future<void> shareJournalExcerpt(
    String familyId,
    String entryId,
    String excerpt,
  ) => client!.shareJournalExcerpt(familyId, entryId, {'excerpt': excerpt});

  @override
  Future<RequestRecord?> requestAction(
    String familyId,
    String requestId,
    String action, [
    JsonMap body = const {},
  ]) async {
    final rs = await client!.requestAction(familyId, requestId, action, body);
    return rs.request;
  }

  @override
  Future<void> requestAppreciationShare(
    String familyId,
    String appreciationId,
  ) => client!.requestAppreciationShare(familyId, appreciationId);

  @override
  Future<void> respondAppreciationShare(
    String familyId,
    String appreciationId, {
    required bool approve,
  }) => client!.respondAppreciationShare(familyId, appreciationId, {
    'approve': approve,
  });

  @override
  Future<UsSettingsRecord?> usSettings() async {
    final rs = await client!.getUsSettings();
    return rs.settings;
  }

  @override
  Future<UsSettingsRecord?> updateUsSettings(JsonMap patch) async {
    final rs = await client!.updateUsSettings(patch);
    return rs.settings;
  }
}
