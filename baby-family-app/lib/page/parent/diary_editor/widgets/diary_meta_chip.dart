part of '../mobile/diary_editor_mobile_view.dart';

/// Chip meta MEM-13 (`MCPFk`): cao 32, nền `surface-variant`, bo tròn, đệm
/// ngang 10 (có avatar: trái 4), cách 6; icon 15 `text-secondary` hoặc
/// avatar 24; chữ 13/600; `chevron-down` 14 `text-tertiary`.
class _DiaryMetaChip extends StatelessWidget {
  const _DiaryMetaChip({
    required this.label,
    required this.onTap,
    this.icon,
    this.leading,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 32),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              leading != null ? AppSpacing.s1 : AppSpacing.itemGap,
              AppSpacing.s1,
              AppSpacing.itemGap,
              AppSpacing.s1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ?leading,
                if (icon != null)
                  Icon(
                    icon,
                    size: 15,
                    color: AppColors.resolve(
                      context,
                      kColorTextSecondary6B625B,
                    ),
                  ),
                const SizedBox(width: AppSpacing.compact),
                Text(
                  label,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 16 / 13,
                      color: kColorTextPrimary2E2A27,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.compact),
                Icon(
                  LucideIcons.chevronDown,
                  size: 14,
                  color: AppColors.resolve(context, kColorTextTertiary9C928A),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
