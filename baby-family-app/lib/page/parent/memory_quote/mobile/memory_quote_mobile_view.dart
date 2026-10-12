import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/page/parent/memory_quote/memory_quote_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/memory_visibility_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/quote_box.dart';
part '../widgets/quote_kid_chip.dart';
part '../widgets/quote_option.dart';

/// MEM-23 Ghi câu nói của con (Pencil `gKmSW`): sheet trên nền màn trước
/// (route trong suốt + scrim `#2E2A2799`).
class MemoryQuoteMobileView extends HookConsumerWidget {
  const MemoryQuoteMobileView({this.childId, super.key});

  final String? childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(memoryQuoteControllerProvider);
    useEffect(() {
      Future.microtask(() => controller.init(childId));
      return null;
    }, const []);
    final l10n = context.l10n;
    Future<void> save() async {
      if (await controller.save() && context.mounted) {
        ScaffoldMessenger.maybeOf(
          context,
        )?.showSnackBar(SnackBar(content: Text(l10n.memoriesSaved)));
        await context.router.maybePop(true);
      }
    }

    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.router.maybePop(),
            ),
          ),
          AppBottomSheet(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.itemGap,
              AppSpacing.screen,
              28,
            ),
            gap: AppSpacing.cardInset,
            children: [
              Text(
                l10n.memoriesQuote,
                style: AppTypography.adapt(context, AppTypography.title20),
              ),
              Wrap(
                spacing: AppSpacing.s2,
                runSpacing: AppSpacing.s2,
                children: [
                  for (final child in controller.children)
                    _QuoteKidChip(
                      child: child,
                      selected: child.id == controller.childId,
                      onTap: () => controller.selectChild(child.id),
                    ),
                ],
              ),
              _QuoteBox(controller: controller),
              AppTextField(
                label: l10n.memQuoteContextLabel,
                hint: l10n.memQuoteContextHint,
                controller: controller.quoteContext,
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _QuoteOption(
                        icon: controller.voiceAttached
                            ? LucideIcons.check
                            : LucideIcons.mic,
                        label: l10n.memoriesRecordVoice,
                        background: kColorSecondary100E4F2EA,
                        foreground: kColorSecondary7003F7A5C,
                        bold: true,
                        onTap: controller.toggleVoice,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    Expanded(
                      child: _QuoteOption(
                        icon: LucideIcons.users,
                        label: memoryAudience(
                          l10n,
                          controller.visibility,
                          controller.people,
                        ),
                        background: kColorSurfaceVariantF7F1EC,
                        foreground: kColorTextSecondary6B625B,
                        onTap: () async {
                          final value = await showMemoryVisibilitySheet(
                            context,
                            current: controller.visibility,
                          );
                          if (value != null) {
                            controller.setVisibility(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                label: l10n.memoriesSaveQuote,
                isLoading: controller.isLoading,
                onPressed: controller.loaded ? save : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
