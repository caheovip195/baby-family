import 'package:baby_family/data/model/ai/ai_result.dart';
import 'package:baby_family/data/repository/ai_remote.dart';
import 'package:baby_family/data/service/ai.dart';
import 'package:baby_family/data/service_imp/ai.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

/// AI qua server (OpenRouter phía backend, BF-20261028-010). Server kiểm gói,
/// cài đặt, đồng ý và hạn mức; 428 → [AiConsentRequired].
class AiRemoteServiceImp extends AiServiceImp {
  AiRemoteServiceImp(super.sessionRepository, super.clock, this._remote);

  final IAiRemoteRepository _remote;

  static final _day = DateFormat('yyyy-MM-dd');

  String? get _familyId =>
      sessionRepository.session()[kValueSessionKeyServerFamilyId] as String?;

  static String _code(AiFeature feature) => switch (feature) {
    AiFeature.caption => 'caption',
    AiFeature.dailyStory => 'dailyStory',
    AiFeature.gentleRewrite => 'gentleRewrite',
    AiFeature.bridgeSummary => 'bridgeSummary',
    AiFeature.missionSuggest => 'missionSuggest',
  };

  Future<AiDraftRecord> _draft(
    AiFeature feature,
    String action,
    Map<String, dynamic> body,
  ) async {
    final familyId = _familyId!;
    try {
      final draft = await _remote.draft(familyId, action, body);
      if (draft == null) {
        throw StateError('Empty AI answer');
      }
      return draft;
    } on DioException catch (error) {
      if (error.response?.statusCode == 428) {
        throw AiConsentRequired(feature);
      }
      rethrow;
    }
  }

  @override
  Future<AiStatusRecord> status() async {
    final familyId = _familyId;
    if (familyId == null) {
      return super.status();
    }
    return await _remote.status(familyId) ?? const AiStatusRecord();
  }

  @override
  Future<void> grantConsent(AiFeature feature) async {
    final familyId = _familyId;
    if (familyId == null) {
      return super.grantConsent(feature);
    }
    await _remote.consent(familyId, _code(feature));
  }

  @override
  Future<AiDraftRecord> captions({String? kind, String? hint}) async {
    if (_familyId == null) {
      return super.captions(kind: kind, hint: hint);
    }
    return _draft(AiFeature.caption, 'captions', {
      'kind': ?kind,
      if (hint != null && hint.trim().isNotEmpty) 'hint': hint.trim(),
    });
  }

  @override
  Future<AiDraftRecord> dayStory({
    required String childId,
    required DateTime date,
    required List<String> memoryIds,
  }) async {
    if (_familyId == null) {
      return super.dayStory(childId: childId, date: date, memoryIds: memoryIds);
    }
    return _draft(AiFeature.dailyStory, 'day-story', {
      'childId': childId,
      'date': _day.format(date),
      'memoryIds': memoryIds,
    });
  }

  @override
  Future<AiDraftRecord> rewrite(String text) async {
    if (_familyId == null) {
      return super.rewrite(text);
    }
    return _draft(AiFeature.gentleRewrite, 'rewrite', {'text': text});
  }

  @override
  Future<AiDraftRecord> missionSuggestions({
    String? childId,
    List<String> excludeCategories = const [],
  }) async {
    if (_familyId == null) {
      return super.missionSuggestions(
        childId: childId,
        excludeCategories: excludeCategories,
      );
    }
    return _draft(AiFeature.missionSuggest, 'mission-suggestions', {
      'childId': ?childId,
      if (excludeCategories.isNotEmpty) 'excludeCategories': excludeCategories,
    });
  }

  @override
  Future<AiDraftRecord> bridgeSummary(String sessionId) async {
    if (_familyId == null) {
      return super.bridgeSummary(sessionId);
    }
    return _draft(AiFeature.bridgeSummary, 'bridge-summary', {
      'sessionId': sessionId,
    });
  }

  @override
  Future<void> report({
    required String invocationId,
    required String text,
  }) async {
    final familyId = _familyId;
    if (familyId == null) {
      return super.report(invocationId: invocationId, text: text);
    }
    await _remote.report(familyId, invocationId, text);
  }
}
