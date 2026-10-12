part of '../mobile/family_mobile_view.dart';

/// Dòng thêm (Pencil `dyB4P` “Thêm con / thai kỳ”, `mWT0c` “Mời người
/// thân”): ô tròn 44 (nền `surface-variant` + `plus` 20 `text-secondary`, hoặc
/// `primary-50` + `user-plus` `primary-700`), nhãn 14/600 `primary-700`.
class _AddRow extends StatelessWidget {
  const _AddRow({
    required this.label,
    required this.onTap,
    this.icon = LucideIcons.plus,
    this.iconBackground = kColorSurfaceVariantF7F1EC,
    this.iconColor = kColorTextSecondary6B625B,
  });

  final String label;
  final VoidCallback onTap;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
          child: Row(
            children: [
              AppIconBadge(
                icon: icon,
                size: 44,
                radius: AppRadius.full,
                color: iconBackground,
                foreground: iconColor,
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kColorPrimary700A2402F,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
