part of '../mobile/family_mobile_view.dart';

/// Thẻ gói (Pencil `ciEEm` gói Family, `s5W1yN` dùng thử): nền `primary-50`,
/// viền `primary-100`, bo 16, đệm 16, cách 12 — icon (`crown` gói trả phí,
/// `gift` dùng thử), tên gói + giá/hạn, dung lượng, nút “Quản lý gói”
/// (viền) hoặc “Xem gói House / Family” (chính).
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.today,
    required this.onPlans,
    this.price,
  });

  final PlanInfo plan;
  final DateTime today;
  final VoidCallback onPlans;

  /// Giá gói đang dùng (“599.000đ/năm”); null → chỉ ngày gia hạn.
  final String? price;

  String? paidSubtitle(AppLocalizations l10n, String? endsText) {
    if (endsText == null) {
      return price;
    }
    return price == null
        ? l10n.famPlanRenews(endsText)
        : l10n.famPlanPaidSubtitle(price!, endsText);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    final endsAt = plan.endsAt;
    final endsText = endsAt?.toFormDate(locale);
    final (title, subtitle) = switch (plan.state) {
      PlanState.trial => (
        l10n.familyTrial,
        endsAt == null
            ? null
            : l10n.famTrialSubtitle(daysUntil(endsAt, today), endsText!),
      ),
      PlanState.house => (l10n.famPlanHouse, paidSubtitle(l10n, endsText)),
      PlanState.family => (l10n.famPlanFamily, paidSubtitle(l10n, endsText)),
      PlanState.expired => (l10n.setPlanExpired, null),
    };
    String gb(int mb) => storageGbText(mb, locale);
    final quota = plan.storageQuotaMb;
    final isPaid =
        plan.state == PlanState.family || plan.state == PlanState.house;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorPrimary50FFF4F1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorPrimary100FFE3DC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIconBadge(
                icon: isPaid ? LucideIcons.crown : LucideIcons.gift,
                radius: AppRadius.tile,
                color: kColorSurfaceFFFFFF,
                foreground: kColorPrimary600C2513F,
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title16.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (quota > 0) ...[
            const SizedBox(height: AppSpacing.s3),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.familyStorageLabel,
                    style: AppTypography.adapt(context, AppTypography.small),
                  ),
                ),
                Text(
                  l10n.famStorageUsage(gb(plan.storageUsedMb), gb(quota)),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(
                      fontWeight: FontWeight.w700,
                      color: kColorTextPrimary2E2A27,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.compact),
            AppProgressBar(
              value: plan.storageUsedMb / quota,
              color: AppColors.resolve(context, kColorPrimary500EE7B67),
              trackColor: AppColors.resolve(context, kColorSurfaceFFFFFF),
            ),
          ],
          const SizedBox(height: AppSpacing.s3),
          if (isPaid)
            AppButton.secondary(label: l10n.famManagePlan, onPressed: onPlans)
          else
            AppButton(label: l10n.familyViewPlans, onPressed: onPlans),
        ],
      ),
    );
  }
}
