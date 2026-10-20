import 'package:baby_family/data/model/memory/comment_record.dart';
import 'package:baby_family/data/model/memory/media_grid_item_record.dart';
import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:baby_family/data/model/memory/on_this_day_record.dart';
import 'package:baby_family/data/model/memory/reaction_state.dart';
import 'package:baby_family/data/model/memory/timeline_item_record.dart';
import 'package:baby_family/data/model/memory/today_story_record.dart';
import 'package:baby_family/data/model/safety/report_record.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/memory_feed.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:baby_family/utils/constants/values.dart';

class MemoryFeedRepositoryImp extends BaseRepositoryImp
    implements IMemoryFeedRepository {
  @override
  Future<MemoryRecord?> createMemory(
    String idempotencyKey,
    JsonMap body,
  ) async {
    final rs = await client!.createMemory(idempotencyKey, body);
    return rs.memory;
  }

  @override
  Future<({List<MemoryRecord> memories, String? nextCursor})> feed(
    String familyId, {
    String? childId,
    String? pregnancyId,
    String? cursor,
    int? limit,
  }) async {
    final rs = await client!.getFeed(
      familyId,
      childId: childId,
      pregnancyId: pregnancyId,
      cursor: cursor,
      limit: limit,
    );
    return (memories: rs.memories, nextCursor: rs.nextCursor);
  }

  @override
  Future<({List<TimelineItemRecord> items, String? nextCursor})> timeline(
    String familyId, {
    String? childId,
    String? pregnancyId,
    String? cursor,
    int? limit,
  }) async {
    final rs = await client!.getTimeline(
      familyId,
      childId: childId,
      pregnancyId: pregnancyId,
      cursor: cursor,
      limit: limit,
    );
    return (items: rs.items, nextCursor: rs.nextCursor);
  }

  @override
  Future<({List<MediaGridItemRecord> items, String? nextCursor})> mediaGrid(
    String familyId, {
    String? childId,
    String? cursor,
    int? limit,
  }) async {
    final rs = await client!.getMediaGrid(
      familyId,
      childId: childId,
      cursor: cursor,
      limit: limit,
    );
    return (items: rs.items, nextCursor: rs.nextCursor);
  }

  @override
  Future<MemoryRecord?> memory(String memoryId) async {
    final rs = await client!.getMemory(memoryId);
    return rs.memory;
  }

  @override
  Future<MemoryRecord?> updateMemory(
    String memoryId,
    int version,
    JsonMap body,
  ) async {
    final rs = await client!.updateMemory(memoryId, '$version', body);
    return rs.memory;
  }

  @override
  Future<List<CommentRecord>> comments(String memoryId) async {
    final rs = await client!.getComments(memoryId);
    return rs.comments;
  }

  @override
  Future<CommentRecord?> addComment(
    String memoryId,
    String body, {
    String? parentCommentId,
  }) async {
    final rs = await client!.addComment(memoryId, {
      'body': body,
      'parentCommentId': ?parentCommentId,
    });
    return rs.comment;
  }

  @override
  Future<CommentRecord?> editComment(String commentId, String body) async {
    final rs = await client!.editComment(commentId, {'body': body});
    return rs.comment;
  }

  @override
  Future<void> deleteComment(String commentId) =>
      client!.deleteComment(commentId);

  @override
  Future<ReactionState?> setReaction(String memoryId, String type) async {
    final rs = await client!.setReaction(memoryId, {'type': type});
    return rs.reaction;
  }

  @override
  Future<ReactionState?> clearReaction(String memoryId) async {
    final rs = await client!.clearReaction(memoryId);
    return rs.reaction;
  }

  @override
  Future<void> trashMemory(String memoryId) => client!.trashMemory(memoryId);

  @override
  Future<({List<MemoryRecord> memories, String? nextCursor})> trash(
    String familyId, {
    String? cursor,
    int? limit,
  }) async {
    final rs = await client!.getTrash(familyId, cursor: cursor, limit: limit);
    return (memories: rs.memories, nextCursor: rs.nextCursor);
  }

  @override
  Future<MemoryRecord?> restoreMemory(String memoryId) async {
    final rs = await client!.restoreMemory(memoryId);
    return rs.memory;
  }

  @override
  Future<void> purgeMemory(String memoryId) => client!.purgeMemory(memoryId);

  @override
  Future<List<MemoryRecord>> search(
    String familyId,
    String query, {
    String? childId,
  }) async {
    final rs = await client!.searchMemories(
      familyId,
      query,
      childId: childId,
      limit: kValueRemoteFeedPageSize,
    );
    return rs.memories;
  }

  @override
  Future<OnThisDayRecord?> onThisDay(String familyId, {String? date}) async =>
      (await client!.getOnThisDay(familyId, date: date)).record;

  @override
  Future<TodayStoryRecord?> todayStory(String childId) async =>
      (await client!.getTodayStory(childId)).story;

  @override
  Future<ReportRecord?> report(JsonMap body) async =>
      (await client!.createReport(body)).report;

  @override
  Future<List<MemoryRecord>> drafts(String familyId) async {
    final rs = await client!.getDrafts(familyId);
    return rs.memories;
  }
}
