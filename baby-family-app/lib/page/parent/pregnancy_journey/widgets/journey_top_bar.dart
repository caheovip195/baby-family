part of '../mobile/pregnancy_journey_mobile_view.dart';

/// Thanh trên (Pencil `v2o0r`): cao 52, đệm ngang 16, cách 8 — back 22
/// `text-primary`, tiêu đề 20/800 Nunito, ⋯ 20 `text-secondary` ngay sau.
class _JourneyTopBar extends StatelessWidget {
  const _JourneyTopBar({required this.title, this.onMenu});

  final String title;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        child: Row(
          children: [
            Semantics(
              button: true,
              label: context.l10n.commonBack,
              child: InkResponse(
                onTap: () => context.router.maybePop(),
                radius: 22,
                child: Icon(
                  LucideIcons.chevronLeft,
                  size: 22,
                  color: AppColors.resolve(context, kColorTextPrimary2E2A27),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s2),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.adapt(context, AppTypography.title20),
              ),
            ),
            const SizedBox(width: AppSpacing.s2),
            if (onMenu != null)
              Semantics(
                button: true,
                label: context.l10n.pregMenuEdit,
                child: InkResponse(
                  onTap: onMenu,
                  radius: 22,
                  child: Icon(
                    LucideIcons.ellipsis,
                    size: 20,
                    color: AppColors.resolve(
                      context,
                      kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
