import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/page/parent/upgrade_plan/upgrade_plan_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/plan_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/plan_confirm_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/compare_table.dart';
part '../widgets/not_payer_card.dart';
part '../widgets/price_card.dart';

/// SUB-04 — Nâng cấp House → Family (Pencil `UqZ8p`, seed `house`): bảng so
/// sánh, giá hiện tại → Family, nút nâng cấp → SUB-02 → mua (mock); khối
/// “Papa sẽ thấy” cho người không thanh toán.
class UpgradePlanMobileView extends HookConsumerWidget {
  const UpgradePlanMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(upgradePlanControllerProvider);
    final house = controller.house;
    final family = controller.familyOffer;
    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (house == null || family == null) {
      body = const SizedBox.shrink();
    } else {
      body = _content(context, controller, house, family);
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }

  Widget _content(
    BuildContext context,
    UpgradePlanController controller,
    PlanOffer house,
    PlanOffer family,
  ) {
    final l10n = context.l10n;
    final channel = controller.details?.channel ?? '';
    final familyPrice = compactPriceText(family.priceText);
    const gap = SizedBox(height: AppSpacing.cardInset);

    Future<void> upgrade() async {
      final confirmed = await showPlanConfirmSheet(
        context,
        offer: family,
        familyName: controller.family?.name ?? '',
        papaCallName: controller.callNameOf(FamilyRole.father),
        mamaCallName: controller.callNameOf(FamilyRole.mother),
        showTrialNote: controller.inTrial,
      );
      if (!confirmed || !context.mounted) {
        return;
      }
      await controller.upgrade();
      if (!context.mounted) {
        return;
      }
      showAppSnackBar(
        context,
        l10n.subPurchased(planShortName(l10n, PlanState.family)),
      );
      await context.router.maybePop();
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        28 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Text(
          l10n.subUpgradeTitle,
          style: AppTypography.adapt(
            context,
            AppTypography.h1.copyWith(height: 1.2),
          ),
        ),
        const SizedBox(height: AppSpacing.compact),
        Text(
          l10n.subUpgradeSubtitle(controller.payerCallName, channel),
          style: AppTypography.adapt(
            context,
            AppTypography.text14.copyWith(
              height: 1.45,
              color: kColorTextSecondary6B625B,
            ),
          ),
        ),
        gap,
        _CompareTable(house: house, family: family),
        gap,
        _PriceCard(
          currentPrice: compactPriceText(house.priceText),
          newPrice: familyPrice,
          channel: channel,
        ),
        const SizedBox(height: AppSpacing.cardInset + AppSpacing.s1),
        AppButton(
          label: l10n.subUpgradeCta(familyPrice),
          isLoading: controller.isLoading,
          onPressed: upgrade,
        ),
        const SizedBox(height: AppSpacing.s2),
        Text(
          l10n.subUpgradeLegal,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.tiny.copyWith(height: 1.45),
          ),
        ),
        if (controller.otherParentCallName.isNotEmpty) ...[
          gap,
          _NotPayerCard(
            partner: controller.otherParentCallName,
            payer: controller.payerCallName,
          ),
        ],
      ],
    );
  }
}
