import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;

/// Dòng trong thẻ cài đặt/thông tin (Pencil CAL-02 “Date Card”, CARE-12
/// “Categories”/“Timing”, US-15, CHD-01 “Info”): đệm 12/16, icon 20 bên trái,
/// tiêu đề 14/600 + dòng phụ 12 `text-secondary`, [trailing] bên phải (công
/// tắc, giá trị, `chevron-right` — cao tối đa 26), kẻ `border` 1 ở đáy khi [divider].
///
/// [label] (tuỳ chọn) là nhãn nhỏ 12 `text-tertiary` phía trên tiêu đề (CHD-01:
/// “Ngày sinh” → “Thứ Ba, 08/04/2025”); khi có [label] icon căn trên.
class AppSettingRow extends StatelessWidget {
  const AppSettingRow({
    required this.title,
    this.subtitle,
    this.label,
    this.icon,
    this.iconSize = 20,
    this.iconColor = kColorTextSecondary6B625B,
    this.titleColor = kColorTextPrimary2E2A27,
    this.trailing,
    this.titleBadge,
    this.onTap,
    this.divider = false,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.s4,
      vertical: AppSpacing.s3,
    ),
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? label;
  final IconData? icon;
  final double iconSize;
  final Color iconColor;
  final Color titleColor;
  final Widget? trailing;

  /// Nhãn nhỏ cạnh tiêu đề (CAL-02 “Gói Family”).
  final Widget? titleBadge;
  final VoidCallback? onTap;
  final bool divider;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final topAligned = label != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: divider
            ? Border(
                bottom: BorderSide(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
              )
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: topAligned
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: iconSize,
                  color: AppColors.resolve(context, iconColor),
                ),
                const SizedBox(width: AppSpacing.s3),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (label != null) ...[
                      Text(
                        label!,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small.copyWith(
                            color: kColorTextTertiary9C928A,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Wrap(
                      spacing: AppSpacing.compact,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          title,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.text14.copyWith(
                              fontWeight: FontWeight.w600,
                              height: topAligned ? 1.4 : 18 / 14,
                              color: titleColor,
                            ),
                          ),
                        ),
                        ?titleBadge,
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small.copyWith(height: 16 / 12),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.s3),
                // Dòng chạm được cả dòng: giữ chiều cao công tắc 26 như Pencil.
                SizedBox(
                  height: 26,
                  child: OverflowBox(
                    maxHeight: AppSpacing.minTouchTarget,
                    fit: OverflowBoxFit.deferToChild,
                    child: trailing,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
