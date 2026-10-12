import 'package:baby_family/data/dto/circle_view.dart';
import 'package:baby_family/data/model/circle/circle_post_draft.dart';
import 'package:baby_family/data/model/circle/circle_preferences.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/service/base.dart';

/// Người thân (CIR-01): chỉ thấy bé/thai kỳ được cấp quyền + ký ức `family`;
/// không có Papa & Mama, nhiệm vụ, Hearts (Skill 8 — “Cấm”).
abstract class ICircleService extends IBaseService {
  /// [childId] = null → mọi bé được cấp quyền.
  Future<CircleView?> view({String? childId});

  /// Lời chúc/bình luận của người thân (khi được quyền bình luận).
  Future<MemoryComment?> sendWish(String memoryId, String body);

  // --- Batch 3 (CIR-02…06, SET-10) ---

  /// CIR-02: những lần đầu của cháu (chỉ bé được cấp quyền), mới nhất trước.
  Future<List<Memory>> firsts(String childId);

  /// CIR-03.
  Future<Memory?> memory(String memoryId);

  Future<List<MemoryComment>> wishes(String memoryId);

  /// CIR-03 “Đã thả tim”.
  Future<void> toggleHeart(String memoryId);

  /// CIR-04: bài đăng điền sẵn theo thiết kế.
  Future<CirclePostDraft> postDraft();

  /// CIR-04 “Gửi ảnh” → chờ bố mẹ duyệt (MEM-19).
  Future<void> submitPost(CirclePostDraft post);

  /// CIR-06 thông báo / bản tin + số đã đăng (SET-10).
  Future<CirclePreferences> preferences();

  Future<void> savePreferences(CirclePreferences preferences);

  /// SET-10 “Rời gia đình” → CIR-WAIT; [removeContent] gỡ ảnh & bình luận.
  Future<void> leaveFamily({bool removeContent = false});
}
