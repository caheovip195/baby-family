import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/family/plan_info.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/page/parent/family/family_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_icon_badge.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:baby_family/utils/widget/app_page_header.dart';
import 'package:baby_family/utils/widget/app_progress_bar.dart';
import 'package:baby_family/utils/widget/app_relative_avatar.dart';
import 'package:baby_family/utils/widget/app_square_icon_button.dart';
import 'package:baby_family/utils/widget/app_tag_pill.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/add_row.dart';
part '../widgets/child_row.dart';
part '../widgets/locked_relatives.dart';
part '../widgets/member_row.dart';
part '../widgets/plan_card.dart';
part '../widgets/relative_row.dart';

/// FAM-01 — Gia đình (Pencil `r8l6e` gói Family, biến thể `XwXfH` dùng thử).
/// Dùng thử: người thân bị khoá → SUB-01; gói Family: “Quản lý gói” → SUB-01,
/// người thân → FAM-04, “Mời người thân (3/12)” → FAM-03. Bánh răng → FAM-07;
/// các con → CHD-01 (thai kỳ → PREG-01), “Thêm con / thai kỳ” → CHD-04.
class FamilyMobileView extends HookConsumerWidget {
  const FamilyMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(familyControllerProvider);
    final l10n = context.l10n;
    final family = controller.family;
    const gap = SizedBox(height: AppSpacing.s4);
    const rowGap = SizedBox(height: AppSpacing.s3);
    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (family == null) {
      body = const SizedBox.shrink();
    } else {
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s2,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          AppPageHeader(
            title: family.name,
            trailing: AppSquareIconButton(
              icon: LucideIcons.settings,
              tooltip: l10n.familySettingsTitle,
              onPressed: () => context.router.push(const FamilySettingsRoute()),
            ),
          ),
          gap,
          _PlanCard(
            plan: family.plan,
            today: controller.today,
            price: controller.planPrice,
            onPlans: () => context.router.push(const PlansRoute()),
          ),
          gap,
          AppCapsLabel(l10n.familyParents),
          gap,
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Column(
              children: [
                for (final (index, parent) in controller.parents.indexed) ...[
                  if (index > 0) rowGap,
                  _MemberRow(
                    member: parent,
                    isMe: parent.id == controller.me?.id,
                  ),
                ],
              ],
            ),
          ),
          gap,
          AppCapsLabel(l10n.familyChildren),
          gap,
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Column(
              children: [
                for (final child in controller.children) ...[
                  _ChildRow(
                    child: child,
                    today: controller.today,
                    onTap: () => context.router.push(
                      child.isPregnancy
                          ? PregnancyJourneyRoute(pregnancyId: child.id)
                          : ChildProfileRoute(childId: child.id),
                    ),
                  ),
                  rowGap,
                ],
                _AddRow(
                  label: l10n.familyAddChild,
                  onTap: () => context.router.push(const ChildAddRoute()),
                ),
              ],
            ),
          ),
          gap,
          AppCapsLabel(l10n.familyRelatives),
          gap,
          if (controller.allowsRelatives)
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Column(
                children: [
                  for (final relative in controller.relatives) ...[
                    _RelativeRow(
                      member: relative,
                      description: relativeRelationDescription(
                        l10n,
                        relative,
                        papaCallName: controller.callNameOf(FamilyRole.father),
                        mamaCallName: controller.callNameOf(FamilyRole.mother),
                      ),
                      childNames: controller.followedChildNames(relative),
                      onTap: () => context.router.push(
                        RelativeDetailRoute(memberId: relative.id),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.cardInset),
                  ],
                  _AddRow(
                    label: l10n.famInviteRelativeCount(
                      family.plan.relativeSlotsUsed,
                      family.plan.relativeSlotsMax,
                    ),
                    icon: LucideIcons.userPlus,
                    iconBackground: kColorPrimary50FFF4F1,
                    iconColor: kColorPrimary700A2402F,
                    onTap: () =>
                        context.router.push(const RelativeInviteRoute()),
                  ),
                ],
              ),
            )
          else
            _LockedRelatives(
              onTap: () => context.router.push(const PlansRoute()),
            ),
        ],
      );
    }
    return BaseScaffold(
      isLoading: controller.isLoading && family == null,
      body: SafeArea(bottom: false, child: body),
    );
  }
}
