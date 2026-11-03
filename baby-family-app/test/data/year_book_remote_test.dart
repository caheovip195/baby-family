import 'dart:typed_data';

import 'package:baby_family/data/model/year_book/year_book.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/year_book_remote.dart';
import 'package:baby_family/data/service_imp/year_book_remote.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';
import '../helpers/fake_local_db.dart';
import '../helpers/fake_outbox.dart';

JsonMap _item(String id, {bool included = false, List<String>? selected}) => {
  'memoryId': id,
  'kind': 'MOMENT',
  'occurredAt': '2025-03-02T03:00:00.000Z',
  'caption': 'Ký ức $id',
  'included': included,
  'selectedAssetIds': selected ?? <String>[],
  'photos': [
    {'assetId': '$id-a', 'url': 'https://media.test/$id-a'},
    {'assetId': '$id-b', 'url': null},
  ],
};

/// Server giả của REC-04: một bản mỗi bé + năm, lưu đè cả bản.
class _FakeYearBook implements IYearBookRemoteRepository {
  bool offline = false;
  int? rejectWith;
  JsonMap? stored;
  final puts = <JsonMap>[];
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

  YearBookRecord _book(String? childId, int year) {
    final base = YearBookRecord.fromJson({
      'childId': childId,
      'year': year,
      'childName': childId == null ? 'Nhà Haru' : 'Haru',
      'canExport': true,
      'chapters': [
        {
          'month': 3,
          'items': [
            _item('m1', included: true, selected: ['m1-a']),
            _item('m2'),
            // Dòng hỏng từ server: bỏ, không hỏng cả chương.
            {'memoryId': 7},
          ],
        },
        {'month': 'x'},
      ],
    });
    final body = stored;
    return body == null ? base : base.withDraft(body);
  }

  @override
  Future<YearBookRecord?> get(
    String familyId,
    String? childId,
    int year,
  ) async {
    calls.add('get:$familyId:${childId ?? '-'}:$year');
    _check('/year-book');
    return _book(childId, year);
  }

  @override
  Future<YearBookRecord?> put(
    String familyId,
    String? childId,
    int year,
    JsonMap body,
  ) async {
    calls.add('put:$familyId:${childId ?? '-'}:$year');
    _check('/year-book');
    puts.add(body);
    stored = body;
    return _book(childId, year);
  }

  @override
  Future<List<YearBookSummary>> list(String familyId) async {
    calls.add('list:$familyId');
    _check('/year-books');
    return const [YearBookSummary(year: 2025, sharedWithCircle: true)];
  }

  @override
  Future<Uint8List> download(String url) async {
    _check(url);
    return Uint8List.fromList([1, 2, 3]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakeYearBook remote;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    remote = _FakeYearBook();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({kValueSessionKeyServerFamilyId: 'srv-family'});
  });

  YearBookRemoteServiceImp service({FakeOutbox? outbox, FakeLocalDb? db}) =>
      YearBookRemoteServiceImp(
          container.read(sessionRepositoryProvider),
          container.read(appClockProvider),
          remote,
        )
        ..outbox = outbox
        ..localDb = db;

  test('BF-20261028-013: REC-04 reads chapters leniently and saves only the '
      'chosen memories', () async {
    final books = service();
    final book = await books.book('c1', 2025);
    expect(book.chapters.single.items.map((i) => i.memoryId), ['m1', 'm2']);
    expect(book.includedCount, 1);

    final edited = book.copyWith(
      title: 'Năm đầu',
      chapters: [
        book.chapters.single.copyWith(
          items: [
            book.chapters.single.items.first.copyWith(included: false),
            book.chapters.single.items.last.copyWith(
              included: true,
              caption: 'Đi biển',
              selectedAssetIds: ['m2-b', 'm2-a'],
            ),
          ],
        ),
      ],
    );
    final saved = await books.save(edited);
    expect(remote.puts.single, {
      'title': 'Năm đầu',
      'sharedWithCircle': false,
      'chapters': [
        {
          'month': 3,
          'title': null,
          'items': [
            {
              'memoryId': 'm2',
              'assetIds': ['m2-b', 'm2-a'],
              'caption': 'Đi biển',
            },
          ],
        },
      ],
    });
    expect(saved.pending, isFalse);
    expect(saved.title, 'Năm đầu');
    expect(saved.chapters.single.items.first.included, isFalse);
    expect(saved.chapters.single.items.last.selectedAssetIds, ['m2-b', 'm2-a']);
    expect(
      await books.photo(saved.chapters.single.items.first.photos.last),
      isNull,
    );
    expect(await books.photo(saved.chapters.single.items.first.photos.first), [
      1,
      2,
      3,
    ]);
  });

