import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/onboarding_notifications/onboarding_notifications_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/notification_preview.dart';

/// ONB-10 (Pencil TbUns): 3 thông báo mẫu, “Đừng bỏ lỡ khoảnh khắc nào”,
/// “Bật thông báo” / “Để sau” → ONB-09.
class OnboardingNotificationsMobileView extends HookConsumerWidget {
  const OnboardingNotificationsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingNotificationsControllerProvider);
    final l10n = context.l10n;
    final babies = controller.babies;
    final younger = babies.isEmpty
        ? l10n.onbNotifChildFallback
        : babies.last.name;
    final older = babies.isEmpty
        ? l10n.onbNotifChildFallback
        : babies.first.name;
    final sender = controller.me?.callName ?? kValueDefaultCallNameMother;
    final receiver =
        controller.partner?.callName ?? kValueDefaultCallNameFather;
    void next() => context.router.push(const OnboardingFirstMemoryRoute());
    return AppStepScaffold(
      topPadding: AppSpacing.s10,
      actions: [
        AppButton(
          label: l10n.onboardingEnableNotifications,
          isLoading: controller.isLoading,
          onPressed: () async {
            await controller.enable();
            if (context.mounted) {
              next();
            }
          },
        ),
        Center(
          child: TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(0, 44)),
            onPressed: next,
            child: Text(
              l10n.commonLater,
              style: AppTypography.adapt(
                context,
                AppTypography.label.copyWith(color: kColorTextSecondary6B625B),
              ),
            ),
          ),
        ),
      ],
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
          child: Column(
            children: [
              _NotificationPreview(
                icon: LucideIcons.listChecks,
                color: kColorSecondary7003F7A5C,
                background: kColorSecondary100E4F2EA,
                meta: l10n.onbNotifMeta(l10n.onbNotifNow),
                title: l10n.onbNotifRequestTitle(sender, receiver, younger),
                body: l10n.onbNotifRequestBody,
              ),
              const SizedBox(height: AppSpacing.itemGap),
              _NotificationPreview(
                icon: LucideIcons.images,
                color: kColorPrimary600C2513F,
                background: kColorPrimary100FFE3DC,
                meta: l10n.onbNotifMeta(l10n.onbNotif5Minutes),
                title: l10n.onbNotifPhotosTitle(older),
                body: l10n.onbNotifPhotosBody,
              ),
              const SizedBox(height: AppSpacing.itemGap),
              _NotificationPreview(
                icon: LucideIcons.heartHandshake,
                color: kColorUs7006A549F,
                background: kColorUs100EAE2F8,
                meta: l10n.onbNotifMeta(l10n.onbNotif1Hour),
                title: l10n.onbNotifUsTitle,
                body: l10n.onbNotifUsBody,
              ),
            ],
          ),
        ),
        AppStepHeading(
          title: l10n.onboardingNotificationsTitle,
          subtitle: l10n.onboardingNotificationsSubtitle,
          center: true,
        ),
      ],
    );
  }
}
