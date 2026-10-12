part of '../mobile/onboarding_activated_mobile_view.dart';

/// Thẻ dùng thử: nền `surface`, viền `primary-300`, bo 20, đệm 18, cách 6;
/// tiêu đề quà 17/800 `primary-700`, hạn 13 `text-secondary`, sau dùng thử 13
/// `text-tertiary` (line-height 1.5).
class _TrialCard extends StatelessWidget {
  const _TrialCard({this.until, this.after});

  final String? until;
  final String? after;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      border: Border.all(
        color: AppColors.resolve(context, kColorPrimary300F7A796),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              LucideIcons.gift,
              size: 20,
              color: AppColors.resolve(context, kColorPrimary600C2513F),
            ),
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: Text(
                context.l10n.onboardingTrial,
                style: AppTypography.adapt(
                  context,
                  AppTypography.title17.copyWith(color: kColorPrimary700A2402F),
                ),
              ),
            ),
          ],
        ),
        if (until != null) ...[
          const SizedBox(height: AppSpacing.compact),
          Text(
            until!,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(height: 16 / 13),
            ),
          ),
        ],
        if (after != null) ...[
          const SizedBox(height: AppSpacing.compact),
          Text(
            after!,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                height: 1.5,
                color: kColorTextTertiary9C928A,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
