import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/page/general/plans/plans_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/plan_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_radio_mark.dart';
import 'package:baby_family/utils/widget/app_square_icon_button.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/plan_confirm_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/plan_feature.dart';
part '../widgets/plan_offer_card.dart';
part '../widgets/trial_badge.dart';

/// SUB-01 — Chọn gói (Pencil `OUXZg`). Mua → SUB-02 (xác nhận) → mock thành
/// công → snackbar + quay lại; mở từ SUB-07 (hết hạn) thì vào lại app theo
/// phiên.
class PlansMobileView extends HookConsumerWidget {
  const PlansMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(plansControllerProvider);
    final l10n = context.l10n;
    final offer = controller.selectedOffer;
    final trialDays = controller.trialDaysLeft;

    String planName(PlanState code) => planShortName(l10n, code);

    Future<void> purchase() async {
      final fromExpired = context.router.stack.any(
        (route) => route.name == ExpiredRoute.name,
      );
      final offer = controller.selectedOffer;
      if (offer == null) {
        return;
      }
      // SUB-02: xác nhận trước khi mở bảng thanh toán của Store.
      final confirmed = await showPlanConfirmSheet(
        context,
        offer: offer,
        familyName: controller.family?.name ?? '',
        papaCallName: controller.callNameOf(FamilyRole.father),
        mamaCallName: controller.callNameOf(FamilyRole.mother),
        showTrialNote: controller.trialDaysLeft != null,
      );
      if (!confirmed || !context.mounted) {
        return;
      }
      await controller.purchase();
      if (!context.mounted) {
        return;
      }
      showAppSnackBar(
        context,
        l10n.subPurchased(planName(controller.selected)),
      );
      if (fromExpired || !context.router.canPop()) {
        await context.router.replaceAll([routeForSession(controller.session)]);
      } else {
        await context.router.maybePop();
      }
    }

    // “399.000đ / năm” → “399.000đ” cho nút mua.
    String shortPrice(PlanOffer offer) => offer.priceText.split(' / ').first;

    return BaseScaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen - AppSpacing.s1,
              ),
              child: Row(
                children: [
                  AppSquareIconButton(
                    icon: LucideIcons.x,
                    tooltip: l10n.commonClose,
                    onPressed: () => context.router.maybePop(),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        showAppSnackBar(context, l10n.subRestoreNone),
                    child: Text(
                      l10n.billingRestore,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w600,
                          color: kColorPrimary700A2402F,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.s2,
                  AppSpacing.screen,
                  AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
                ),
                children: [
                  Text(
                    l10n.billingTitle,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.h1.copyWith(height: 1.2),
                    ),
                  ),
                  if (trialDays != null) ...[
                    const SizedBox(height: AppSpacing.s4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _TrialBadge(text: l10n.subTrialLeft(trialDays)),
                    ),
                  ],
                  for (final item in controller.offers) ...[
                    const SizedBox(height: AppSpacing.s4),
                    _PlanOfferCard(
                      offer: item,
                      name: planName(item.code),
                      selected: item.code == controller.selected,
                      onTap: () => controller.select(item.code),
                    ),
                  ],
                  if (offer != null) ...[
                    const SizedBox(height: AppSpacing.s4),
                    AppButton(
                      label: controller.isCurrentPlan
                          ? l10n.subCurrentPlan
                          : l10n.subBuy(
                              planName(offer.code),
                              shortPrice(offer),
                            ),
                      isLoading: controller.isLoading,
                      onPressed: controller.isCurrentPlan ? null : purchase,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    l10n.billingLegal,
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.tiny.copyWith(height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
