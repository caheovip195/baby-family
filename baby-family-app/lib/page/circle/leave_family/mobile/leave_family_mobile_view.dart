import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/circle/leave_family/leave_family_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_radio_mark.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/leave_choice.dart';

/// SET-10 — Rời gia đình (người thân, Pencil `Xq7SJ`).
class LeaveFamilyMobileView extends HookConsumerWidget {
  const LeaveFamilyMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(leaveFamilyControllerProvider);
    final l10n = context.l10n;
    final view = controller.view;
    final prefs = controller.preferences;

    Future<void> leave() async {
      await controller.leave();
      if (context.mounted) {
        await context.router.replaceAll([routeForSession(controller.session)]);
      }
    }

    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (view == null || prefs == null) {
      body = const SizedBox.shrink();
    } else {
      final viewer = view.viewer;
      final who = relativePronounCode(viewer.relation);
      final family = view.family.name;
      final inviter = controller.inviter?.displayName ?? '';
      final following = controller.following;
      const gap = SizedBox(height: AppSpacing.s4);
      final secondary = AppTypography.adapt(
        context,
        AppTypography.text14.copyWith(
          height: 20 / 14,
          color: kColorTextSecondary6B625B,
        ),
      );
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.cirLeaveTitle(family),
            style: AppTypography.adapt(
              context,
              AppTypography.h1.copyWith(fontSize: 28, height: 38 / 28),
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            l10n.cirLeaveBody(who, inviter),
            style: AppTypography.adapt(
              context,
              AppTypography.bodyLarge.copyWith(
                fontSize: 16,
                height: 24 / 16,
                color: kColorTextSecondary6B625B,
              ),
            ),
          ),
          gap,
          if (following.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.s4),
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 48 + (following.length - 1) * 38,
                    height: 48,
                    child: Stack(
                      children: [
                        for (final (index, child) in following.indexed)
                          Positioned(
                            left: index * 38,
                            child: ChildAvatar(
                              child: child,
                              size: 48,
                              borderColor: kColorSurfaceFFFFFF,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.cardInset),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.cirLeaveFollowing(
                            who,
                            following.map((child) => child.name).join(', '),
                          ),
                          style: AppTypography.adapt(
                            context,
                            AppTypography.title16.copyWith(
                              fontFamily: AppTypography.bodyFamily,
                              fontWeight: FontWeight.w600,
                              height: 20 / 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          relativePermissionSummary(l10n, viewer),
                          style: secondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            gap,
          ],
          AppCapsLabel(
            l10n.cirLeavePosted(who, prefs.postedPhotos, prefs.postedComments),
          ),
          gap,
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppColors.resolve(context, kColorBorderEADFD6),
              ),
            ),
            child: Column(
              children: [
                _LeaveChoice(
                  icon: LucideIcons.heart,
                  title: l10n.cirLeaveKeep,
                  description: l10n.cirLeaveKeepHint(who),
                  selected: !controller.removeContent,
                  divider: true,
                  onTap: () => controller.chooseRemove(false),
                ),
                _LeaveChoice(
                  icon: LucideIcons.eraser,
                  title: l10n.cirLeaveRemove,
                  description: l10n.cirLeaveRemoveHint(who, family),
                  selected: controller.removeContent,
                  onTap: () => controller.chooseRemove(true),
                ),
              ],
            ),
          ),
          gap,
          Container(
            padding: const EdgeInsets.all(AppSpacing.cardInset),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.bell,
                  size: 18,
                  color: AppColors.resolve(context, kColorTextSecondary6B625B),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Text(
                    l10n.cirLeaveNotice(inviter, viewer.callName, who),
                    style: secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s4 + AppSpacing.s2),
          AppButton(
            label: l10n.circleLeaveTitle,
            height: 56,
            fontSize: 17,
            color: kColorErrorD14B4B,
            isLoading: controller.isLoading,
            onPressed: leave,
          ),
          const SizedBox(height: AppSpacing.s3),
          AppButton.secondary(
            label: l10n.cirLeaveStay,
            height: 56,
            fontSize: 17,
            onPressed: () => context.router.maybePop(),
          ),
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
