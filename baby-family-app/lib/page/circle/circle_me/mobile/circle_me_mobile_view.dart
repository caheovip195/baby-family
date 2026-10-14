import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/circle/circle_me/circle_me_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_radio_mark.dart';
import 'package:baby_family/utils/widget/app_relative_avatar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/switch_family_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/me_link_row.dart';
part '../widgets/me_notify_option.dart';
part '../widgets/text_size_segment.dart';

/// CIR-06 — Tôi (người thân, Pencil `SSv4W`).
class CircleMeMobileView extends HookConsumerWidget {
  const CircleMeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(circleMeControllerProvider);
    final l10n = context.l10n;
    final view = controller.view;
    final prefs = controller.preferences;

    Future<void> switchFamily() async {
      final memberships = await controller.memberships();
      if (!context.mounted) {
        return;
      }
      final familyId = await showSwitchFamilySheet(
        context,
        memberships: memberships,
      );
      if (familyId != null) {
        await controller.switchFamily(familyId);
      }
    }

    Future<void> pickDigestTime() async {
      final parts = (prefs?.digestTime ?? '19:00').split(':');
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: int.tryParse(parts.first) ?? 19,
          minute: int.tryParse(parts.last) ?? 0,
        ),
      );
      if (picked != null) {
        await controller.setDigestTime(
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}',
        );
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
      final section = AppTypography.adapt(
        context,
        AppTypography.title20.copyWith(fontSize: 19, height: 26 / 19),
      );
      const gap = SizedBox(height: AppSpacing.s5);
      const titleGap = SizedBox(height: AppSpacing.s3);
      final relation =
          prefs.relationNote ?? relativeRelationLabel(l10n, viewer.relation);
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s2,
          AppSpacing.screen,
          28 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.circleTabMe,
            style: AppTypography.adapt(
              context,
              AppTypography.display.copyWith(fontSize: 30, height: 41 / 30),
            ),
          ),
          gap,
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: AppColors.resolve(context, kColorBorderEADFD6),
              ),
            ),
            child: Row(
              children: [
                AppRelativeAvatar(
                  name: viewer.callName,
                  relation: viewer.relation,
                  size: 64,
                ),
                const SizedBox(width: AppSpacing.cardInset),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewer.callName,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.h2.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        relation.isEmpty
                            ? view.family.name
                            : l10n.cirMeRelation(relation, view.family.name),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.bodyLarge.copyWith(
                            fontSize: 16,
                            height: 20 / 16,
                            color: kColorTextSecondary6B625B,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.cardInset),
                Material(
                  color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
                  shape: const StadiumBorder(),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: () =>
                        context.router.push(const ProfileSettingsRoute()),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: AppSpacing.iconButton,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s4,
                        ),
                        child: Center(
                          widthFactor: 1,
                          child: Text(
                            l10n.memCommentEdit,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.title16.copyWith(
                                fontFamily: AppTypography.bodyFamily,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          gap,
          Text(l10n.settingsTextSize, style: section),
          titleGap,
          _TextSizeSegment(
            selected: controller.textSize,
            onChanged: controller.changeTextSize,
          ),
          titleGap,
          Container(
            padding: const EdgeInsets.all(AppSpacing.cardInset),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: AppColors.resolve(context, kColorBorderEADFD6),
              ),
            ),
            child: Text(
              l10n.cirMeTextPreview(controller.previewChild?.name ?? '', who),
              style: AppTypography.adapt(
                context,
                AppTypography.h3.copyWith(
                  fontFamily: AppTypography.bodyFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          gap,
          Text(l10n.commonNotifications, style: section),
          titleGap,
          _MeNotifyOption(
            title: l10n.cirMeInstant,
            selected: !prefs.dailyDigest,
            onTap: () => controller.chooseDigest(false),
          ),
          titleGap,
          _MeNotifyOption(
            title: l10n.cirMeDigest,
            subtitle: l10n.cirMeDigestHint(prefs.digestTime),
            selected: prefs.dailyDigest,
            time: prefs.digestTime,
            onTap: () => controller.chooseDigest(true),
            onTime: pickDigestTime,
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
                _MeLinkRow(
                  icon: LucideIcons.repeat,
                  title: l10n.cirMeSwitchFamily,
                  subtitle: l10n.cirMeViewing(view.family.name),
                  onTap: switchFamily,
                ),
                _MeLinkRow(
                  icon: LucideIcons.lifeBuoy,
                  title: l10n.settingsHelp,
                  onTap: () => context.router.push(const HelpRoute()),
                ),
                _MeLinkRow(
                  icon: LucideIcons.logOut,
                  title: l10n.circleLeaveTitle,
                  color: kColorErrorD14B4B,
                  onTap: () => context.router.push(const LeaveFamilyRoute()),
                ),
                _MeLinkRow(
                  icon: LucideIcons.userX,
                  title: l10n.settingsDeleteAccount,
                  color: kColorTextSecondary6B625B,
                  last: true,
                  onTap: () => context.router.push(const DeleteAccountRoute()),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return BaseScaffold(body: SafeArea(bottom: false, child: body));
  }
}
