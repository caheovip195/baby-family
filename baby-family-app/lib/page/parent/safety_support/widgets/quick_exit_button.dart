part of '../mobile/safety_support_mobile_view.dart';

/// “Thoát nhanh” (`bu56b`): cao 38, đệm ngang 14, nền `surface` viền `border`
/// bo tròn; `log-out` 15 + 13/700 `text-primary`.
class _QuickExitButton extends StatelessWidget {
  const _QuickExitButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = AppColors.resolve(context, kColorTextPrimary2E2A27);
    final shape = StadiumBorder(
      side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
    );
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 38),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardInset,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.logOut, size: 15, color: foreground),
                const SizedBox(width: AppSpacing.compact),
                Text(
                  context.l10n.usSafetyQuickExit,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
