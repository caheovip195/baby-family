import 'package:baby_family/data/model/ai/ai_result.dart';
import 'package:baby_family/data/model/care/mission_template.dart';
import 'package:baby_family/data/provider/ai.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/service/ai.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CARE-04 “Thư viện nhiệm vụ” (mục 7.13.1, không có trong Pencil): danh sách
/// mẫu định sẵn; chọn một mẫu → trả `templateId` về CARE-03.
final missionLibraryControllerProvider =
    ChangeNotifierProvider.autoDispose<MissionLibraryController>(
      MissionLibraryController.new,
    );

class MissionLibraryController extends BaseNotifier {
  MissionLibraryController(super.ref) {
    ref.listen(appLanguageProvider, (_, _) => load());
    load();
  }

  ICareService get careService => ref.read(careServiceProvider);
  IAiService get aiService => ref.read(aiServiceProvider);

  /// AI 1.2 (BF-20261028-012): 3–5 việc AI chọn trong catalog của bé. Bản
  /// mock (không có server) chọn vài mẫu đầu trên máy.
  Future<AiDraftRecord> suggest() async {
    final draft = await aiService.missionSuggestions();
    if (draft.missions.isNotEmpty || kValueUseRemoteSession) {
      return draft;
    }
    return AiDraftRecord(
      missions: [
        for (final template in (templates ?? const <MissionTemplate>[]).take(3))
          AiMissionPick(
            templateId: template.id,
            title: template.title,
            hearts: template.hearts,
            durationMin: template.durationMin,
          ),
      ],
    );
  }

  Future<void> grantAiConsent(AiFeature feature) =>
      aiService.grantConsent(feature);

  Future<void> reportSuggestion(String invocationId, String text) =>
      aiService.report(invocationId: invocationId, text: text);

  List<MissionTemplate>? templates;
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    final result = await callFuture(careService.templates());
    if (isDisposed) {
      return;
    }
    hasError = result.isFailure;
    result.ifSuccess((data) => templates = data);
    notifyListeners();
  }
}
