import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_icon_badge.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Dòng trong nhóm cài đặt [AppGroupedList] (Pencil SET-01 `FpmYG`, FAM-04,
/// FAM-07, SET-02/03/07/11/12): đệm ngang 16, cách 12, cao tối thiểu 56;
/// ô [icon] 32 bo 10 (icon 18) tuỳ chọn; tiêu đề 15/500, [subtitle] 12
/// (dòng cao 1.4); [value] 13 `text-secondary` ([valueStrong]: 600
/// `text-primary`); [trailing] (nhãn, nút nhỏ) và chevron 18 `text-tertiary`.
///
/// [AppSettingsRow.toggle]: công tắc [AppSwitch] bên phải, chạm cả dòng để đổi.
class AppSettingsRow extends StatelessWidget {
  const AppSettingsRow({
    required this.title,
    this.onTap,
    this.icon,
    this.subtitle,
    this.value,
    this.valueStrong = false,
    this.trailing,
    this.showChevron = true,
    this.iconTile = 32,
    this.iconColor = kColorTextSecondary6B625B,
    this.iconBackground = kColorSurfaceVariantF7F1EC,
    this.iconLabel,
    this.titleColor = kColorTextPrimary2E2A27,
    this.titleWeight = FontWeight.w500,
    this.titleSize = 15,
    this.subtitleColor = kColorTextSecondary6B625B,
    this.minHeight = 56,
    this.verticalPadding = AppSpacing.s3,
    super.key,
  }) : switchValue = null,
       onSwitch = null;

  const AppSettingsRow.toggle({
    required this.title,
    required bool value,
    required ValueChanged<bool> onChanged,
    this.icon,
    this.subtitle,
    this.iconTile = 32,
    this.iconColor = kColorTextSecondary6B625B,
    this.iconBackground = kColorSurfaceVariantF7F1EC,
    this.titleColor = kColorTextPrimary2E2A27,
    this.titleWeight = FontWeight.w500,
    this.titleSize = 15,
    this.subtitleColor = kColorTextSecondary6B625B,
    this.minHeight = 56,
    this.verticalPadding = AppSpacing.s3,
    super.key,
  }) : switchValue = value,
       onSwitch = onChanged,
       onTap = null,
       value = null,
       valueStrong = false,
       trailing = null,
       showChevron = false,
       iconLabel = null;

  final String title;
  final VoidCallback? onTap;
  final IconData? icon;

  /// Chữ thay cho icon trong ô (SET-02 “G” của Google).
  final String? iconLabel;
  final String? subtitle;
  final String? value;
  final bool valueStrong;
  final Widget? trailing;
  final bool showChevron;

  /// Cạnh ô icon: 32 (mặc định, icon 18, bo 10), 30 (SET-03, icon 16) hoặc
  /// 40 (SET-08, icon 20, bo 12).
  final double iconTile;
  final Color iconColor;
  final Color iconBackground;
  final Color titleColor;
  final FontWeight titleWeight;
  final double titleSize;
  final Color subtitleColor;
  final double minHeight;
  final double verticalPadding;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitch;

  static const _valueMaxWidth = 150.0;

  @override
  Widget build(BuildContext context) {
    final isToggle = switchValue != null;
    final hasIcon = icon != null || iconLabel != null;
    final iconSize = iconTile >= 40
        ? 20.0
        : iconTile >= 32
        ? 18.0
        : 16.0;
    final iconRadius = iconTile >= 40 ? AppRadius.tile : AppRadius.sm;
    final row = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: verticalPadding,
        ),
        child: Row(
          children: [
            if (icon != null)
              AppIconBadge(
                icon: icon!,
                size: iconTile,
                iconSize: iconSize,
                radius: iconRadius,
                color: iconBackground,
                foreground: iconColor,
              )
            else if (iconLabel != null)
              Container(
                width: iconTile,
                height: iconTile,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, iconBackground),
                  borderRadius: BorderRadius.circular(iconRadius),
                ),
                child: Text(
                  iconLabel!,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.title17.copyWith(color: iconColor),
                  ),
                ),
              ),
            if (hasIcon) const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.body.copyWith(
                        fontSize: titleSize,
                        height: 19 / 15,
                        fontWeight: titleWeight,
                        color: titleColor,
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          height: 1.4,
                          color: subtitleColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: AppSpacing.s3),
              // Giá trị bám phải (cạnh chevron); giới hạn bề rộng để tiêu đề
              // dài / cỡ chữ lớn không tràn.
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _valueMaxWidth),
                child: Text(
                  value!,
                  textAlign: TextAlign.end,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(
                      height: 16 / 13,
                      fontWeight: valueStrong ? FontWeight.w600 : null,
                      color: valueStrong
                          ? kColorTextPrimary2E2A27
                          : kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ),
            ],
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.s3),
              trailing!,
            ],
            if (isToggle) ...[
              const SizedBox(width: AppSpacing.s3),
              // Cả dòng là vùng chạm: thu chiều cao công tắc về 26 như Pencil.
              SizedBox(
                width: 44,
                height: 26,
                child: OverflowBox(
                  maxHeight: AppSpacing.minTouchTarget,
                  child: AppSwitch(value: switchValue!, onChanged: onSwitch),
                ),
              ),
            ],
            if (showChevron && !isToggle) ...[
              const SizedBox(width: AppSpacing.s3),
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
            ],
          ],
        ),
      ),
    );
    final tap = isToggle ? () => onSwitch!(!switchValue!) : onTap;
    if (tap == null) {
      return row;
    }
    return MergeSemantics(
      child: InkWell(onTap: tap, child: row),
    );
  }
}
