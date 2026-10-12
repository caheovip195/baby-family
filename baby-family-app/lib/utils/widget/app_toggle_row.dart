import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:flutter/material.dart';

/// Dòng bật/tắt (Pencil FAM-03 “Quyền”, SET-06 “Khác”): [icon] 20
/// `text-secondary` (tuỳ chọn), tiêu đề 14–15 + mô tả 12 `text-secondary`,
/// công tắc [AppSwitch] bên phải; chạm cả dòng để đổi.
class AppToggleRow extends StatelessWidget {
  const AppToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    this.padding = EdgeInsets.zero,
    this.titleStyle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final EdgeInsetsGeometry padding;

  /// Mặc định 15/500 (SET-06); FAM-03 dùng 14/600.
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.resolve(context, kColorTextSecondary6B625B),
                ),
                const SizedBox(width: AppSpacing.s3),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.adapt(
                        context,
                        titleStyle ??
                            AppTypography.body.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              // Cả dòng là vùng chạm: thu chiều cao công tắc về 26 như Pencil.
              SizedBox(
                width: 44,
                height: 26,
                child: OverflowBox(
                  maxHeight: AppSpacing.minTouchTarget,
                  child: AppSwitch(value: value, onChanged: onChanged),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
