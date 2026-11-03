import 'package:baby_family/data/model/ai/ai_result.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/ai_remote.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/service/ai.dart';
import 'package:baby_family/data/service_imp/ai_remote.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

/// Server AI giả: lần đầu mỗi tính năng trả 428 (cần đồng ý).
class _FakeAi implements IAiRemoteRepository {
  final consented = <String>{};
  final calls = <String>[];

  final reports = <String>[];

  @override
  Future<void> report(
    String familyId,
    String invocationId,
    String text,
  ) async => reports.add('$invocationId:$text');

  @override
  Future<AiStatusRecord?> status(String familyId) async => AiStatusRecord(
    available: true,
    used: 1,
    total: 30,
    consented: [...consented],
  );

  @override
  Future<AiStatusRecord?> consent(String familyId, String feature) async {
    consented.add(feature);
    return status(familyId);
  }

  @override
  Future<AiDraftRecord?> draft(
    String familyId,
    String action,
    JsonMap body,
  ) async {
    calls.add('$action:$body');
    final feature = switch (action) {
      'captions' => 'caption',
      'day-story' => 'dailyStory',
      'rewrite' => 'gentleRewrite',
      'mission-suggestions' => 'missionSuggest',
      _ => 'bridgeSummary',
    };
    if (!consented.contains(feature)) {
      final options = RequestOptions(path: '/ai/$action');
      throw DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 428),
      );
    }
    return switch (action) {
      'captions' => const AiDraftRecord(
        invocationId: 'inv-1',
        suggestions: ['A', 'B', 'C'],
      ),
      'day-story' => const AiDraftRecord(story: 'Một ngày vui.'),
      'rewrite' => const AiDraftRecord(neutral: 'n', warm: 'w', short: 's'),
      'mission-suggestions' => AiDraftRecord.fromJson(const {
        'invocationId': 'inv-m',
        'missions': [
          {
            'templateId': 't-1',
            'title': 'Đọc sách',
            'hearts': 3,
            'reason': 'Ít làm',
          },
          {'title': 'Dòng hỏng thiếu templateId'},
        ],
      }),
      _ => const AiDraftRecord(summary: 'Hai bạn cần nhau.'),
    };
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late _FakeAi remote;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    remote = _FakeAi();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({kValueSessionKeyServerFamilyId: 'srv-family'});
  });

  AiRemoteServiceImp service() => AiRemoteServiceImp(
    container.read(sessionRepositoryProvider),
    container.read(appClockProvider),
    remote,
  );

  test('BF-20261028-010: first use asks for consent, then AI drafts come '
      'back', () async {
    final ai = service();
    await expectLater(
      ai.captions(kind: 'photo', hint: '  bé cười '),
      throwsA(
        isA<AiConsentRequired>().having(
          (error) => error.feature,
          'feature',
          AiFeature.caption,
        ),
      ),
    );
    await ai.grantConsent(AiFeature.caption);
    final captions = await ai.captions(kind: 'photo', hint: '  bé cười ');
    expect(captions.suggestions, ['A', 'B', 'C']);
    await ai.report(invocationId: captions.invocationId!, text: 'A');
    expect(remote.reports, ['inv-1:A']);
    expect(remote.calls.last, contains('hint: bé cười'));

    await ai.grantConsent(AiFeature.dailyStory);
    expect(
      (await ai.dayStory(
        childId: 'kid',
        date: DateTime(2026, 10, 28),
        memoryIds: const ['m1'],
      )).story,
      'Một ngày vui.',
    );
    expect(remote.calls.last, contains('date: 2026-10-28'));

    await ai.grantConsent(AiFeature.gentleRewrite);
    final rewrite = await ai.rewrite('Anh chẳng giúp em');
    expect((rewrite.neutral, rewrite.warm, rewrite.short), ('n', 'w', 's'));

    await ai.grantConsent(AiFeature.bridgeSummary);
    expect((await ai.bridgeSummary('s1')).summary, 'Hai bạn cần nhau.');
    await ai.grantConsent(AiFeature.missionSuggest);
    final missions = await ai.missionSuggestions(
      childId: 'kid',
      excludeCategories: const ['PLAY'],
    );
    expect(missions.missions.single.templateId, 't-1');
    expect(remote.calls.last, contains('excludeCategories: [PLAY]'));
    final status = await ai.status();
    expect((status.used, status.total), (1, 30));
  });
}
