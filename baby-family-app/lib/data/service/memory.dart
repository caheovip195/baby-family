import 'package:baby_family/data/dto/memory_search_result.dart';
import 'package:baby_family/data/model/memory/album.dart';
import 'package:baby_family/data/model/memory/bump_photo.dart';
import 'package:baby_family/data/model/memory/collection_summary.dart';
import 'package:baby_family/data/model/memory/day_story.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/model/memory/memory_draft_item.dart';
import 'package:baby_family/data/model/memory/memory_perspective.dart';
import 'package:baby_family/data/model/memory/memory_prompt.dart';
import 'package:baby_family/data/model/memory/milestone_group.dart';
import 'package:baby_family/data/model/memory/milestone_item.dart';
import 'package:baby_family/data/model/memory/milestone_option.dart';
import 'package:baby_family/data/model/memory/month_recap.dart';
import 'package:baby_family/data/model/memory/monthly_photo.dart';
import 'package:baby_family/data/model/memory/on_this_day_group.dart';
import 'package:baby_family/data/model/memory/report_reason.dart';
import 'package:baby_family/data/model/memory/report_receipt.dart';
import 'package:baby_family/data/model/memory/story_item.dart';
import 'package:baby_family/data/model/memory/weekly_recap.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Ký ức, bình luận, góc nhìn, ảnh tháng, bộ sưu tập, story, gợi ý
/// (MEM-01…25, HOME-01/02/03).
abstract class IMemoryService extends IBaseService {
  /// Mới nhất trước. [childId] = null → cả nhà. Ký ức `onlyMe` của người khác
  /// bị ẩn; trường `commentCount`, `perspective*` đã được điền.
  Future<List<Memory>> memories({String? childId, Set<MemoryKind>? kinds});

  Future<Memory?> memory(String id);

  /// MEM-05/23 (+ QC-01). `monthlyPhoto` thay ảnh tháng cũ cùng bé + tháng
  /// (ảnh cũ thành ký ức thường — BR-072).
  Future<Memory> create({
    required MemoryKind kind,
    required List<String> childIds,
    String? title,
    String? body,
    String? quoteContext,
    List<String> mediaAssets = const [],
    MemoryVisibility visibility = MemoryVisibility.family,
    DateTime? occurredAt,
    String? feeling,
    List<String> people = const [],
    String? milestoneCode,
    String? milestoneTitle,
    int? monthIndex,
    int? pregnancyWeek,
    int? voiceDurationSec,
    DateTime? sealedUntil,
    String? missionId,
  });

  Future<void> toggleFavorite(String memoryId);

  /// Thả cảm xúc (emoji) — cộng vào `reactions`.
  Future<void> react(String memoryId, String emoji);

  Future<List<MemoryComment>> comments(String memoryId);

  /// [parentId] → trả lời một bình luận (MEM-10).
  Future<MemoryComment> addComment(
    String memoryId,
    String body, {
    String? parentId,
  });

  Future<List<MemoryPerspective>> perspectives(String memoryId);

  /// MEM-24: mỗi Parent 1 góc nhìn/ký ức (BR-071) — gửi lại sẽ cập nhật.
  Future<MemoryPerspective> savePerspective(
    String memoryId, {
    required String body,
    List<String> mediaAssets = const [],
  });

  /// MEM-20: ảnh tháng chính của bé, theo tháng.
  Future<List<MonthlyPhoto>> monthlyPhotos(String childId);

  /// MEM-21: lưu ảnh tháng (tháng mặc định = tháng tuổi hiện tại).
  Future<Memory> saveMonthlyPhoto(
    String childId, {
    required String asset,
    int? monthIndex,
  });

  /// PREG-02: ảnh bụng theo tuần.
  Future<List<BumpPhoto>> bumpPhotos(String pregnancyId);

  /// Story hôm nay theo bé (HOME-01 vòng story, MEM-25). `seen` theo người xem.
  Future<List<StoryItem>> stories({String? childId});

  Future<void> markStorySeen(String storyId);

  /// MEM-22: bộ sưu tập + số lượng.
  Future<List<CollectionSummary>> collections();

  /// Ký ức thuộc một bộ sưu tập (CollectionDetailPage).
  Future<List<Memory>> collectionMemories(String code);

  /// MEM-22 “Thư gửi con”: số thư còn niêm phong (chưa tới ngày mở).
  Future<int> sealedLetters();

