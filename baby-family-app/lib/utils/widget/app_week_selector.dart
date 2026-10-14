import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Bộ chọn tuần dạng viên (Pencil US-14 `gG56i`, CARE-11 `ZtlKI`): cao 44,
/// đệm ngang 6, nền `surface` bo tròn ([outlined] thêm viền `border`); hai nút
/// 32 (`chevron-left/right` 18) hai bên, nhãn giữa 14/700.
class AppWeekSelector extends StatelessWidget {
  const AppWeekSelector({
    required this.label,
    this.onPrevious,
    this.onNext,
    this.previousColor = kColorTextSecondary6B625B,
    this.nextColor = kColorTextSecondary6B625B,
    this.outlined = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final Color previousColor;
  final Color nextColor;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget arrow(IconData icon, Color color, VoidCallback? onTap, String tip) =>
        SizedBox.square(
          dimension: AppSpacing.s8,
          child: IconButton(
            padding: EdgeInsets.zero,
            tooltip: tip,
            onPressed: onTap,
            icon: Icon(
              icon,
              size: 18,
              color: AppColors.resolve(context, color),
            ),
          ),
        );
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.compact),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: outlined
            ? Border.all(color: AppColors.resolve(context, kColorBorderEADFD6))
            : null,
      ),
      child: Row(
        children: [
          arrow(
            LucideIcons.chevronLeft,
            previousColor,
            onPrevious,
            l10n.commonPrevWeek,
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          arrow(
            LucideIcons.chevronRight,
            nextColor,
            onNext,
            l10n.commonNextWeek,
          ),
        ],
      ),
    );
  }
}
