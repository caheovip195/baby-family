part of '../mobile/mission_create_mobile_view.dart';

/// Thanh trên CARE-03 (Pencil `AwkSD`): cao 56, đệm ngang 20, `x` 24 bên
/// trái, tiêu đề 18/700 ở giữa.
class _CreateTopBar extends StatelessWidget implements PreferredSizeWidget {
  const _CreateTopBar({required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.topBarHeight);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.resolve(context, kColorBgFFFBF7),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppSpacing.topBarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: AppSpacing.iconButton,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: context.l10n.commonClose,
                    onPressed: () => context.router.maybePop(),
                    icon: Icon(
                      LucideIcons.x,
                      size: 24,
                      color: AppColors.resolve(
                        context,
                        kColorTextPrimary2E2A27,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(context, AppTypography.h3),
                  ),
                ),
                const SizedBox.square(dimension: AppSpacing.iconButton),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
