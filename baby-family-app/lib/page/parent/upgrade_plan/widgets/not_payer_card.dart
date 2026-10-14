part of '../mobile/upgrade_plan_mobile_view.dart';

/// Khối “Papa sẽ thấy (không phải người thanh toán)” (Pencil “Not Payer
/// Variant”): nền `us-50`, bo 16, đệm 14, cách 10; nhãn 11/700 `us-700`
/// viết hoa, mô tả 13, viên “Gửi lời nhắn cho Mama” viền `us-100`.
class _NotPayerCard extends StatelessWidget {
  const _NotPayerCard({required this.partner, required this.payer});

  final String partner;
  final String payer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final us = AppColors.resolve(context, kColorUs7006A549F);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorUs50F6F2FC),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.eye, size: 14, color: us),
              const SizedBox(width: AppSpacing.compact),
              Expanded(
                child: Text(
                  l10n.subUpgradeNotPayerLabel(partner).toUpperCase(),
                  style: AppTypography.tiny.copyWith(
                    fontWeight: FontWeight.w700,
                    color: us,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Text(
            l10n.subUpgradeNotPayerBody(payer),
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                height: 1.45,
                color: kColorTextPrimary2E2A27,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          AppPillButton(
            label: l10n.subUpgradeAskPayer(payer),
            icon: LucideIcons.send,
            iconSize: 14,
            height: 32,
            horizontalPadding: AppSpacing.s3,
            outlined: true,
            borderColor: kColorUs100EAE2F8,
            onPressed: () =>
                showAppSnackBar(context, l10n.subUpgradeAskSent(payer)),
          ),
        ],
      ),
    );
  }
}
