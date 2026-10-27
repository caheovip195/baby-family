import 'package:baby_family/data/model/memory/comment_record.dart';
import 'package:baby_family/data/model/memory/media_grid_item_record.dart';
import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:baby_family/data/model/memory/on_this_day_record.dart';
import 'package:baby_family/data/model/memory/reaction_state.dart';
import 'package:baby_family/data/model/memory/timeline_item_record.dart';
import 'package:baby_family/data/model/memory/today_story_record.dart';
import 'package:baby_family/data/model/safety/report_record.dart';
import 'package:baby_family/data/model/sync/change_item.dart';
import 'package:baby_family/data/repository/base.dart';

/// Ký ức trên server (tài liệu kỹ thuật 11.3, 11.5).
abstract class IMemoryFeedRepository extends IBaseRepository {
  /// `POST /v1/memories`; giữ nguyên [idempotencyKey] khi thử lại.
  Future<MemoryRecord?> createMemory(String idempotencyKey, JsonMap body);

  /// `GET /v1/families/{fid}/feed` — mới nhất trước.
  Future<({List<MemoryRecord> memories, String? nextCursor})> feed(
    String familyId, {
    String? childId,
    String? pregnancyId,
    String? cursor,
    int? limit,
  });

  /// `GET /v1/families/{fid}/timeline` — ngày xảy ra mới nhất trước.
  Future<({List<TimelineItemRecord> items, String? nextCursor})> timeline(
    String familyId, {
    String? childId,
    String? pregnancyId,
    String? cursor,
    int? limit,
  });

  /// `GET /v1/families/{fid}/media-grid`.
  Future<({List<MediaGridItemRecord> items, String? nextCursor})> mediaGrid(
    String familyId, {
    String? childId,
    String? cursor,
    int? limit,
  });

  /// `GET /v1/families/{fid}/changes` (offline-first; null cursor = bắt đầu).
  Future<ChangesPage> changes(String familyId, {String? cursor, int? limit});

  /// `GET /v1/memories/{id}`.
  Future<MemoryRecord?> memory(String memoryId);

  /// `PATCH /v1/memories/{id}` với `If-Match: version`.
  Future<MemoryRecord?> updateMemory(
    String memoryId,
    int version,
    JsonMap body,
  );

  /// `GET /v1/memories/{id}/comments` — cũ nhất trước.
  Future<List<CommentRecord>> comments(String memoryId);

  /// `POST /v1/memories/{id}/comments` ([parentCommentId] → trả lời 1 cấp).
  Future<CommentRecord?> addComment(
    String memoryId,
    String body, {
    String? parentCommentId,
    String? idempotencyKey,
  });

  /// `PATCH /v1/comments/{id}`.
  Future<CommentRecord?> editComment(String commentId, String body);

  /// `DELETE /v1/comments/{id}`.
  Future<void> deleteComment(String commentId);

  /// `PUT /v1/memories/{id}/reaction` với loại server ([type]).
  Future<ReactionState?> setReaction(
    String memoryId,
    String type, {
    String? idempotencyKey,
  });

  /// `DELETE /v1/memories/{id}/reaction`.
  Future<ReactionState?> clearReaction(
    String memoryId, {
    String? idempotencyKey,
  });

  /// `DELETE /v1/memories/{id}` — vào thùng rác 30 ngày.
  Future<void> trashMemory(String memoryId);

  /// `GET /v1/families/{fid}/trash` — mới xoá trước.
  Future<({List<MemoryRecord> memories, String? nextCursor})> trash(
    String familyId, {
    String? cursor,
    int? limit,
  });

  /// `POST /v1/memories/{id}/restore`.
  Future<MemoryRecord?> restoreMemory(String memoryId);

  /// `DELETE /v1/memories/{id}/purge` — xoá vĩnh viễn.
  Future<void> purgeMemory(String memoryId);

  /// `GET /v1/families/{fid}/search` (MEM-15).
  Future<List<MemoryRecord>> search(
    String familyId,
    String query, {
    String? childId,
  });

  /// `GET /v1/families/{fid}/on-this-day?date` (MEM-16).
  Future<OnThisDayRecord?> onThisDay(String familyId, {String? date});

  /// `GET /v1/children/{id}/today-story` (MEM-25).
  Future<TodayStoryRecord?> todayStory(String childId);

  /// `POST /v1/reports` (RPT-01).
  Future<ReportRecord?> report(JsonMap body);

  /// `GET /v1/me/drafts?familyId` — nháp đã lưu trên tài khoản (MEM-18).
  Future<List<MemoryRecord>> drafts(String familyId);

  /// `POST /v1/memories/{id}/publish` — đăng nháp của tôi.
  Future<MemoryRecord?> publish(String memoryId);
}
