import 'package:baby_family/data/model/child/child_record.dart';
import 'package:baby_family/data/model/pregnancy/birth_result_record.dart';
import 'package:baby_family/data/model/pregnancy/journey_record.dart';
import 'package:baby_family/data/model/pregnancy/pregnancy_name_record.dart';
import 'package:baby_family/data/model/pregnancy/prep_group_record.dart';
import 'package:baby_family/data/model/pregnancy/prep_item_record.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/pregnancy.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/pregnancy_remote.dart';
import 'package:baby_family/data/service_imp/pregnancy_remote.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

/// Thai kỳ trên server giả (BF-20261019-001).
class _FakePregnancy implements IPregnancyRemoteRepository {
  final items = <PrepItemRecord>[
    const PrepItemRecord(
      id: 'p-1',
      pregnancyId: 'srv-preg',
      groupCode: 'HOSPITAL_BAG',
      title: 'Bỉm sơ sinh',
    ),
    const PrepItemRecord(
      id: 'p-2',
      pregnancyId: 'srv-preg',
      groupCode: 'PAPERS',
      title: 'Giấy chứng sinh',
      done: true,
    ),
  ];
  final patches = <String, JsonMap>{};
  final birthKeys = <String>[];
  final archived = <String>[];
  bool failBirth = false;

  @override
  Future<JourneyRecord?> journey(String pregnancyId, {int? week}) async => null;

  @override
  Future<List<PrepGroupRecord>> prepItems(String pregnancyId) async => [
    PrepGroupRecord(groupCode: 'ALL', items: items),
  ];

  @override
  Future<PrepItemRecord?> createPrep(
    String pregnancyId, {
    required String groupCode,
    required String title,
  }) async {
    final item = PrepItemRecord(
      id: 'p-${items.length + 1}',
      pregnancyId: pregnancyId,
      groupCode: groupCode,
      title: title,
    );
    items.add(item);
    return item;
  }

  @override
  Future<PrepItemRecord?> updatePrep(String itemId, JsonMap patch) async {
    patches[itemId] = patch;
    return null;
  }

  @override
  Future<BirthResultRecord?> convert(
    String pregnancyId,
    String idempotencyKey,
    JsonMap body,
  ) async {
    birthKeys.add(idempotencyKey);
    if (failBirth) {
      failBirth = false;
      throw StateError('network');
    }
    return BirthResultRecord(
      pregnancyId: pregnancyId,
      children: const [ChildRecord(id: 'srv-baby')],
    );
  }

  @override
  Future<void> archive(String pregnancyId, String reason) async =>
      archived.add('$pregnancyId:$reason');

  // PREG-07 (BF-20261027-001): server giữ danh sách tên + giới hạn chọn.
  final nameRows = <PregnancyNameRecord>[];
  final nameCalls = <String>[];
  int chosenLimit = 2;

  @override
  Future<PregnancyNameList?> names(String pregnancyId) async =>
      PregnancyNameList(items: nameRows, chosenLimit: chosenLimit);

  @override
  Future<PregnancyNameRecord?> addName(String pregnancyId, JsonMap body) async {
    nameCalls.add('add:${body['name']}:${body['meaning'] ?? '-'}');
    final record = PregnancyNameRecord(
      id: 'n-${nameRows.length + 1}',
      name: body['name'] as String,
      meaning: body['meaning'] as String?,
      addedByUserId: 'srv-me',
      likedByMe: true,
    );
    nameRows.add(record);
    return record;
  }

  PregnancyNameRecord _update(
    String nameId,
    PregnancyNameRecord Function(PregnancyNameRecord) change,
  ) {
    final index = nameRows.indexWhere((n) => n.id == nameId);
    return nameRows[index] = change(nameRows[index]);
  }

  @override
  Future<PregnancyNameRecord?> likeName(
    String nameId, {
    required bool like,
  }) async {
    nameCalls.add('${like ? 'like' : 'unlike'}:$nameId');
    return _update(nameId, (n) => n.copyWith(likedByMe: like));
  }

