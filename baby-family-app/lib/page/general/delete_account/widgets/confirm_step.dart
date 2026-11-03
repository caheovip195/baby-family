part of '../mobile/delete_account_mobile_view.dart';

/// SET-09c bước 3–4 — Xác thực & xác nhận (Pencil `sOUEE`): đăng nhập lại
/// (Apple / OTP), điều xảy ra khi xoá, ô tích xác nhận, “Xoá tài khoản”.
/// Bản thật: Apple / Google đã liên kết (BF-20261030-003) hoặc OTP (gửi mã →
/// nhập 6 số → xác nhận).
class _ConfirmStep extends StatelessWidget {
  const _ConfirmStep({
    required this.controller,
    required this.info,
    required this.onDelete,
    required this.onSendOtp,
    required this.onVerifyOtp,
    required this.onVerifyWith,
  });

  final DeleteAccountController controller;
  final DeleteAccountInfo info;
  final VoidCallback onDelete;
  final VoidCallback onSendOtp;
  final VoidCallback onVerifyOtp;
  final ValueChanged<AuthMethod> onVerifyWith;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const gap = SizedBox(height: AppSpacing.cardInset);
    final apple = info.maskedAppleAccount;
    final google = info.maskedGoogleAccount;
    final account = apple ?? google;
    final phone = info.maskedPhone;
    String? label(String? masked, String provider) =>
        masked == null ? null : (masked.isEmpty ? provider : masked);
    final verifiedAs = switch (controller.verifiedWith) {
      AuthMethod.apple => label(apple, 'Apple'),
      AuthMethod.google => label(google, 'Google'),
      _ => phone,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepHeading(
          step: l10n.setDelStepFinal,
          title: l10n.setDelTitle3,
          subtitle: l10n.setDelSubtitle3,
        ),
        gap,
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (apple != null && !controller.verified)
                AppButton.social(
                  label: l10n.authApple,
                  icon: LucideIcons.apple,
                  inverted: true,
                  height: 48,
                  onPressed: controller.isLoading
                      ? null
                      : () => onVerifyWith(AuthMethod.apple),
                ),
              if (google != null && !controller.verified) ...[
                if (apple != null) const SizedBox(height: AppSpacing.s3),
                AppButton.social(
                  label: l10n.authGoogle,
                  icon: LucideIcons.circleQuestionMark,
                  height: 48,
                  onPressed: controller.isLoading
                      ? null
                      : () => onVerifyWith(AuthMethod.google),
                ),
              ],
              if (controller.verified && verifiedAs != null) ...[
                const SizedBox(height: AppSpacing.s3),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s3,
                    vertical: AppSpacing.itemGap,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorSecondary100E4F2EA),
                    borderRadius: BorderRadius.circular(AppRadius.tile),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.circleCheck,
                        size: 18,
                        color: AppColors.resolve(
                          context,
                          kColorSecondary7003F7A5C,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.itemGap),
                      Expanded(
                        child: Text(
                          l10n.setDelVerified(verifiedAs),
                          style: AppTypography.adapt(
                            context,
                            AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: kColorSecondary7003F7A5C,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (phone != null && !controller.verified) ...[
                if (account != null) const SizedBox(height: AppSpacing.s3),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: controller.isLoading ? null : onSendOtp,
                    child: Text(
                      l10n.setDelUseOtp(phone),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: kColorPrimary600C2513F,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              if (controller.otpSent && phone != null) ...[
                const SizedBox(height: AppSpacing.s3),
                Text(
                  l10n.setDelOtpSent(phone),
                  style: AppTypography.adapt(context, AppTypography.caption),
                ),
                const SizedBox(height: AppSpacing.itemGap),
                AppTextField(
                  label: l10n.authOtpTitle,
                  keyboardType: TextInputType.number,
                  maxLength: DeleteAccountController.otpLength,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autofocus: true,
                  onChanged: controller.setOtpCode,
                ),
                const SizedBox(height: AppSpacing.itemGap),
                AppButton(
                  label: l10n.commonConfirm,
                  height: 44,
                  isLoading: controller.isLoading,
                  onPressed: controller.canVerifyOtp ? onVerifyOtp : null,
                ),
              ],
            ],
          ),
        ),
        gap,
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.s4),
          color: kColorPrimary50FFF4F1,
          borderColor: kColorPrimary100FFE3DC,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.setDelWhatHappens,
                style: AppTypography.adapt(context, AppTypography.title17),
              ),
              const SizedBox(height: AppSpacing.s3),
              _BulletList(
                dotColor: kColorPrimary500EE7B67,
                items: [
                  l10n.setDelHappen1,
                  l10n.setDelHappen2(
                    info.purgeDate.toFormDate(context.localeName),
                  ),
                  l10n.setDelHappen3,
                  l10n.setDelHappen4,
                ],
              ),
            ],
          ),
        ),
        gap,
        InkWell(
          onTap: controller.toggleAcknowledged,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 2,
              vertical: AppSpacing.s1,
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: controller.acknowledged
                        ? AppColors.resolve(context, kColorPrimary600C2513F)
                        : null,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    border: controller.acknowledged
                        ? null
                        : Border.all(
                            color: AppColors.resolve(
                              context,
                              kColorBorderEADFD6,
                            ),
                            width: 2,
                          ),
                  ),
                  child: controller.acknowledged
                      ? Icon(
                          LucideIcons.check,
                          size: 15,
                          color: AppColors.onPrimary(context),
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Text(
                    l10n.setDelConfirmCheck,
                    style: AppTypography.adapt(context, AppTypography.text14),
                  ),
                ),
              ],
            ),
          ),
        ),
        gap,
        _StepFooter(
          primaryLabel: l10n.settingsDeleteAccount,
          primaryColor: kColorErrorD14B4B,
          isLoading: controller.isLoading,
          onPrimary: controller.canDelete ? onDelete : null,
          secondaryLabel: l10n.setDelKeepAccount,
          onSecondary: () => context.router.maybePop(),
        ),
      ],
    );
  }
}