  /// MEM-18 Nháp: bản nháp đang soạn của loại [kind] (MEM-05/23 điền sẵn);
  /// null khi chưa có hoặc đã lưu.
  Future<Memory?> draft(MemoryKind kind);

  /// Xoá nháp sau khi lưu ký ức.
  Future<void> clearDraft(MemoryKind kind);

  /// Gợi ý ghi lại hôm nay (≤ 1/ngày/Parent — BR-073); null khi đã bỏ qua.
  Future<MemoryPrompt?> todayPrompt({String? childId});

  Future<void> dismissPrompt();

  /// Cột mốc catalog + trạng thái đạt được của bé/thai kỳ (MEM-12, HOME-02/03).
  Future<List<MilestoneItem>> milestones(String childId);

  /// MEM-21: nhãn sticker đã dịch cho tháng tuổi.
  Future<List<String>> monthlyStickers(String childId, int monthIndex);

  // --- Batch 2 ---

  /// MEM-03: album tự động trước, album của nhà mình sau.
  Future<List<Album>> albums();

  /// MEM-03a.
  Future<Album?> album(String id);

  Future<Album> createAlbum({required String title, List<String> childIds});

  Future<void> renameAlbum(String id, String title);

  /// MEM-03a “Đổi bìa”.
  Future<void> changeAlbumCover(String id, String asset);

  /// Xoá album — ký ức trong album vẫn được giữ.
  Future<void> deleteAlbum(String id);

  /// MEM-10: sửa / xoá bình luận của chính mình (xoá kèm trả lời).
  Future<void> editComment(String commentId, String body);

  Future<void> deleteComment(String commentId);

  /// MEM-11: nhóm cột mốc (Truyền thống Việt, Cảm xúc…).
  Future<List<MilestoneGroup>> milestoneGroups();

  /// MEM-11: cột mốc của [group] với ngày đã ghi / dự kiến của bé.
  Future<List<MilestoneOption>> milestoneOptions(
    String childId, {
    String? group,
  });

  /// MEM-11: ghi một cột mốc truyền thống/khác cho bé.
  Future<void> recordMilestone(String childId, String code, {DateTime? at});

  /// MEM-13: gợi ý viết nhật ký (đã dịch).
  Future<List<String>> diaryPrompts(String childId);

  /// MEM-15.
  Future<List<String>> searchRecents();

  Future<MemorySearchResult> search(String query, {String? childId});

  /// MEM-16: ký ức cùng ngày các năm trước, gần nhất trước.
  Future<List<OnThisDayGroup>> onThisDay({DateTime? date});

  /// REC-02: tổng kết tuần này.
  Future<WeeklyRecap?> weeklyRecap();

  // --- Batch 3 ---

  /// MEM-17: ký ức đã xoá (giữ 30 ngày), mới xoá trước.
  Future<List<Memory>> trash();

  /// Ngày còn lại trước khi xoá hẳn (`deletedAt` + 30 − hôm nay).
  int trashDaysLeft(Memory memory);

  Future<void> restoreMemory(String memoryId);

  Future<void> deleteForever(String memoryId);

  /// MEM-18: nháp của tôi (trên máy trước, đã lưu trên tài khoản sau).
  Future<List<MemoryDraftItem>> drafts();

  Future<void> deleteDraft(String draftId);

  /// MEM-19: ảnh người thân đăng chờ duyệt, mới nhất trước.
  Future<List<Memory>> pendingPosts();

  Future<void> approvePost(String postId, {List<String>? childIds});

  Future<void> rejectPost(String postId, {String? reason});

  /// MEM-19 lý do từ chối mẫu (đã dịch).
  Future<List<String>> rejectReasons();

  /// RPT-01: lý do báo cáo (đã dịch).
  Future<List<ReportReason>> reportReasons();

  /// RPT-01 → RPT-01b.
  Future<ReportReceipt> submitReport({
    required String targetId,
    required String reasonCode,
    String? note,
    bool hideForMe = false,
    bool removeFromFamily = false,
  });

  /// REC-01: câu chuyện ngày (AI viết, bạn sửa).
  Future<DayStory?> dayStory({String? childId});

  Future<void> saveDayStory(DayStory story);

  /// REC-03: tổng kết tháng tuổi.
  Future<MonthRecap?> monthRecap({String? childId});
}
