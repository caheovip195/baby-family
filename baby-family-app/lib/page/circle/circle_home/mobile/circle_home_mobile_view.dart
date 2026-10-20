import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/page/circle/circle_home/circle_home_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/relative_time.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/circle_big_action.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/hero_card.dart';
part '../widgets/kid_chip.dart';
part '../widgets/voice_tip.dart';
part '../widgets/wish_sheet.dart';

/// CIR-01 — Cháu yêu (Pencil `zO5Oq`, tối `q0LOcN`). Chữ lớn cho ông bà:
/// chữ ≥ 17, nút 64.
class CircleHomeMobileView extends HookConsumerWidget {
  const CircleHomeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(circleHomeControllerProvider);
    final l10n = context.l10n;
    final moved = controller.sessionMoved;
    useEffect(() {
      if (moved) {
        // CIR-05 / đã rời gia đình: sang màn đúng trạng thái phiên.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.router.replaceAll([routeForSession(controller.session)]);
          }
        });
      }
      return null;
    }, [moved]);
    final view = controller.view;
    final child = controller.selectedChild;
    final hero = controller.hero;
    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (view == null) {
      body = const SizedBox.shrink();
    } else {
      final viewer = view.viewer;
      final who = switch (viewer.relation) {
        RelativeRelation.grandmaPaternal ||
        RelativeRelation.grandmaMaternal => 'grandma',
        RelativeRelation.grandpaPaternal ||
        RelativeRelation.grandpaMaternal => 'grandpa',
        _ => 'other',
      };
      final photos = controller.weekPhotos;

      Future<void> like() async {
        if (child == null) {
          return;
        }
        await controller.like();
        if (context.mounted) {
          showAppSnackBar(context, l10n.cirLiked(child.name));
        }
      }

      Future<void> wish() async {
        if (child == null) {
          return;
        }
        final sent = await showAppBottomSheet<bool>(
          context,
          builder: (_) =>
              _WishSheet(childName: child.name, onSend: controller.sendWish),
        );
        if (sent == true && context.mounted) {
          showAppSnackBar(context, l10n.cirWishSent(child.name));
        }
      }

      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s2,
          AppSpacing.screen,
          AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.cirHello(viewer.callName),
            style: AppTypography.adapt(
              context,
              AppTypography.h3.copyWith(
                fontFamily: AppTypography.bodyFamily,
                fontWeight: FontWeight.w400,
                color: kColorTextSecondary6B625B,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            l10n.cirTitle(who),
            style: AppTypography.adapt(
              context,
              AppTypography.display.copyWith(fontSize: 30, height: 38 / 30),
            ),
          ),
          if (view.children.length > 1) ...[
            const SizedBox(height: AppSpacing.s5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final (index, kid) in view.children.indexed) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.s2),
                    _KidChip(
                      child: kid,
                      selected: kid.id == child?.id,
                      onTap: () => controller.selectChild(kid.id),
                    ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s5),
          if (hero == null || child == null)
            EmptyState(title: l10n.cirEmpty(viewer.callName))
          else ...[
            _HeroCard(
              child: child,
              memory: hero,
              author: controller.authorName(hero.authorId),
              today: controller.now,
              onTap: () => context.router.push(
                CircleMemoryDetailRoute(memoryId: hero.id),
              ),
            ),
            const SizedBox(height: AppSpacing.s5),
            Row(
              children: [
                Expanded(
                  child: CircleBigAction(
                    icon: LucideIcons.heart,
                    label: l10n.circleLike,
                    color: kColorPrimary50FFF4F1,
                    foreground: kColorPrimary700A2402F,
                    filled: controller.heroLiked,
                    onTap: like,
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: CircleBigAction(
                    icon: LucideIcons.messageCircle,
                    label: l10n.circleSendWish,
                    color: kColorSecondary100E4F2EA,
                    foreground: kColorSecondary7003F7A5C,
                    onTap: wish,
                    onLongPress: () => showComingSoonSnackBar(context),
                  ),
                ),
              ],
            ),
            if (photos.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s5),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.circleNewPhotos,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title20,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => AutoTabsRouter.of(
                      context,
                    ).setActiveIndex(CircleTab.memories.index),
                    child: Text(
                      l10n.commonSeeAll,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.body.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kColorPrimary700A2402F,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s3),
              Row(
                children: [
                  for (var index = 0; index < 3; index++) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.itemGap),
                    Expanded(
                      child: index < photos.length
                          ? GestureDetector(
                              onTap: () => context.router.push(
                                CircleMemoryDetailRoute(
                                  memoryId: photos[index].$1.id,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.lg,
                                ),
                                child: Image(
                                  image: mediaImageProvider(photos[index].$2),
                                  height: 108,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.s5),
            _VoiceTip(text: l10n.circleVoiceTip),
          ],
        ],
      );
    }
    return BaseScaffold(
      isLoading: controller.isLoading && view == null,
      body: SafeArea(bottom: false, child: body),
    );
  }
}
