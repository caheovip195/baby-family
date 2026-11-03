import 'package:baby_family/data/model/year_book/year_book.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/year_book.dart';
import 'package:baby_family/data/service_imp/year_book.dart';
import 'package:baby_family/page/parent/year_book_preview/mobile/year_book_preview_mobile_view.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/misc.dart' show Override;

import '../helpers/design_qa.dart';

/// Bản mock có sẵn một chương để thử chọn/bỏ (bản mock thật không có ảnh).
class _SeededYearBook extends YearBookServiceImp {
  _SeededYearBook(
    super.sessionRepository,
    super.clock, {
    this.canExport = true,
    this.canShare = true,
    this.readOnly = false,
  });

  final bool canExport;
  final bool canShare;
  final bool readOnly;
  final saves = <YearBookRecord>[];

  @override
  final opened = <String?>[];

  @override
  Future<YearBookRecord> book(String? childId, int year) async {
    opened.add(childId);
    return _seed(childId, year);
  }

  YearBookRecord _seed(String? childId, int year) =>
      saves.where((s) => s.childId == childId).lastOrNull ??
      YearBookRecord.fromJson({
        'childId': childId,
        'year': year,
        'childName': childId == null ? 'Nhà Haru' : 'Haru',
        'canExport': canExport,
        'canShare': canShare,
        'readOnly': readOnly,
        'sharedWithCircle': readOnly,
        'chapters': [
          {
            'month': 3,
            'items': [
              {
                'memoryId': 'm1',
                'caption': 'Lẫy lần đầu',
                'occurredAt': '$year-03-02T03:00:00.000Z',
                'included': true,
                'selectedAssetIds': ['a1'],
                'photos': [
                  {'assetId': 'a1'},
                  {'assetId': 'a2'},
                ],
              },
              {
                'memoryId': 'm2',
                'caption': 'Đi chơi',
                'photos': [
                  {'assetId': 'b1'},
                ],
              },
            ],
          },
        ],
      });

  @override
  Future<List<YearBookSummary>> books() async => const [
    YearBookSummary(
      childId: 'haru',
      name: 'Haru',
      year: 2025,
      title: 'Năm đầu của Haru',
      sharedWithCircle: true,
    ),
    YearBookSummary(scope: 'FAMILY', year: 2024, sharedWithCircle: true),
  ];

  @override
  Future<YearBookRecord> save(YearBookRecord book) async {
    saves.add(book.copyWith(saved: true));
    return saves.last;
  }
}

