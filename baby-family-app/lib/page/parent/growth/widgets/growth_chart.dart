part of '../mobile/growth_mobile_view.dart';

/// Biểu đồ đường chỉ số đo của bé: trục dọc min–max của chính dữ liệu (không
/// đường chuẩn), nhãn ngày đầu / cuối; dưới 2 điểm thì hiện gợi ý.
class _GrowthChart extends StatelessWidget {
  const _GrowthChart({required this.points, required this.unit});

  final List<(DateTime, double)> points;
  final String Function(String value) unit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = l10n.localeName;
    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);
    final label = AppTypography.adapt(
      context,
      AppTypography.tiny.copyWith(color: tertiary),
    );
    if (points.length < 2) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Text(
            l10n.growthChartHint,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(color: tertiary),
            ),
          ),
        ),
      );
    }
    final values = [for (final point in points) point.$2];
    final low = values.reduce(math.min);
    final high = values.reduce(math.max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(unit(_GrowthChart.number(high, locale)), style: label),
        const SizedBox(height: AppSpacing.s1),
        SizedBox(
          height: 160,
          child: CustomPaint(
            painter: _GrowthChartPainter(
              points: points,
              line: AppColors.resolve(context, kColorPrimary500EE7B67),
              grid: AppColors.resolve(context, kColorBorderEADFD6),
              dot: AppColors.resolve(context, kColorSurfaceFFFFFF),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s1),
        Text(unit(_GrowthChart.number(low, locale)), style: label),
        const SizedBox(height: AppSpacing.s2),
        Row(
          children: [
            Text(points.first.$1.toFormDate(locale), style: label),
            const Spacer(),
            Text(points.last.$1.toFormDate(locale), style: label),
          ],
        ),
      ],
    );
  }

  /// 1 chữ số thập phân, dấu phẩy với tiếng Việt.
  static String number(double value, String locale) =>
      NumberFormat('0.#', locale).format(value);
}

class _GrowthChartPainter extends CustomPainter {
  _GrowthChartPainter({
    required this.points,
    required this.line,
    required this.grid,
    required this.dot,
  });

  final List<(DateTime, double)> points;
  final Color line;
  final Color grid;
  final Color dot;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 6.0;
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (final y in [inset, size.height / 2, size.height - inset]) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    final start = points.first.$1;
    final span = math.max(points.last.$1.difference(start).inDays, 1);
    final values = [for (final point in points) point.$2];
    final low = values.reduce(math.min);
    final range = math.max(values.reduce(math.max) - low, 0.0001);
    Offset at((DateTime, double) point) => Offset(
      inset +
          (size.width - 2 * inset) * point.$1.difference(start).inDays / span,
      size.height -
          inset -
          (size.height - 2 * inset) * (point.$2 - low) / range,
    );
    final path = Path()..moveTo(at(points.first).dx, at(points.first).dy);
    for (final point in points.skip(1)) {
      path.lineTo(at(point).dx, at(point).dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );
    for (final point in points) {
      canvas
        ..drawCircle(at(point), 4.5, Paint()..color = line)
        ..drawCircle(at(point), 2.5, Paint()..color = dot);
    }
  }

  @override
  bool shouldRepaint(_GrowthChartPainter old) =>
      old.points != points || old.line != line;
}
