import 'package:baby_family/data/model/growth/growth_entry.dart';
import 'package:baby_family/data/repository/base.dart';

/// CHD-06 Tăng trưởng (`/v1/children/{id}/growth`, BF-20261028-004).
abstract class IGrowthRemoteRepository extends IBaseRepository {
  Future<GrowthListRecord?> list(String childId);

  /// Ghi đè lần đo của ngày [date] (`YYYY-MM-DD`).
  Future<GrowthEntry?> put(String childId, String date, JsonMap body);

  Future<void> delete(String childId, String date);
}