/// BF-20261028-013: REC-04 Sách của con.
void main() {
  setUpAll(loadAppFonts);

  _SeededYearBook? seeded;
  List<Override> overrides({
    bool canExport = true,
    bool canShare = true,
    bool readOnly = false,
  }) => [
    yearBookServiceProvider.overrideWith(
      (ref) => seeded = _SeededYearBook(
        ref.watch(sessionRepositoryProvider),
        ref.watch(appClockProvider),
        canExport: canExport,
        canShare: canShare,
        readOnly: readOnly,
      ),
    ),
    // Plugin raster PDF không chạy trong test: khung giả giữ số byte.
    yearBookPdfViewerProvider.overrideWithValue(
      (bytes) => SizedBox(
        key: ValueKey('pdf-viewer-${bytes.length > 0}'),
        child: const Text('PDF'),
      ),
    ),
  ];

  Future<void> openPreview(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.tap(find.text('Xem trước'));
      for (var i = 0; i < 100; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await tester.pump();
        if (find
            .byKey(const ValueKey('pdf-viewer-true'))
            .evaluate()
            .isNotEmpty) {
          break;
        }
      }
    });
    await tester.pumpAndSettle();
  }

  testWidgets('REC-04: toggle memories and photos, edit caption, save', (
    tester,
  ) async {
    await pumpRoute(
      tester,
      YearBookRoute(childId: 'haru'),
      size: const Size(390, 1200),
      overrides: overrides(),
    );
    expect(find.text('Tháng 3'), findsOneWidget);
    expect(find.textContaining('1 ký ức trong sách'), findsOneWidget);

    // Chọn ảnh của ký ức chưa chọn → ký ức vào sách.
    await tester.tap(find.byKey(const ValueKey('yearbook-photo-b1')));
    await tester.pumpAndSettle();
    expect(find.textContaining('2 ký ức trong sách'), findsOneWidget);
    // Bỏ ký ức đầu.
    await tester.tap(find.byKey(const ValueKey('yearbook-item-m1')));
    await tester.pumpAndSettle();
    expect(find.textContaining('1 ký ức trong sách'), findsOneWidget);

    await tester.tap(find.text('Đi chơi'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Đi biển cùng ông bà');
    await tester.tap(find.text('Lưu').last);
    await tester.pumpAndSettle();
    expect(find.text('Đi biển cùng ông bà'), findsOneWidget);

    await tester.tap(find.text('Lưu').last);
    await tester.pumpAndSettle();
    final saved = seeded!.saves.single;
    expect(saved.saveBody()['chapters'], [
      {
        'month': 3,
        'title': null,
        'items': [
          {
            'memoryId': 'm2',
            'assetIds': ['b1'],
            'caption': 'Đi biển cùng ông bà',
          },
        ],
      },
    ]);
    expect(find.text('Đã lưu thay đổi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('BF-20261030-002: the PDF preview opens in app on every plan; '
      'a preview-only plan cannot export', (tester) async {
    await pumpRoute(
      tester,
      YearBookRoute(childId: 'haru'),
      size: const Size(390, 1200),
      overrides: overrides(canExport: false),
    );
    expect(
      find.text('Gói hiện tại chỉ xem trước sách. Nâng cấp để xuất PDF.'),
      findsOneWidget,
    );
    await openPreview(tester);
    expect(find.byKey(const ValueKey('pdf-viewer-true')), findsOneWidget);
    expect(find.text('Xuất PDF'), findsNothing);
    expect(find.text('Nâng cấp'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('BF-20261030-002: an exportable book exports from the preview', (
    tester,
  ) async {
    await pumpRoute(
      tester,
      YearBookRoute(childId: 'haru'),
      size: const Size(390, 1200),
      overrides: overrides(),
    );
    await openPreview(tester);
    expect(find.text('Xuất PDF'), findsOneWidget);
  });

  testWidgets('BF-20261030-002: Parents share the book with relatives', (
    tester,
  ) async {
    await pumpRoute(
      tester,
      YearBookRoute(childId: 'haru'),
      size: const Size(390, 1200),
      overrides: overrides(),
    );
    await tester.tap(find.text('Chia sẻ với ông bà, người thân'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu').last);
    await tester.pumpAndSettle();
    expect(seeded!.saves.single.saveBody()['sharedWithCircle'], isTrue);
  });

  testWidgets('BF-20261030-002: sharing needs a plan with Family Circle', (
    tester,
  ) async {
    await pumpRoute(
      tester,
      YearBookRoute(childId: 'haru'),
      size: const Size(390, 1200),
      overrides: overrides(canShare: false),
    );
    expect(find.text('Chia sẻ với ông bà, người thân'), findsNothing);
    expect(
      find.text('Gói Family cho phép chia sẻ sách với ông bà, người thân.'),
      findsOneWidget,
    );
  });

  testWidgets('BF-20261030-002: relatives read the shared book only', (
    tester,
  ) async {
    await pumpRoute(
      tester,
      YearBookRoute(childId: 'haru', year: 2025),
      size: const Size(390, 1200),
      overrides: overrides(readOnly: true),
    );
    expect(find.text('Lưu'), findsNothing);
    expect(find.text('Cả nhà'), findsNothing);
    expect(find.text('Chia sẻ với ông bà, người thân'), findsNothing);
    expect(find.byKey(const ValueKey('yearbook-item-m1')), findsNothing);
    expect(find.text('Xem trước'), findsOneWidget);
    expect(seeded!.opened.single, 'haru');
  });

  testWidgets('BF-20261030-002: CIR-06 lists the shared year books', (
    tester,
  ) async {
    final router = await pumpRoute(
      tester,
      const CircleYearBooksRoute(),
      overrides: overrides(readOnly: true),
    );
    expect(find.text('Năm đầu của Haru'), findsOneWidget);
    expect(find.text('Sách cả nhà'), findsWidgets);
    await tester.tap(find.text('Năm đầu của Haru'));
    await tester.pumpAndSettle();
    expect(router.topRoute.name, YearBookRoute.name);
  });

  testWidgets('BF-20261030-001: switch to the whole-family book', (
    tester,
  ) async {
    await pumpRoute(
      tester,
      YearBookRoute(childId: 'haru'),
      size: const Size(390, 1200),
      overrides: overrides(),
    );
    expect(find.text('Sách của con'), findsWidgets);
    await tester.tap(find.text('Cả nhà'));
    await tester.pumpAndSettle();
    expect(seeded!.opened.last, isNull);
    expect(find.text('Sách cả nhà'), findsOneWidget);
    expect(find.text('Nhà Haru'), findsOneWidget);
    expect(find.textContaining('của nhà mình'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('REC-04: empty year in mock mode', (tester) async {
    await pumpRoute(tester, YearBookRoute(childId: 'haru'));
    expect(find.text('Năm này chưa có ký ức nào của bé.'), findsOneWidget);
  });

  testWidgets('CHD-01 opens REC-04 for a born child', (tester) async {
    final router = await pumpRoute(
      tester,
      ChildProfileRoute(childId: 'haru'),
      size: const Size(390, 1400),
    );
    await tester.scrollUntilVisible(find.text('Sách của con'), 200);
    await tester.tap(find.text('Sách của con'));
    await tester.pumpAndSettle();
    expect(router.topRoute.name, YearBookRoute.name);
  });

  testWidgets('REC-04 narrow + large text', (tester) async {
    await pumpRoute(
      tester,
      YearBookRoute(childId: 'haru'),
      size: kNarrowSize,
      textScale: 1.3,
      overrides: overrides(),
    );
    expect(tester.takeException(), isNull);
  });
}
