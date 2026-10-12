part of '../mobile/albums_mobile_view.dart';

/// Nút “+ Album mới” (`Hn2Wu`): cao 32, đệm ngang 12, cách 4, nền
/// `primary-50`, viền `primary-300`, bo tròn; icon `plus` 16 + chữ 13/700
/// `primary-700`.
class _NewAlbumButton extends StatelessWidget {
  const _NewAlbumButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = AppColors.resolve(context, kColorPrimary700A2402F);
    return Semantics(
      button: true,
      child: Material(
        color: AppColors.resolve(context, kColorPrimary50FFF4F1),
        shape: StadiumBorder(
          side: BorderSide(
            color: AppColors.resolve(context, kColorPrimary300F7A796),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 32),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.plus, size: 16, color: foreground),
                  const SizedBox(width: AppSpacing.s1),
                  Text(
                    context.l10n.memAlbumNew,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 16 / 13,
                      color: foreground,
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
