part of '../mobile/on_this_day_mobile_view.dart';

/// “Chia sẻ lại với chú thích mới” (`X929Gd`): cao 44, nền `surface`, viền, bo
/// 12; `repeat-2` 17 `primary-600` + chữ 14/700 `primary-700`, cách 8.
class _ReshareButton extends StatelessWidget {
  const _ReshareButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.tile),
      side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
    );
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.repeat2,
                  size: 17,
                  color: AppColors.resolve(context, kColorPrimary600C2513F),
                ),
                const SizedBox(width: AppSpacing.s2),
                Flexible(
                  child: Text(
                    context.l10n.memOnThisDayReshare,
                    style: AppTypography.text14.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.resolve(context, kColorPrimary700A2402F),
                    ),
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
