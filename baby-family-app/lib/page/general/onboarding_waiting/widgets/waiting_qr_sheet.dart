part of '../mobile/onboarding_waiting_mobile_view.dart';

/// Sheet “Hiện mã QR”: QR 148 + mã mời để bạn đời quét khi ngồi cạnh; bản mock
/// có nút “Mô phỏng bạn đời tham gia”.
class _WaitingQrSheet extends StatelessWidget {
  const _WaitingQrSheet({required this.code, required this.onSimulate});

  final String code;
  final VoidCallback onSimulate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppBottomSheet(
      title: l10n.onboardingShowQr,
      children: [
        Center(
          child: Container(
            width: 148,
            height: 148,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(
              LucideIcons.qrCode,
              size: 112,
              color: AppColors.resolve(context, kColorTextPrimary2E2A27),
            ),
          ),
        ),
        Text(
          code,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.h1.copyWith(fontSize: 24, letterSpacing: 2),
          ),
        ),
        AppButton.secondary(
          label: l10n.onboardingActivateDemo,
          onPressed: onSimulate,
        ),
      ],
    );
  }
}
