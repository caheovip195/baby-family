import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/monthly_camera/monthly_camera_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/camera_pill.dart';
part '../widgets/sticker_picker.dart';

/// MEM-21 Chụp ảnh tháng (Pencil `RULzX`) — camera mô phỏng.
class MonthlyCameraMobileView extends HookConsumerWidget {
  const MonthlyCameraMobileView({required this.childId, this.month, super.key});

  final String childId;
  final int? month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(monthlyCameraControllerProvider);
    useEffect(() {
      Future.microtask(() => controller.init(childId, month));
      return null;
    }, const []);
    final l10n = context.l10n;
    final child = controller.child;
    final viewfinder = controller.viewfinder;
    final ghost = controller.ghostAsset;
    final sticker = controller.selectedSticker;
    final top = MediaQuery.paddingOf(context).top;
    Future<void> capture() async {
      final router = context.router;
      final saved = await router.push<bool>(
        MemoryComposerRoute(
          kind: MemoryKind.monthlyPhoto.name,
          childId: childId,
        ),
      );
      if (saved ?? false) {
        await router.maybePop(true);
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: kColorBlack,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (viewfinder != null) Image.asset(viewfinder, fit: BoxFit.cover),
            if (controller.ghostOn && ghost != null)
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                height: 520,
                child: Opacity(
                  opacity: 0.28,
                  child: Image.asset(ghost, fit: BoxFit.cover),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.s4,
                    top > 0 ? top + 6 : 54,
                    AppSpacing.s4,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _CameraPill.icon(
                            icon: LucideIcons.x,
                            label: l10n.commonClose,
                            onTap: () => context.router.maybePop(),
                          ),
                          Expanded(
                            child: Center(
                              child: _CameraPill(
                                label: l10n.memComposerMonthly(
                                  controller.month,
                                  child?.name ?? '',
                                ),
                                height: 36,
                                bold: true,
                              ),
                            ),
                          ),
                          _CameraPill.icon(
                            icon: LucideIcons.refreshCw,
                            iconSize: 18,
                            label: l10n.memFlipCamera,
                          ),
                        ],
                      ),
                      if (ghost != null) ...[
                        const SizedBox(height: AppSpacing.itemGap),
                        _CameraPill(
                          icon: LucideIcons.layers,
                          label: l10n.memGhostToggle(
                            controller.month - 1,
                            MonthlyCameraController.ghostPercent,
                          ),
                          height: 32,
                          onTap: controller.toggleGhost,
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(),
                if (sticker != null && child != null)
                  Center(
                    child: Container(
                      height: 64,
                      constraints: const BoxConstraints(minWidth: 170),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s6,
                      ),
                      decoration: BoxDecoration(
                        color: ChildAvatar.colorOf(child),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(color: kColorWhite),
                      ),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          sticker,
                          maxLines: 1,
                          style: AppTypography.display.copyWith(
                            fontSize: 28,
                            height: 38 / 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
                Container(
                  color: kColorBlackAlpha70,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.s4,
                    AppSpacing.screen,
                    40,
                  ),
                  child: Column(
                    children: [
                      _StickerPicker(controller: controller),
                      const SizedBox(height: AppSpacing.sectionGap),
                      _shutterRow(context, controller, capture),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shutterRow(
    BuildContext context,
    MonthlyCameraController controller,
    VoidCallback capture,
  ) {
    final l10n = context.l10n;
    final gallery = controller.child?.avatarAsset;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Semantics(
          button: true,
          label: l10n.memoriesGallery,
          excludeSemantics: true,
          child: GestureDetector(
            onTap: capture,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.tile),
                border: Border.all(color: kColorWhite),
              ),
              clipBehavior: Clip.antiAlias,
              child: gallery == null
                  ? null
                  : Image.asset(gallery, fit: BoxFit.cover),
            ),
          ),
        ),
        Semantics(
          button: true,
          label: l10n.memoriesCapture,
          excludeSemantics: true,
          child: GestureDetector(
            onTap: capture,
            child: Container(
              width: 76,
              height: 76,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kColorWhite, width: 2),
              ),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: kColorWhite,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        _CameraPill.icon(
          icon: LucideIcons.sun,
          label: l10n.memBrightness,
          size: 48,
          background: kColorWhiteAlpha13,
        ),
      ],
    );
  }
}
