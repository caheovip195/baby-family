import 'package:baby_family/data/model/ai/ai_result.dart';
import 'package:baby_family/data/repository/ai_remote.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository_imp/base.dart';

class AiRemoteRepositoryImp extends BaseRepositoryImp
    implements IAiRemoteRepository {
  @override
  Future<AiStatusRecord?> status(String familyId) async =>
      (await client!.getAiStatus(familyId)).status;

  @override
  Future<AiStatusRecord?> consent(String familyId, String feature) async =>
      (await client!.grantAiConsent(familyId, {'feature': feature})).status;

  @override
  Future<AiDraftRecord?> draft(
    String familyId,
    String action,
    JsonMap body,
  ) async => (await client!.aiDraft(familyId, action, body)).draft;

  @override
  Future<void> report(String familyId, String invocationId, String text) =>
      client!.createReport({
        'familyId': familyId,
        'targetType': 'AI_OUTPUT',
        'targetId': invocationId,
        'reason': 'AI_CONTENT',
        'note': text.length > 1000 ? text.substring(0, 1000) : text,
      });
}
