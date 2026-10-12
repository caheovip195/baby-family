import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Chip chọn theo Pencil Chip `HPjaU` / ChipSelected `trgwq`: cao 36, đệm
/// ngang 16, bo tròn.
/// - Thường: nền `surface-variant`, chữ 14/500 `text-secondary`.
/// - Đã chọn: nền `primary-100`, viền `primary-500`, icon `check` 16 + chữ
///   14/600 `primary-700`.
/// [icon] (tuỳ chọn) hiển thị trước nhãn khi chưa chọn.
class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.showCheck = true,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  /// Ẩn dấu check khi chọn (chip dạng tab).
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    final foreground = AppColors.resolve(
      context,
      selected ? kColorPrimary700A2402F : kColorTextSecondary6B625B,
    );
    final leading = selected && showCheck ? LucideIcons.check : icon;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorPrimary100FFE3DC : kColorSurfaceVariantF7F1EC,
        ),
        shape: StadiumBorder(
          side: selected
              ? BorderSide(
                  color: AppColors.resolve(context, kColorPrimary500EE7B67),
                )
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSpacing.chipHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[
                    Icon(leading, size: 16, color: foreground),
                    const SizedBox(width: AppSpacing.compact),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.text14.copyWith(
                        color: foreground,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
