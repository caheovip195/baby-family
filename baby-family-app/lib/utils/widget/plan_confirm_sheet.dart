import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/plan_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_icon_text_row.dart';
import 'package:baby_family/utils/widget/app_key_value_row.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// SUB-02 — xác nhận trước khi mở bảng thanh toán của Store (Pencil
/// `m3WJcB`). Mở từ SUB-01 (nút mua) và SUB-04 (nâng cấp). Trả về `true` khi
/// bấm “Tiếp tục với App Store”.
///
/// [showTrialNote]: thêm ý “Thời gian dùng thử còn lại không cộng dồn…” khi
/// gia đình đang dùng thử.
Future<bool> showPlanConfirmSheet(
  BuildContext context, {
  required PlanOffer offer,
  required String familyName,
  required String papaCallName,
  required String mamaCallName,
  bool showTrialNote = false,
}) async {
  final confirmed = await showAppBottomSheet<bool>(
    context,
    strongScrim: true,
    builder: (_) => PlanConfirmSheet(
      offer: offer,
      familyName: familyName,
      papaCallName: papaCallName,
      mamaCallName: mamaCallName,
      showTrialNote: showTrialNote,
    ),
  );
  return confirmed ?? false;
}

/// Nội dung sheet SUB-02: đầu (icon `crown` 48 nền `primary-50` + “Xác nhận
/// gói …”), bảng tóm tắt nền `surface-variant` bo 16 đệm 14, các ý có dấu
/// check `success`, nút chính, chú thích 11 `text-tertiary` và 3 link 12/600.
class PlanConfirmSheet extends StatelessWidget {
  const PlanConfirmSheet({
    required this.offer,
    required this.familyName,
    required this.papaCallName,
    required this.mamaCallName,
    this.showTrialNote = false,
    super.key,
  });

  final PlanOffer offer;
  final String familyName;
  final String papaCallName;
  final String mamaCallName;
  final bool showTrialNote;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final family = offer.code == PlanState.family;
    final link = AppTypography.small.copyWith(
      fontWeight: FontWeight.w600,
      color: kColorPrimary600C2513F,
    );
    Widget textLink(String label, VoidCallback onTap) => InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
        child: Text(label, style: AppTypography.adapt(context, link)),
      ),
    );
    final points = [
      if (offer.relativeSlots > 0)
        l10n.subConfirmRelatives(offer.relativeSlots),
      l10n.subConfirmLimits(
        offer.storageGb,
        offer.videoMinutes ?? 0,
        offer.originalQuality ? 'yes' : 'no',
      ),
      if (showTrialNote) l10n.subConfirmTrialNote,
    ];
    return AppBottomSheet(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.itemGap,
        AppSpacing.screen,
        28,
      ),
      children: [
        Row(
          children: [
            Container(
              width: AppSpacing.s12,
              height: AppSpacing.s12,
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorPrimary50FFF4F1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                LucideIcons.crown,
                size: 24,
                color: AppColors.resolve(context, kColorPrimary600C2513F),
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.subConfirmTitle(planShortName(l10n, offer.code)),
                    style: AppTypography.adapt(context, AppTypography.title20),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    family
                        ? l10n.subConfirmAudienceFamily(
                            familyName,
                            papaCallName,
                            mamaCallName,
                          )
                        : l10n.subConfirmAudienceHouse(
                            familyName,
                            papaCallName,
                            mamaCallName,
                          ),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(height: 16 / 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            children: [
              AppKeyValueRow(
                label: l10n.subConfirmPrice,
                value: compactPriceText(offer.priceText),
                valueStyle: AppTypography.title16.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              AppKeyValueRow(
                label: l10n.subConfirmMonthly,
                value: compactPriceText(offer.monthlyText),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              AppKeyValueRow(
                label: l10n.subConfirmCycle,
                value: l10n.subConfirmCycleValue,
              ),
              const SizedBox(height: AppSpacing.itemGap),
              AppKeyValueRow(
                label: l10n.subConfirmEffective,
                value: l10n.subConfirmEffectiveValue,
              ),
              const SizedBox(height: AppSpacing.itemGap),
              AppKeyValueRow(
                label: l10n.subConfirmPayVia,
                value: l10n.subConfirmPayViaValue,
              ),
            ],
          ),
        ),
        Column(
          children: [
            for (final (index, point) in points.indexed) ...[
              if (index > 0) const SizedBox(height: AppSpacing.s2),
              AppIconTextRow(icon: LucideIcons.check, text: point),
            ],
          ],
        ),
        AppButton(
          label: l10n.subConfirmCta,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        Text(
          l10n.subConfirmLegal,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.tiny.copyWith(height: 1.45),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.s4,
          children: [
            textLink(l10n.subLinkTerms, () => showComingSoonSnackBar(context)),
            textLink(
              l10n.settingsPrivacy,
              () => showComingSoonSnackBar(context),
            ),
            textLink(
              l10n.billingRestore,
              () => showAppSnackBar(context, l10n.subRestoreNone),
            ),
          ],
        ),
      ],
    );
  }
}
