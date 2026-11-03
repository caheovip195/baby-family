import 'dart:typed_data';

import 'package:baby_family/data/model/year_book/year_book.dart';
import 'package:baby_family/data/service/base.dart';

/// REC-04 Sách của con (BF-20261028-013): mỗi tháng một chương, ký ức và ảnh
/// tự chọn sẵn; Parent chọn/bỏ, sửa chú thích, đặt tên rồi lưu; PDF dựng
/// trên máy.
abstract class IYearBookService extends IBaseService {
  /// Sách của bé năm [year] (gồm bản chỉnh sửa trên máy chờ gửi); [childId]
  /// null = sách cả nhà (BF-20261030-001).
  Future<YearBookRecord> book(String? childId, int year);

  /// Lưu cả bản; mất mạng → giữ trên máy ([YearBookRecord.pending]) và tự
  /// gửi khi có mạng.
  Future<YearBookRecord> save(YearBookRecord book);

  /// Sách đã lưu (người thân: bản Parent đã chia sẻ, BF-20261030-002).
  Future<List<YearBookSummary>> books();

  /// Ảnh để in vào PDF; null khi không tải được.
  Future<Uint8List?> photo(YearBookPhoto photo);

  /// Có mạng lại: gửi bản chỉnh sửa chờ.
  Future<void> syncPending();
}
