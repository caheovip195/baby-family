import 'package:baby_family/data/dto/circle_view.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/service/base.dart';

/// Người thân (CIR-01): chỉ thấy bé/thai kỳ được cấp quyền + ký ức `family`;
/// không có Papa & Mama, nhiệm vụ, Hearts (Skill 8 — “Cấm”).
abstract class ICircleService extends IBaseService {
  /// [childId] = null → mọi bé được cấp quyền.
  Future<CircleView?> view({String? childId});

  /// Lời chúc/bình luận của người thân (khi được quyền bình luận).
  Future<MemoryComment?> sendWish(String memoryId, String body);
}
