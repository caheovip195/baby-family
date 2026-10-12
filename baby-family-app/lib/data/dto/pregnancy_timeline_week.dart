import 'package:baby_family/data/model/memory/memory.dart';

/// Một nhóm tuần trong Dòng thời gian thai kỳ (PREG-01): nhãn “Tuần 24”,
/// mô tả phụ (“tuần này” / “Lần đầu” / “2 ký ức”) và các thẻ hiển thị.
class PregnancyTimelineWeek {
  const PregnancyTimelineWeek({
    required this.week,
    this.isCurrent = false,
    this.memoryCount = 0,
    this.hasFirst = false,
    this.items = const [],
    this.bumpSlot = false,
    this.ghostWeek,
  });

  final int week;
  final bool isCurrent;

  /// Mọi ký ức của tuần (kể cả ảnh bụng — hiển thị ở tab Bụng bầu).
  final int memoryCount;

  /// Tuần có cột mốc “Lần đầu”.
  final bool hasFirst;

  /// Ký ức hiển thị trên dòng thời gian (không gồm ảnh bụng).
  final List<Memory> items;

  /// Tuần hiện tại chưa có ảnh bụng → ô “Chụp ảnh bụng tuần …”.
  final bool bumpSlot;

  /// Tuần của ảnh bụng gần nhất (bóng mờ khi chụp).
  final int? ghostWeek;
}
