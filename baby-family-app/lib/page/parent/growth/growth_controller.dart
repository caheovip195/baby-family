import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/growth/growth_entry.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/growth.dart';
import 'package:baby_family/data/service/growth.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// Đại lượng đang xem trên biểu đồ.
enum GrowthMetric { weight, height }

/// CHD-06 — Tăng trưởng [1.2] (mục 9.6): cân nặng / chiều cao theo ngày,
/// biểu đồ đường chỉ dữ liệu của bé (không đường chuẩn, không đánh giá),
/// disclaimer cố định. Mỗi ngày một lần đo; lưu lại cùng ngày thì đè.
final growthControllerProvider =
    ChangeNotifierProvider.autoDispose<GrowthController>(GrowthController.new);

class GrowthController extends BaseNotifier {
  GrowthController(super.ref) {
    today = ref.read(todayProvider);
  }

  IGrowthService get growthService => ref.read(growthServiceProvider);

  late DateTime today;
  String? childId;
  Child? child;
  List<GrowthEntry> entries = const [];
  GrowthMetric metric = GrowthMetric.weight;
  bool loaded = false;
  bool hasError = false;

  Future<void> init(String id) async {
    childId = id;
    await load();
  }

  Future<void> load() async {
    final id = childId;
    if (id == null) {
      return;
    }
    hasError = false;
    try {
      final (kid, items) = await (
        ref.read(childServiceProvider).child(id),
        growthService.entries(id),
      ).wait;
      if (isDisposed) {
        return;
      }
      child = kid;
      entries = items;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  void setMetric(GrowthMetric value) {
    metric = value;
    notifyListeners();
  }

  /// Điểm của biểu đồ đang xem: (ngày, giá trị kg hoặc cm).
  List<(DateTime, double)> get points => [
    for (final entry in entries)
      if (valueOf(entry, metric) case final value?) (entry.date, value),
  ];

  /// Lần đo mới nhất (đầu danh sách).
  List<GrowthEntry> get history => entries.reversed.toList();

  DateTime get firstDay => child?.birthDate ?? DateTime(today.year - 20);

  static double? valueOf(GrowthEntry entry, GrowthMetric metric) =>
      switch (metric) {
        GrowthMetric.weight =>
          entry.weightGrams == null ? null : entry.weightGrams! / 1000,
        GrowthMetric.height =>
          entry.heightMm == null ? null : entry.heightMm! / 10,
      };

  /// "5,4" / "5.4" → 5400 gram; trống → null; sai → [FormatException].
  static int? parseScaled(String text, int scale) {
    final trimmed = text.trim().replaceAll(',', '.');
    if (trimmed.isEmpty) {
      return null;
    }
    final value = double.tryParse(trimmed);
    if (value == null || value <= 0) {
      throw const FormatException('growth value');
    }
    return (value * scale).round();
  }

  /// false khi chưa nhập số nào hợp lệ.
  Future<bool> save({
    required DateTime day,
    required String weightKg,
    required String heightCm,
    String? note,
  }) async {
    final id = childId;
    if (id == null) {
      return false;
    }
    final int? weight;
    final int? height;
    try {
      weight = parseScaled(weightKg, 1000);
      height = parseScaled(heightCm, 10);
    } on FormatException {
      return false;
    }
    if (weight == null && height == null) {
      return false;
    }
    await whileLoading(
      () => growthService.save(
        id,
        day: day,
        weightGrams: weight,
        heightMm: height,
        note: note,
      ),
    );
    await load();
    return true;
  }

  Future<void> remove(DateTime day) async {
    final id = childId;
    if (id == null) {
      return;
    }
    await whileLoading(() => growthService.remove(id, day));
    await load();
  }
}
