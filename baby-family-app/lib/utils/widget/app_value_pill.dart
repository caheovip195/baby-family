import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Viên giá trị đã chọn (Pencil US-08 “Kiệt sức” `ZQhqc`, US-10 `W3fU6z`,
/// US-11 `VOdr9`): cao 26, đệm ngang 10, bo tròn, chữ 12/600.
/// Mặc định tông Papa & Mama (`us-100` / `us-700`); US-11 dùng `primary-50`
/// (của tôi) và `secondary-100` (của bạn đời) với chữ `text-primary`.
class AppValuePill extends StatelessWidget {
  const AppValuePill({
    required this.label,
    this.color = kColorUs100EAE2F8,
    this.foreground = kColorUs7006A549F,
    super.key,
  });

  final String label;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.itemGap,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, color),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.small.copyWith(
          height: 16 / 12,
          fontWeight: FontWeight.w600,
          color: AppColors.resolve(context, foreground),
        ),
      ),
    );
  }
}