  test('BF-20261028-013: offline edits stay on the device, survive a '
      'restart and are sent once when back online', () async {
    final outbox = FakeOutbox();
    final db = FakeLocalDb();
    final first = service(outbox: outbox, db: db);
    final book = await first.book('c1', 2025);

    remote.offline = true;
    final draft = await first.save(book.copyWith(title: 'Bản 1'));
    expect(draft.pending, isTrue);
    await first.save(book.copyWith(title: 'Bản 2'));
    expect(outbox.entries, hasLength(1));

    // Mở lại app khi vẫn mất mạng: bản đọc trên máy + bản chỉnh sửa chờ.
    final second = service(outbox: outbox, db: db);
    final offline = await second.book('c1', 2025);
    expect(offline.title, 'Bản 2');
    expect(offline.pending, isTrue);
    expect(offline.chapters.single.items.first.included, isTrue);

    remote.offline = false;
    await second.syncPending();
    final online = await second.book('c1', 2025);
    expect(outbox.entries, isEmpty);
    expect(remote.puts.map((body) => body['title']), ['Bản 2']);
    expect(online.pending, isFalse);
    expect(online.title, 'Bản 2');
  });

  test('BF-20261028-013: a refused save surfaces the server error; no cache '
      'while offline rethrows', () async {
    final books = service(outbox: FakeOutbox());
    final book = await books.book('c1', 2025);
    remote.rejectWith = 400;
    await expectLater(books.save(book), throwsA(isA<DioException>()));
    expect((await books.book('c1', 2025)).pending, isFalse);

    remote.offline = true;
    await expectLater(
      service(db: FakeLocalDb()).book('c1', 2026),
      throwsA(isA<DioException>()),
    );
  });

  test('BF-20261030-001: the family book uses the family route and is kept '
      'apart from the child book, offline too', () async {
    final outbox = FakeOutbox();
    final books = service(outbox: outbox, db: FakeLocalDb());
    final family = await books.book(null, 2025);
    expect(family.isFamily, isTrue);
    expect(family.childName, 'Nhà Haru');
    expect(remote.calls.last, 'get:srv-family:-:2025');

    remote.offline = true;
    final draft = await books.save(family.copyWith(title: 'Nhà mình'));
    expect(draft.pending, isTrue);
    expect((await books.book(null, 2025)).title, 'Nhà mình');
    // Sách của bé không nhận bản chờ của sách cả nhà.
    remote.offline = false;
    remote.stored = null;
    expect(outbox.entries.single.args['childId'], isNull);
    await books.syncPending();
    await Future<void>.delayed(Duration.zero);
    expect(remote.calls, contains('put:srv-family:-:2025'));
    expect(outbox.entries, isEmpty);
    expect((await books.book('c1', 2025)).isFamily, isFalse);
    expect(remote.calls.last, 'get:srv-family:c1:2025');
  });

  test('BF-20261030-002: the share flag is saved and offline keeps the last '
      'shared list', () async {
    final books = service(outbox: FakeOutbox());
    final book = await books.book('c1', 2025);
    await books.save(book.copyWith(sharedWithCircle: true));
    expect(remote.puts.last['sharedWithCircle'], isTrue);
    expect((await books.book('c1', 2025)).sharedWithCircle, isTrue);

    expect((await books.books()).single.year, 2025);
    remote.offline = true;
    expect((await books.books()).single.sharedWithCircle, isTrue);
  });
}
