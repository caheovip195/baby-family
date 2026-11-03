import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/memory_perspective/memory_perspective_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/extension/string.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_action_top_bar.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/playable_voice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/media_tile.dart';
part '../widgets/original_memory_card.dart';

/// MEM-24 Thêm góc nhìn của bạn (Pencil `Skx8C`).
class MemoryPerspectiveMobileView extends HookConsumerWidget {
  const MemoryPerspectiveMobileView({required this.memoryId, super.key});

  final String memoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(memoryPerspectiveControllerProvider);
    useEffect(() {
      Future.microtask(() => controller.init(memoryId));
      return null;
    }, const []);
    final l10n = context.l10n;
    Future<void> save() async {
      if (await controller.save() && context.mounted) {
        await context.router.maybePop(true);
      }
    }

    final memory = controller.memory;
    final audience = memory == null
        ? ''
        : memoryAudience(l10n, memory.visibility, controller.people);
    final text = AppTypography.adapt(
      context,
      AppTypography.body.copyWith(height: 1.5),
    );
    return BaseScaffold(
      isLoading: controller.isLoading,
      appBar: AppActionTopBar(
        title: l10n.memoriesPerspective,
        actionLabel: l10n.commonSave,
        onAction: save,
        height: 52,
        closeIconSize: 22,
        titleStyle: AppTypography.title17,
        actionStyle: AppTypography.body.copyWith(
          fontWeight: FontWeight.w700,
          height: 19 / 15,
          color: kColorPrimary700A2402F,
        ),
      ),
      body: !controller.loaded
          ? const Center(child: CircleLoadingProgress())
          : CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      AppSpacing.s2,
                      AppSpacing.screen,
                      AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (memory != null)
                          _OriginalMemoryCard(controller: controller),
                        const SizedBox(height: AppSpacing.s4),
                        Text(
                          l10n.memoriesPerspectivePrompt,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.h2.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Container(
                          constraints: const BoxConstraints(minHeight: 180),
                          padding: const EdgeInsets.all(AppSpacing.s4),
                          decoration: BoxDecoration(
                            color: AppColors.resolve(context, kColorUs50F6F2FC),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            border: Border.all(
                              color: AppColors.resolve(
                                context,
                                kColorUs100EAE2F8,
                              ),
                            ),
                          ),
                          child: TextField(
                            controller: controller.body,
                            maxLines: null,
                            maxLength: 1000,
                            style: text,
                            decoration: InputDecoration(
                              hintText: l10n.memoriesPerspectiveHint,
                              hintStyle: text.copyWith(
                                color: AppColors.resolve(
                                  context,
                                  kColorTextTertiary9C928A,
                                ),
                              ),
                              counterText: '',
                              filled: false,
                              isDense: true,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Wrap(
                          spacing: AppSpacing.itemGap,
                          runSpacing: AppSpacing.itemGap,
                          children: [
                            for (final asset in controller.mediaAssets)
                              GestureDetector(
                                key: ValueKey('perspective-photo-$asset'),
                                // Chạm ảnh để bỏ khỏi góc nhìn.
                                onTap: () => controller.removeMedia(asset),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.tile,
                                  ),
                                  child: isLocalVideo(asset)
                                      ? Container(
                                          width: 72,
                                          height: 72,
                                          color: AppColors.resolve(
                                            context,
                                            kColorTextPrimary2E2A27,
                                          ),
                                          child: const Icon(
                                            LucideIcons.video,
                                            color: kColorWhiteAlpha80,
                                          ),
                                        )
                                      : Image(
                                          image: mediaImageProvider(asset),
                                          width: 72,
                                          height: 72,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            if (controller.mediaAssets.length <
                                MemoryPerspectiveController.maxMedia)
                              _MediaTile(
                                key: const ValueKey('perspective-photos'),
                                icon: LucideIcons.imagePlus,
                                label: l10n.memoriesPhotos,
                                onTap: () async {
                                  // Ảnh/video gốc: client nén khi tải lên;
                                  // video quá giới hạn của gói bị bỏ.
                                  final picked = await ImagePicker()
                                      .pickMultipleMedia();
                                  final tooLong = await controller.addPicked([
                                    for (final file in picked) file.path,
                                  ]);
                                  if (tooLong != null && context.mounted) {
                                    showAppSnackBar(
                                      context,
                                      l10n.subLimitVideoTitle(tooLong),
                                    );
                                  }
                                },
                              ),
                            _MediaTile(
                              key: const ValueKey('perspective-voice'),
                              icon: controller.recording
                                  ? LucideIcons.square
                                  : controller.hasVoice
                                  ? LucideIcons.trash2
                                  : LucideIcons.mic,
                              label: controller.recording
                                  ? l10n.memVoiceStop
                                  : controller.hasVoice
                                  ? l10n.commonDelete
                                  : l10n.memFilterVoice,
                              active: controller.recording,
                              onTap: controller.toggleVoice,
                            ),
                          ],
                        ),
                        if (controller.recording) ...[
                          const SizedBox(height: AppSpacing.s3),
                          Text(
                            l10n.memVoiceRecording,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.small,
                            ),
                          ),
                        ] else if (controller.micDenied) ...[
                          const SizedBox(height: AppSpacing.s3),
                          Text(
                            l10n.memVoiceMicDenied,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.small,
                            ),
                          ),
                        ] else if (controller.hasVoice) ...[
                          const SizedBox(height: AppSpacing.s3),
                          PlayableVoiceCard(
                            title: l10n.memFilterVoice,
                            duration: memoryDuration(
                              controller.voiceDurationSec ?? 0,
                            ),
                            url: controller.voicePath ?? controller.voiceUrl,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.s4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s3,
                            vertical: AppSpacing.itemGap,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.resolve(
                              context,
                              kColorSurfaceVariantF7F1EC,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.tile),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.eye,
                                size: 14,
                                color: AppColors.resolve(
                                  context,
                                  kColorTextSecondary6B625B,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.s2),
                              Expanded(
                                child: Text(
                                  l10n.memInheritedAudience(audience),
                                  style: AppTypography.adapt(
                                    context,
                                    AppTypography.small,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: AppSpacing.s4),
                        AppButton.us(
                          label: l10n.memoriesSavePerspective,
                          isLoading: controller.isLoading,
                          onPressed: save,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
