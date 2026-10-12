import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/onboarding_first_memory/onboarding_first_memory_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// ONB-09 (không có frame Pencil — dựng theo ONB-08/ONB-10): huy hiệu ảnh,
/// “Ký ức đầu tiên của nhà mình”, “Chọn ảnh” / “Để sau”.
class OnboardingFirstMemoryMobileView extends HookConsumerWidget {
  const OnboardingFirstMemoryMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingFirstMemoryControllerProvider);
    final l10n = context.l10n;
    final child = controller.child;
    return AppStepScaffold(
      topPadding: AppSpacing.s10,
      gap: 28,
      actions: [
        AppButton(
          label: l10n.onboardingFirstMemoryChoosePhoto,
          icon: LucideIcons.images,
          isLoading: controller.isLoading,
          onPressed: () async {
            await controller.finish();
            if (!context.mounted) {
              return;
            }
            await context.router.replaceAll([
              const MainShellRoute(),
              MemoryComposerRoute(
                kind: MemoryKind.photo.name,
                childId: controller.child?.id,
              ),
            ]);
          },
        ),
        Center(
          child: TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(0, 44)),
            onPressed: () async {
              await controller.finish();
              if (context.mounted) {
                await context.router.replaceAll([const MainShellRoute()]);
              }
            },
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
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorPrimary100FFE3DC),
              borderRadius: BorderRadius.circular(AppRadius.sheet),
            ),
            child: Icon(
              LucideIcons.images,
              size: 36,
              color: AppColors.resolve(context, kColorPrimary600C2513F),
            ),
          ),
        ),
        AppStepHeading(
          title: l10n.onboardingFirstMemoryTitle,
          subtitle: child == null
              ? l10n.onboardingFirstMemorySubtitle
              : l10n.onbFirstMemorySubtitle(child.name),
          center: true,
        ),
      ],
    );
  }
}
