/// Kích thước thai tham khảo theo tuần (HOME-03 “Tuần này Bơ to cỡ bắp ngô ·
/// khoảng 30 cm”). Catalog server đã dịch theo ngôn ngữ (`fruit`).
class FetalSize {
  const FetalSize({
    required this.week,
    required this.emoji,
    required this.fruit,
    required this.lengthCm,
  });

  /// Tuần catalog gần nhất ≤ tuần thai hiện tại.
  final int week;
  final String emoji;
  final String fruit;
  final int lengthCm;
}
