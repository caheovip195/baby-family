import 'package:baby_family/data/model/ai/ai_result.dart';
import 'package:baby_family/data/service/ai.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Bản mock: bản nháp mẫu (không gọi nhà cung cấp).
class AiServiceImp extends MockServiceImp implements IAiService {
  AiServiceImp(super.sessionRepository, super.clock);

  @override
  Future<AiStatusRecord> status() async =>
      const AiStatusRecord(available: true, used: 0, total: 30);

  @override
  Future<void> grantConsent(AiFeature feature) async {}

  @override
  Future<AiDraftRecord> captions({String? kind, String? hint}) async {
    final base = hint?.trim().isNotEmpty ?? false ? hint!.trim() : 'Hôm nay';
    return AiDraftRecord(
      suggestions: [
        '$base 💛',
        '$base — một ngày thật vui',
        '$base, con lớn rồi',
      ],
    );
  }

  @override
  Future<AiDraftRecord> dayStory({
    required String childId,
    required DateTime date,
    required List<String> memoryIds,
  }) async => const AiDraftRecord(
    story:
        'Hôm nay là một ngày nhiều niềm vui nhỏ. '
        'Con cười thật nhiều và cả nhà ở bên nhau.',
  );

  @override
  Future<AiDraftRecord> rewrite(String text) async => AiDraftRecord(
    neutral: text,
    warm: '$text 💛',
    short: text.length > 60 ? text.substring(0, 60) : text,
  );

  /// Bản mock không có catalog server: màn tự chọn từ mẫu trên máy.
  @override
  Future<AiDraftRecord> missionSuggestions({
    String? childId,
    List<String> excludeCategories = const [],
  }) async => const AiDraftRecord();

  @override
  Future<AiDraftRecord> bridgeSummary(String sessionId) async =>
      const AiDraftRecord(
        summary: 'Hai bạn đều đang mệt và cần được hiểu nhau hơn.',
      );

  @override
  Future<void> report({
    required String invocationId,
    required String text,
  }) async {}
}
