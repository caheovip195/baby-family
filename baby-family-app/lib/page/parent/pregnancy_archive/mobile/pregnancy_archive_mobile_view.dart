import 'package:auto_route/auto_route.dart';
import 'package:baby_family/gen/assets.gen.dart';
import 'package:baby_family/page/parent/pregnancy_archive/pregnancy_archive_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/archive_option_card.dart';
part '../widgets/muted_switch.dart';

/// PREG-06 (g7Q7Qy) — bảng màu trầm: minh hoạ 120, tiêu đề 22/800, phụ 14
/// (lh 1.5), 2 lựa chọn, công tắc “Chỉ Papa & Mama…”, liên kết hỗ trợ, nút
/// viền “Lưu trữ”, ghi chú không thông báo cho người thân.
class PregnancyArchiveMobileView extends HookConsumerWidget {
  const PregnancyArchiveMobileView({required this.pregnancyId, super.key});

  final String pregnancyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(pregnancyArchiveControllerProvider);
    useEffect(() {
      Future.microtask(() => controller.init(pregnancyId));
      return null;
    }, [pregnancyId]);
    final l10n = context.l10n;
    final name = controller.child?.name ?? '';
    const gap = SizedBox(height: AppSpacing.cardInset);
    return BaseScaffold(
      appBar: const AppTopBar(),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            AppSpacing.s6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        Assets.images.pv5ec.path,
                        width: 120,
                        height: 120,
                        excludeFromSemantics: true,
                      ),
                      gap,
                      Text(
                        l10n.pregArchiveTitle(name),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.h2.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      gap,
                      Text(
                        l10n.pregnancyArchiveIntro,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.text14.copyWith(
                            height: 1.5,
                            color: kColorTextSecondary6B625B,
                          ),
                        ),
                      ),
                      gap,
                      _ArchiveOptionCard(
                        title: l10n.pregnancyPause,
                        description: l10n.pregnancyPauseHint,
                        selected: !controller.ended,
                        onTap: () => controller.choose(ended: false),
                      ),
                      gap,
                      _ArchiveOptionCard(
                        title: l10n.pregnancyEnd,
                        description: l10n.pregnancyEndHint,
                        selected: controller.ended,
                        onTap: () => controller.choose(ended: true),
                      ),
                      gap,
                      Container(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.cardInset,
                          1,
                          AppSpacing.s2,
                          1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.resolve(
                            context,
                            kColorSurfaceVariantF7F1EC,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.pregnancyParentsOnly,
                                style: AppTypography.adapt(
                                  context,
                                  AppTypography.caption.copyWith(
                                    color: kColorTextPrimary2E2A27,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.itemGap),
                            _MutedSwitch(
                              value: controller.parentsOnly,
                              onChanged: controller.toggleParentsOnly,
                            ),
                          ],
                        ),
                      ),
                      gap,
                      Row(
                        children: [
                          Icon(
                            LucideIcons.handHeart,
                            size: 14,
                            color: AppColors.resolve(
                              context,
                              kColorUs7006A549F,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.compact),
                          Flexible(
                            child: Text(
                              l10n.pregnancySupport,
                              style: AppTypography.adapt(
                                context,
                                AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kColorUs7006A549F,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      gap,
                    ],
                  ),
                ),
              ),
              AppButton.secondary(
                label: l10n.pregMenuArchive,
                color: kColorTextPrimary2E2A27,
                borderColor: kColorTextSecondary6B625B,
                isLoading: controller.isLoading,
                onPressed: () async {
                  final router = context.router;
                  await controller.confirm();
                  await router.replaceAll([
                    const MainShellRoute(children: [HomeTabRoute()]),
                  ]);
                },
              ),
              gap,
              Text(
                l10n.pregnancyArchivePrivacy,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
