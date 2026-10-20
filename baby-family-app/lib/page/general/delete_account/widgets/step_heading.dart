part of '../mobile/delete_account_mobile_view.dart';

/// Đầu bước (Pencil `ydtpA`…): “BƯỚC 1/4” 12/700 `primary-600`, tiêu đề
/// 26/800, mô tả 14 (dòng 1.45) — cách nhau 14.
class _StepHeading extends StatelessWidget {
  const _StepHeading({
    required this.step,
    required this.title,
    required this.subtitle,
  });

  final String step;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          step.toUpperCase(),
          style: AppTypography.adapt(
            context,
            AppTypography.small.copyWith(
              fontWeight: FontWeight.w700,
              color: kColorPrimary600C2513F,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.cardInset),
        Text(title, style: AppTypography.adapt(context, AppTypography.h1)),
        const SizedBox(height: AppSpacing.cardInset),
        Text(
          subtitle,
          style: AppTypography.adapt(
            context,
            AppTypography.text14.copyWith(
              height: 1.45,
              color: kColorTextSecondary6B625B,
            ),
          ),
        ),
      ],
    );
  }
}

/// Chân bước (Pencil “Footer”): nút chính 52 + nút chữ 15/600
/// `text-secondary` cao 44 (cách 6, đệm trên 6).
class _StepFooter extends StatelessWidget {
  const _StepFooter({
    required this.primaryLabel,
    required this.onPrimary,
    required this.secondaryLabel,
    required this.onSecondary,
    this.isLoading = false,
    this.primaryColor = kColorPrimary600C2513F,
  });

  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String secondaryLabel;
  final VoidCallback onSecondary;
  final bool isLoading;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        children: [
          AppButton(
            label: primaryLabel,
            color: primaryColor,
            isLoading: isLoading,
            onPressed: onPrimary,
          ),
          const SizedBox(height: 6),
          AppButton.text(
            label: secondaryLabel,
            color: kColorTextSecondary6B625B,
            expand: false,
            height: 44,
            onPressed: onSecondary,
          ),
        ],
      ),
    );
  }
}
