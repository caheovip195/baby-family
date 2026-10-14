import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/plan_details.dart';
import 'package:baby_family/data/model/family/storage_usage.dart';
import 'package:baby_family/page/parent/family_plan/family_plan_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/plan_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_icon_badge.dart';
import 'package:baby_family/utils/widget/app_info_note.dart';
import 'package:baby_family/utils/widget/app_key_value_row.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/app_tag_pill.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/plan_hero.dart';
part '../widgets/storage_card.dart';

/// SUB-03 — Gói của gia đình (Pencil `V2vtZ`): thẻ gói (trạng thái, gia hạn,
/// người thanh toán, kênh, áp dụng cho), dung lượng theo loại, “Trong gói
/// của nhà mình” (người thân, lượt AI, video), “Quản lý trong App Store”,
/// “Đổi gói” (House → SUB-04, còn lại SUB-01), “Khôi phục giao dịch”.
class FamilyPlanMobileView extends HookConsumerWidget {
  const FamilyPlanMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(familyPlanControllerProvider);
    final details = controller.details;
    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (details == null) {
      body = const SizedBox.shrink();
    } else {
      body = _content(context, controller, details);
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }

  Widget _content(
    BuildContext context,
    FamilyPlanController controller,
    PlanDetails details,
  ) {
    final l10n = context.l10n;
    final locale = context.localeName;
    final plan = details.plan;
    final payer = controller.payer;
    final payerName = payer?.callName ?? '';
    const gap = SizedBox(height: AppSpacing.cardInset);
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        28 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Text(
          l10n.billingPlanTitle,
          style: AppTypography.adapt(context, AppTypography.h1),
        ),
        gap,
        _PlanHero(
          title: planTitle(l10n, plan.state),
          price: controller.price,
          rows: [
            if (plan.endsAt != null)
              (l10n.subPlanAutoRenew, plan.endsAt!.toFormDate(locale)),
            if (payer != null)
              (
                l10n.subPlanPayer,
                controller.isPayer ? l10n.familyYou(payerName) : payerName,
              ),
            if (details.channel.isNotEmpty)
              (l10n.subPlanChannel, details.channel),
            (
              l10n.subPlanAppliesTo,
              l10n.subPlanWholeFamily(controller.family?.name ?? ''),
            ),
          ],
        ),
        gap,
        AppCapsLabel(l10n.familyStorageLabel),
        gap,
        _StorageCard(
          usedMb: plan.storageUsedMb,
          quotaMb: plan.storageQuotaMb,
          storage: details.storage,
        ),
        gap,
        AppCapsLabel(l10n.subPlanIncluded),
        gap,
        AppGroupedList(
          children: [
            _usageRow(
              icon: LucideIcons.users,
              title: l10n.subPlanRelatives,
              subtitle: details.relativeNames.join(' · '),
              value: l10n.subPlanSlots(
                plan.relativeSlotsUsed,
                plan.relativeSlotsMax,
              ),
            ),
            _usageRow(
              icon: LucideIcons.sparkles,
              title: l10n.subPlanAi,
              subtitle: details.aiRenewsAt == null
                  ? null
                  : l10n.subPlanAiRenews(
                      details.aiRenewsAt!.toFormDate(locale),
                    ),
              value: l10n.subPlanAiLeft(details.aiRemaining, details.aiTotal),
            ),
            _usageRow(
              icon: LucideIcons.film,
              title: l10n.subPlanVideo,
              subtitle: plan.state == PlanState.family
                  ? l10n.subPlanVideoHint(details.photosPerMemory)
                  : l10n.subPlanVideoHintCompressed(details.photosPerMemory),
              value: l10n.subPlanMinutes(details.videoMaxMinutes),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.cardInset + AppSpacing.compact),
        AppButton(
          label: l10n.subPlanManageStore(details.channel),
          onPressed: () => showAppSnackBar(
            context,
            l10n.subManageStoreMock(details.channel),
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        AppButton.secondary(
          label: l10n.subPlanChange,
          onPressed: () => context.router.push(
            plan.state == PlanState.house
                ? const UpgradePlanRoute()
                : const PlansRoute(),
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Center(
          child: AppPillButton(
            label: l10n.billingRestore,
            height: 30,
            fontSize: 14,
            color: kColorTransparent,
            foreground: kColorPrimary600C2513F,
            onPressed: () => showAppSnackBar(context, l10n.subRestoreNone),
          ),
        ),
        gap,
        AppInfoNote(
          icon: LucideIcons.info,
          text: l10n.subPlanNote(
            details.channel,
            payerName,
            controller.otherParentCallName,
          ),
          background: kColorSurfaceVariantF7F1EC,
          iconColor: kColorTextSecondary6B625B,
          iconSize: 16,
          lineHeight: 1.45,
          alignTop: true,
        ),
      ],
    );
  }

  Widget _usageRow({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
  }) => AppSettingsRow(
    icon: icon,
    iconSize: 16,
    title: title,
    titleSize: 14,
    titleWeight: FontWeight.w600,
    subtitle: subtitle == null || subtitle.isEmpty ? null : subtitle,
    subtitleColor: kColorTextTertiary9C928A,
    value: value,
    valueStrong: true,
    showChevron: false,
  );
}
