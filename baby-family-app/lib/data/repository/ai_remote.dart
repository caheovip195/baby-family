import 'package:baby_family/data/model/ai/ai_result.dart';
import 'package:baby_family/data/repository/base.dart';

/// AI 1.2 (`/v1/families/{id}/ai/*`, BF-20261028-010).
abstract class IAiRemoteRepository extends IBaseRepository {
  Future<AiStatusRecord?> status(String familyId);

  Future<AiStatusRecord?> consent(String familyId, String feature);

  /// [action] `captions|day-story|rewrite|bridge-summary`.
  Future<AiDraftRecord?> draft(String familyId, String action, JsonMap body);

  /// Báo cáo bản nháp AI (`/v1/reports`, đích `AI_OUTPUT`): server không lưu
  /// đầu ra nên gửi kèm đoạn người dùng đã thấy.
  Future<void> report(String familyId, String invocationId, String text);
}
