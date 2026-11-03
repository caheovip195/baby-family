import 'package:baby_family/data/model/ai/ai_result.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Lần đầu dùng một tính năng AI: cần người dùng đồng ý gửi dữ liệu (7.18).
class AiConsentRequired implements Exception {
  const AiConsentRequired(this.feature);

  final AiFeature feature;
}

/// AI 1.2 (BF-20261028-010): chỉ chạy khi người dùng bấm; mọi đầu ra là bản
/// nháp để sửa / bỏ.
abstract class IAiService extends IBaseService {
  Future<AiStatusRecord> status();

  Future<void> grantConsent(AiFeature feature);

  /// 3 gợi ý chú thích từ vài từ người dùng gõ ([AiDraftRecord.suggestions]).
  Future<AiDraftRecord> captions({String? kind, String? hint});

  /// Đoạn 3–6 câu từ các ký ức người dùng tick chọn ([AiDraftRecord.story]).
  Future<AiDraftRecord> dayStory({
    required String childId,
    required DateTime date,
    required List<String> memoryIds,
  });

  /// Ba phiên bản Trung tính / Ấm áp / Ngắn gọn; [AiDraftRecord.safety] =
  /// câu không an toàn (không gửi AI → mở màn hỗ trợ).
  Future<AiDraftRecord> rewrite(String text);

  /// 3–5 việc AI chọn trong catalog nhiệm vụ của bé ([AiDraftRecord.missions]);
  /// [excludeCategories] = nhóm người dùng tắt.
  Future<AiDraftRecord> missionSuggestions({
    String? childId,
    List<String> excludeCategories = const [],
  });

  /// Tóm tắt trung lập các ý đã chia sẻ ([AiDraftRecord.summary]).
  Future<AiDraftRecord> bridgeSummary(String sessionId);

  /// “Báo cáo nội dung AI” (bắt buộc theo Google Play): gửi kèm [text] đã thấy.
  Future<void> report({required String invocationId, required String text});
}
