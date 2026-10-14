part of '../mobile/safety_support_mobile_view.dart';

/// “Liên hệ một người bạn tin cậy” (`uMiRU`): thẻ `surface` viền bo 16, đệm
/// 12/14; `users-round` 20 + 14/700 + 12; `chevron-right` 18.
class _TrustedPersonCard extends StatelessWidget {
  const _TrustedPersonCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
    );
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardInset,
            vertical: AppSpacing.s3,
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.usersRound,
                size: 20,
                color: AppColors.resolve(context, kColorTextSecondary6B625B),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.usSafetyTrustedTitle,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.usSafetyTrustedSub,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
