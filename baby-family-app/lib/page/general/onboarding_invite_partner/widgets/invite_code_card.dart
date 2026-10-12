part of '../mobile/onboarding_invite_partner_mobile_view.dart';

/// Thẻ mã mời: nền `surface`, viền `border`, bo 20, đệm 20, cách 14; QR 148
/// nền `surface-variant` bo 16 (icon `qr-code` 112).
class _InviteCodeCard extends StatelessWidget {
  const _InviteCodeCard({required this.code, required this.onCopy});

  final String code;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s5),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 148,
            height: 148,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(
              LucideIcons.qrCode,
              size: 112,
              semanticLabel: l10n.onboardingShowQr,
              color: AppColors.resolve(context, kColorTextPrimary2E2A27),
            ),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          Text(
            l10n.onboardingInviteCode,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(height: 16 / 13),
            ),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  code,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.h1.copyWith(
                      fontSize: 24,
                      height: 33 / 24,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s2),
              InkResponse(
                onTap: onCopy,
                radius: AppSpacing.s6,
                child: Icon(
                  LucideIcons.copy,
                  size: 20,
                  semanticLabel: l10n.commonCopied,
                  color: AppColors.resolve(context, kColorPrimary600C2513F),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.cardInset),
          Text(
            l10n.onboardingInviteExpiry,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(context, AppTypography.small).copyWith(
              color: AppColors.resolve(context, kColorTextTertiary9C928A),
            ),
          ),
        ],
      ),
    );
  }
}
