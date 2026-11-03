import 'package:baby_family/data/model/growth/growth_entry.dart';
import 'package:baby_family/data/service/base.dart';

/// CHD-06 Tăng trưởng (BF-20261028-004): cân nặng / chiều cao của bé theo
/// ngày, chỉ dữ liệu của bé (không chuẩn tham chiếu, không đánh giá).
abstract class IGrowthService extends IBaseService {
  /// Các lần đo cũ → mới (gồm bản lưu trên máy chờ gửi).
  Future<List<GrowthEntry>> entries(String childId);

  /// Mỗi ngày một lần đo; lưu lại cùng ngày thì đè.
  Future<GrowthEntry> save(
    String childId, {
    required DateTime day,
    int? weightGrams,
    int? heightMm,
    String? note,
  });

  Future<void> remove(String childId, DateTime day);

  /// Có mạng lại: gửi các lần đo chờ.
  Future<void> syncPending();
}
