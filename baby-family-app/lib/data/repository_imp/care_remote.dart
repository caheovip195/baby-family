import 'package:baby_family/data/model/care/badge_record.dart';
import 'package:baby_family/data/model/care/calendar_event_record.dart';
import 'package:baby_family/data/model/care/calendar_record.dart';
import 'package:baby_family/data/model/care/family_tree_record.dart';
import 'package:baby_family/data/model/care/hearts_me_record.dart';
import 'package:baby_family/data/model/care/mission_board_record.dart';
import 'package:baby_family/data/model/care/mission_history_page.dart';
import 'package:baby_family/data/model/care/mission_record.dart';
import 'package:baby_family/data/model/care/mission_result_record.dart';
import 'package:baby_family/data/model/care/mission_series_record.dart';
import 'package:baby_family/data/model/care/mission_settings_record.dart';
import 'package:baby_family/data/model/care/mission_swap_options_record.dart';
import 'package:baby_family/data/model/care/mission_template_record.dart';
import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/care_remote.dart';
import 'package:baby_family/data/repository_imp/base.dart';

class CareRemoteRepositoryImp extends BaseRepositoryImp
    implements ICareRemoteRepository {
  @override
  Future<MissionBoardRecord?> board(
    String familyId, {
    required String tab,
    String? date,
    String? childId,
  }) async {
    final rs = await client!.getMissionBoard(
      familyId,
      date: date,
      tab: tab,
      childId: childId,
    );
    return rs.board;
  }

  @override
  Future<List<MissionTemplateRecord>> templates(
    String familyId, {
    String? childId,
  }) async {
    final rs = await client!.getMissionTemplates(
      familyId: familyId,
      childId: childId,
    );
    return rs.list?.items ?? const [];
  }

  @override
  Future<MissionRecord?> mission(String missionId) async {
    final rs = await client!.getMission(missionId);
    return rs.mission;
  }

  @override
  Future<MissionResultRecord?> createMission(
    String idempotencyKey,
    JsonMap body,
  ) async {
    final rs = await client!.createMission(idempotencyKey, body);
    return rs.result;
  }

  @override
  Future<MissionResultRecord?> complete(
    String missionId,
    String idempotencyKey, [
    JsonMap body = const {},
  ]) async {
    final rs = await client!.completeMission(
      missionId,
      'complete',
      idempotencyKey,
      body,
    );
    return rs.result;
  }

  @override
  Future<MissionResultRecord?> action(
    String missionId,
    String action, [
    JsonMap body = const {},
  ]) async {
    final rs = await client!.missionAction(missionId, action, body);
    return rs.result;
  }

  @override
  Future<HeartsMeRecord?> myHearts(String familyId, {int? limit}) async {
    final rs = await client!.getMyHearts(familyId, limit: limit);
    return rs.hearts;
  }

  @override
  Future<FamilyTreeRecord?> familyTree(String familyId) async {
    final rs = await client!.getFamilyTree(familyId);
    return rs.tree;
  }

  @override
  Future<List<BadgeRecord>> badges(String familyId) async {
    final rs = await client!.getBadges(familyId);
    return rs.list?.items ?? const [];
  }

  @override
  Future<MissionHistoryPage?> missionHistory(
    String familyId, {
    required String from,
    required String to,
    required String owner,
    String? cursor,
  }) async {
    final rs = await client!.getMissionHistory(
      familyId,
      from: from,
      to: to,
      owner: owner,
      cursor: cursor,
    );
    return rs.page;
  }

  @override
  Future<MissionSwapOptionsRecord?> swapOptions(String missionId) async {
    final rs = await client!.getMissionSwapOptions(missionId);
    return rs.options;
  }

  @override
  Future<CalendarRecord?> calendar(
    String familyId, {
    required String from,
    required String to,
  }) async {
    final rs = await client!.getCalendar(familyId, from: from, to: to);
    return rs.calendar;
  }

  @override
  Future<CalendarEventRecord?> createEvent(JsonMap body) async {
    final rs = await client!.createEvent(body);
    return rs.event;
  }

  @override
  Future<MemoryRecord?> saveMoment(
    String missionId,
    String idempotencyKey,
    JsonMap body,
  ) async {
    final rs = await client!.saveMissionMoment(missionId, idempotencyKey, body);
    return rs.memory;
  }

  @override
  Future<MissionSeriesRecord?> createSeries(
    String familyId,
    JsonMap body,
  ) async {
    final rs = await client!.createMissionSeries(familyId, body);
    return rs.series;
  }

  @override
  Future<MissionSettingsRecord?> missionSettings(String familyId) async {
    final rs = await client!.getMissionSettings(familyId);
    return rs.settings;
  }

  @override
  Future<MissionSettingsRecord?> updateBoardLevel(
    String familyId,
    String level,
  ) async {
    final rs = await client!.updateMissionSettings(familyId, {
      'boardLevel': level,
    });
    return rs.settings;
  }

  @override
  Future<MissionSettingsRecord?> updatePreferences(
    String familyId,
    JsonMap patch,
  ) async {
    final rs = await client!.updateMissionPreferences(familyId, patch);
    return rs.settings;
  }

  @override
  Future<List<MissionSeriesRecord>> missionSeries(String familyId) async =>
      (await client!.getMissionSeries(familyId)).list?.items ?? const [];

  @override
  Future<void> pauseSeries(String seriesId, String from, String to) =>
      client!.pauseMissionSeries(seriesId, {'from': from, 'to': to});

  @override
  Future<void> endSeries(String seriesId) => client!.endMissionSeries(seriesId);
}
