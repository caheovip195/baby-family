import 'dart:typed_data';

import 'package:baby_family/data/model/year_book/year_book.dart';
import 'package:baby_family/data/repository/base.dart';

/// REC-04 Sách của con (`/v1/children/{id}/year-book/{year}`, BF-20261028-013)
/// và sách cả nhà (`/v1/families/{id}/year-book/{year}`, BF-20261030-001).
abstract class IYearBookRemoteRepository extends IBaseRepository {
  /// [childId] null = sách cả nhà của [familyId].
  Future<YearBookRecord?> get(String familyId, String? childId, int year);

  Future<YearBookRecord?> put(
    String familyId,
    String? childId,
    int year,
    JsonMap body,
  );

  /// Sách đã lưu của gia đình (người thân: bản đã chia sẻ).
  Future<List<YearBookSummary>> list(String familyId);

  /// Tải ảnh qua URL xem có hạn (không gửi token của app).
  Future<Uint8List> download(String url);
}
