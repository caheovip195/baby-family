import 'dart:typed_data';

import 'package:baby_family/data/model/year_book/year_book.dart';
import 'package:baby_family/data/service/year_book.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';

/// Bản mock: sách chưa có ký ức (bản mock không có ảnh server), lưu trong
/// bộ nhớ của phiên app.
class YearBookServiceImp extends MockServiceImp implements IYearBookService {
  YearBookServiceImp(super.sessionRepository, super.clock);

  final _books = <String, YearBookRecord>{};

  @override
  Future<YearBookRecord> book(String? childId, int year) async =>
      _books['${childId ?? 'family'}|$year'] ??
      YearBookRecord(childId: childId, year: year, canExport: true);

  @override
  Future<YearBookRecord> save(YearBookRecord book) async =>
      _books['${book.childId ?? 'family'}|${book.year}'] = book.copyWith(
        saved: true,
      );

  @override
  Future<List<YearBookSummary>> books() async => [
    for (final book in _books.values)
      YearBookSummary(
        scope: book.isFamily ? 'FAMILY' : 'CHILD',
        childId: book.childId,
        name: book.childName,
        year: book.year,
        title: book.title,
        sharedWithCircle: book.sharedWithCircle,
      ),
  ];

  @override
  Future<Uint8List?> photo(YearBookPhoto photo) async => null;

  @override
  Future<void> syncPending() async {}
}