  @override
  Future<PregnancyNameRecord?> chooseName(
    String nameId, {
    required bool choose,
  }) async {
    nameCalls.add('${choose ? 'choose' : 'unchoose'}:$nameId');
    return _update(nameId, (n) => n.copyWith(chosen: choose));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakePregnancy remote;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    remote = _FakePregnancy();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({kValueSessionKeyServerFamilyId: 'srv-family'});
    container.read(childRepositoryProvider).addChild({
      'id': 'srv-preg',
      'familyId': session.session()['familyId'],
      'name': 'Bơ',
      'kind': ChildKind.pregnancy.name,
      'dueDate': DateTime(2027, 1, 10).toIso8601String(),
      'colorIndex': 3,
    });
  });

  PregnancyRemoteServiceImp service() => PregnancyRemoteServiceImp(
    container.read(sessionRepositoryProvider),
    container.read(appClockProvider),
    container.read(pregnancyRepositoryProvider),
    container.read(childRepositoryProvider),
    container.read(familyRepositoryProvider),
    container.read(memoryRepositoryProvider),
    container.read(usRepositoryProvider),
    remote,
  );

  test('PREG-07: names of a server pregnancy go through the API', () async {
    container.read(childRepositoryProvider).updateChild('srv-preg', {
      kValueChildKeyServerSubject: true,
    });
    remote.nameRows.add(
      const PregnancyNameRecord(
        id: 'n-0',
        name: 'An',
        addedByUserId: 'srv-partner',
        likedByPartner: true,
      ),
    );
    final pregnancy = service();
    var names = await pregnancy.names('srv-preg');
    expect(names.single.name, 'An');
    expect(names.single.likedByPartner, isTrue);
    expect(names.single.bothLike, isFalse);

    await pregnancy.addName('srv-preg', name: ' Bơ ', meaning: ' Ngọt ');
    await pregnancy.toggleNameLike('n-0');
    names = await pregnancy.names('srv-preg');
    expect(names.map((n) => n.name), ['An', 'Bơ']);
    expect(names.first.bothLike, isTrue);

    // Chọn rồi bấm lại = bỏ chọn (song thai: server giới hạn số tên).
    await pregnancy.chooseName('n-0');
    await pregnancy.chooseName('n-0');
    await pregnancy.toggleNameLike('n-0');
    expect(remote.nameCalls, [
      'add:Bơ:Ngọt',
      'like:n-0',
      'choose:n-0',
      'unchoose:n-0',
      'unlike:n-0',
    ]);
  });

  test(
    'BF-20261023-001: stale pregnancy id cannot reveal fixture names',
    () async {
      final session = container.read(sessionRepositoryProvider);
      session.patchSession({'familyId': 'server-family-mirror'});
      final pregnancy = service();
      expect(await pregnancy.names('bo'), isEmpty);
      final children = container.read(childRepositoryProvider);
      children.addChild({
        'id': 'own-pregnancy',
        'familyId': 'server-family-mirror',
        'name': 'Our baby',
        'kind': ChildKind.pregnancy.name,
      });
      await pregnancy.addName('own-pregnancy', name: 'An');
      expect((await pregnancy.names('own-pregnancy')).single.name, 'An');
    },
  );

  test(
    'BF-20261023-001: birth draft excludes sample date, measurements and photo',
    () async {
      final draft = await service().birthDraft('bo');
      expect(draft.birthDate, isNull);
      expect(draft.birthTime, isNull);
      expect(draft.gender, ChildGender.unknown);
      expect(draft.weightKg, isNull);
      expect(draft.heightCm, isNull);
      expect(draft.samplePhotoAsset, isNull);
    },
  );

  test(
    'PREG-04: the checklist comes from the server and edits go back',
    () async {
      final pregnancy = service();
      final summary = await pregnancy.prep('srv-preg');
      expect((summary.done, summary.total), (1, 2));
      expect(summary.items.first.group, PrepGroup.bag);
      expect(summary.items.last.group, PrepGroup.papers);

      await pregnancy.togglePrep('p-1');
      expect(remote.patches['p-1'], {'done': true});
      await pregnancy.addPrep(
        'srv-preg',
        title: 'Khăn sữa',
        group: PrepGroup.nursery,
      );
      expect(remote.items.last.groupCode, 'NURSERY');
      final after = await pregnancy.prep('srv-preg');
      expect(after.total, 3);
      // No extra demo counts are added on top of the server list.
      expect(after.items.where((item) => item.done).length, after.done);
    },
  );

  test(
    'PREG-05: birth keeps its Idempotency-Key on retry and adds the baby',
    () async {
      final pregnancy = service();
      remote.failBirth = true;
      await expectLater(
        pregnancy.convertToBaby(
          'srv-preg',
          name: 'An',
          birthDate: DateTime(2026, 10, 1),
          weightKg: 3.2,
        ),
        throwsStateError,
      );
      final baby = await pregnancy.convertToBaby(
        'srv-preg',
        name: 'An',
        birthDate: DateTime(2026, 10, 1),
        weightKg: 3.2,
      );
      expect(remote.birthKeys, hasLength(2));
      expect(remote.birthKeys.first, remote.birthKeys.last);
      expect(baby.id, 'srv-baby');
      expect(baby.kind, ChildKind.baby);
      final children = await container.read(childServiceProvider).children();
      expect(children.map((child) => child.id), isNot(contains('srv-preg')));
    },
  );

  test(
    'PREG-06: parents-only archive is ENDED_PRIVATE on the server',
    () async {
      final pregnancy = service();
      await pregnancy.archive('srv-preg');
      await pregnancy.archive('srv-preg', parentsOnly: false);
      expect(remote.archived, ['srv-preg:ENDED_PRIVATE', 'srv-preg:ARCHIVED']);
    },
  );
}
