import 'package:baby_family/data/model/growth/growth_entry.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/growth_remote.dart';
import 'package:baby_family/data/service_imp/growth.dart';
import 'package:baby_family/data/service_imp/growth_remote.dart';
import 'package:baby_family/page/parent/growth/growth_controller.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';
import '../helpers/fake_local_db.dart';
import '../helpers/fake_outbox.dart';

/// Server giả của CHD-06: mỗi bé + ngày một lần đo.
class _FakeGrowth implements IGrowthRemoteRepository {
  bool offline = false;
  int? rejectWith;
  final rows = <String, Map<String, JsonMap>>{};
  final calls = <String>[];

  void _check(String path) {
    if (offline) {
      throw DioException(requestOptions: RequestOptions(path: path));
    }
    final status = rejectWith;
    if (status != null) {
      rejectWith = null;
      final options = RequestOptions(path: path);
      throw DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: status),
      );
    }
  }

  @override
  Future<GrowthListRecord?> list(String childId) async {
    _check('/growth');
    return GrowthListRecord.fromJson({
      'childId': childId,
      'birthDate': '2026-01-01',
      'items': [
        ...?(rows[childId]?.values),
        // Dòng hỏng từ server (đổi kiểu field): bỏ, không hỏng cả danh sách.
        {'measuredOn': 42},
      ],
    });
  }

  @override
  Future<GrowthEntry?> put(String childId, String date, JsonMap body) async {
    _check('/growth/$date');
    calls.add('put:$date:${body['weightGrams']}:${body['heightMm']}');
    final row = {...body, 'measuredOn': date};
    (rows[childId] ??= {})[date] = row;
    return GrowthEntry.fromJson(row);
  }

  @override
  Future<void> delete(String childId, String date) async {
    _check('/growth/$date');
    calls.add('delete:$date');
    rows[childId]?.remove(date);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakeGrowth remote;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    remote = _FakeGrowth();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({kValueSessionKeyServerFamilyId: 'srv-family'});
  });

  GrowthRemoteServiceImp service({FakeOutbox? outbox, FakeLocalDb? db}) =>
      GrowthRemoteServiceImp(
          container.read(sessionRepositoryProvider),
          container.read(appClockProvider),
          remote,
        )
        ..outbox = outbox
        ..localDb = db;

  test('BF-20261028-004: CHD-06 measurements go to the server by day and '
      'skip unreadable rows', () async {
    final growth = service();
    await growth.save('c1', day: DateTime(2026, 3, 1), weightGrams: 4200);
    await growth.save(
      'c1',
      day: DateTime(2026, 2, 1),
      weightGrams: 3500,
      heightMm: 520,
      note: '  Khám  ',
    );
    // Lưu lại cùng ngày: đè.
    await growth.save('c1', day: DateTime(2026, 3, 1), weightGrams: 4300);
    final items = await growth.entries('c1');
    expect(items.map((e) => e.measuredOn), ['2026-02-01', '2026-03-01']);
    expect(items.first.note, 'Khám');
    expect(items.last.weightGrams, 4300);
    expect(items.any((e) => e.pending), isFalse);
    await growth.remove('c1', DateTime(2026, 2, 1));
    expect((await growth.entries('c1')).single.measuredOn, '2026-03-01');
    await expectLater(
      growth.save('c1', day: DateTime(2026, 3, 2)),
      throwsArgumentError,
    );
  });

  test('BF-20261028-004: offline measurements show at once, survive a '
      'restart and are sent once when back online', () async {
    final outbox = FakeOutbox();
    final db = FakeLocalDb();
    final first = service(outbox: outbox, db: db);
    await first.save('c1', day: DateTime(2026, 2, 1), weightGrams: 3500);
    expect((await first.entries('c1')).single.weightGrams, 3500);

    remote.offline = true;
    final saved = await first.save(
      'c1',
      day: DateTime(2026, 3, 1),
      heightMm: 560,
    );
    expect(saved.pending, isTrue);
    await first.save('c1', day: DateTime(2026, 3, 1), heightMm: 565);
    await first.remove('c1', DateTime(2026, 2, 1));
    expect(outbox.entries, hasLength(2));

    // Mở lại app khi vẫn mất mạng: bản lưu trên máy + thao tác chờ.
    final second = service(outbox: outbox, db: db);
    final offline = await second.entries('c1');
    expect(offline.single.measuredOn, '2026-03-01');
    expect(offline.single.heightMm, 565);
    expect(offline.single.pending, isTrue);

    remote.offline = false;
    await second.syncPending();
    await second.entries('c1');
    expect(outbox.entries, isEmpty);
    expect(remote.calls, [
      'put:2026-02-01:3500:null',
      'put:2026-03-01:null:565',
      'delete:2026-02-01',
    ]);
    final online = await second.entries('c1');
    expect(online.single.pending, isFalse);
  });

  test(
    'BF-20261028-004: a refused measurement surfaces the server error',
    () async {
      final growth = service(outbox: FakeOutbox());
      remote.rejectWith = 400;
      await expectLater(
        growth.save('c1', day: DateTime(2026, 3, 1), weightGrams: 3000),
        throwsA(isA<DioException>()),
      );
      expect(await growth.entries('c1'), isEmpty);
    },
  );

  test('CHD-06 input parsing accepts comma decimals', () {
    expect(GrowthController.parseScaled('5,4', 1000), 5400);
    expect(GrowthController.parseScaled(' 60.5 ', 10), 605);
    expect(GrowthController.parseScaled('', 10), isNull);
    expect(
      () => GrowthController.parseScaled('abc', 10),
      throwsFormatException,
    );
    expect(GrowthServiceImp.sorted(const []), isEmpty);
  });
}
