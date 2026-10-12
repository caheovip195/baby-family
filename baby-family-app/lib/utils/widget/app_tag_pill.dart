import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Nhãn dạng viên (Pencil FAM-01 “Mẹ/Bố”, FAM-04 “Hoạt động…”, SET-07
/// “Thiết bị này”, SET-11 “1 đang xử lý”): đệm [4,10], bo tròn, chữ 11/700.
/// [dot]: chấm 7 cùng màu [dotColor] trước chữ (cách 6).
class AppTagPill extends StatelessWidget {
  const AppTagPill({
    required this.label,
    this.color = kColorSecondary100E4F2EA,
    this.foreground = kColorSecondary7003F7A5C,
    this.dotColor,
    super.key,
  });

  final String label;
  final Color color;
  final Color foreground;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.itemGap,
        vertical: AppSpacing.s1,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, color),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: AppColors.resolve(context, dotColor!),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.compact),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.adapt(
                context,
                AppTypography.tiny.copyWith(
                  fontWeight: FontWeight.w700,
                  color: foreground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
