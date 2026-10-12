import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/photo_viewer/photo_viewer_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/extension/string.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/viewer_action.dart';
part '../widgets/viewer_dots.dart';
part '../widgets/viewer_photo.dart';

/// Kéo xuống quá ngưỡng này (hoặc vuốt nhanh) thì đóng MEM-08.
const _dismissDistance = 120.0;
const _dismissVelocity = 800.0;

/// MEM-08 Xem ảnh toàn màn hình (Pencil `J8ZEtR`): nền đen, vuốt ngang chuyển
/// ảnh, pinch zoom, vuốt xuống để đóng.
class PhotoViewerMobileView extends HookConsumerWidget {
  const PhotoViewerMobileView({required this.memoryId, this.index, super.key});

  final String memoryId;
  final int? index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(photoViewerControllerProvider(memoryId));
    final drag = useState(0.0);
    final zoomed = useState(false);
    final started = useRef(false);
    if (controller.loaded && !started.value) {
      started.value = true;
      controller.setInitialPage(index);
    }
    final pageController = useMemoized(
      () => PageController(initialPage: controller.page),
      [controller.loaded],
    );
    useEffect(() => pageController.dispose, [pageController]);
    final l10n = context.l10n;
    final memory = controller.memory;
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError || memory == null) {
      body = ErrorState(onRetry: controller.load);
    } else {
      final assets = controller.assets;
      final names = controller.memoryChildren.map((child) => child.name);
      final kids = names.length == 2
          ? l10n.memNamesPair(names.first, names.last)
          : names.join(', ');
      final author = controller.author;
      final caption = memory.body?.firstSentence ?? memory.title;
      final progress = (drag.value / (_dismissDistance * 3)).clamp(0.0, 1.0);
      body = Column(
        children: [
          _topBar(context, controller),
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: zoomed.value
                  ? null
                  : (details) => drag.value = (drag.value + details.delta.dy)
                        .clamp(0.0, double.infinity),
              onVerticalDragEnd: zoomed.value
                  ? null
                  : (details) {
                      if (drag.value > _dismissDistance ||
                          (details.primaryVelocity ?? 0) > _dismissVelocity) {
                        context.router.maybePop();
                      } else {
                        drag.value = 0;
                      }
                    },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Transform.translate(
                      offset: Offset(0, drag.value),
                      child: Opacity(
                        opacity: 1 - progress * .6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: AspectRatio(
                                aspectRatio: 390 / 480,
                                child: PageView.builder(
                                  controller: pageController,
                                  physics: zoomed.value
                                      ? const NeverScrollableScrollPhysics()
                                      : null,
                                  itemCount: assets.length,
                                  onPageChanged: controller.setPage,
                                  itemBuilder: (_, page) => _ViewerPhoto(
                                    asset: assets[page],
                                    onZoomChanged: (value) =>
                                        zoomed.value = value,
                                  ),
                                ),
                              ),
                            ),
                            if (assets.length > 1) ...[
                              const SizedBox(height: AppSpacing.s4),
                              _ViewerDots(
                                count: assets.length,
                                index: controller.page,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.s2,
                    left: 0,
                    right: 0,
                    child: Center(child: _swipeHint(context)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              AppSpacing.s3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (caption != null)
                  Text(
                    caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.text14.copyWith(
                      height: 1.4,
                      color: kColorWhite,
                    ),
                  ),
                const SizedBox(height: AppSpacing.s1),
                Text(
                  l10n.memDotMeta3(
                    kids,
                    memory.occurredAt.toFormDate(l10n.localeName),
                    l10n.memAuthorTells(author?.callName ?? ''),
                  ),
                  style: AppTypography.small.copyWith(
                    color: kColorWhiteAlpha65,
                  ),
                ),
              ],
            ),
          ),
          _actionBar(context, controller),
        ],
      );
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: kColorBlack,
        body: SafeArea(bottom: false, child: body),
      ),
    );
  }

  Widget _topBar(BuildContext context, PhotoViewerController controller) {
    final count = controller.assets.length;
    return SizedBox(
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        child: Row(
          children: [
            Semantics(
              button: true,
              label: context.l10n.commonClose,
              excludeSemantics: true,
              child: InkResponse(
                onTap: () => context.router.maybePop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: kColorWhiteAlpha12,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.x,
                    size: 22,
                    color: kColorWhite,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                count == 0 ? '' : '${controller.page + 1} / $count',
                textAlign: TextAlign.center,
                style: AppTypography.label.copyWith(
                  height: 19 / 15,
                  color: kColorWhite,
                ),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  Widget _swipeHint(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.s3,
      vertical: AppSpacing.s1,
    ),
    decoration: BoxDecoration(
      color: kColorWhiteAlpha12,
      borderRadius: BorderRadius.circular(AppRadius.full),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          LucideIcons.chevronDown,
          size: 14,
          color: kColorWhiteAlpha80,
        ),
        const SizedBox(width: AppSpacing.compact),
        Text(
          context.l10n.memViewerSwipeHint,
          style: AppTypography.tiny.copyWith(color: kColorWhiteAlpha80),
        ),
      ],
    ),
  );

  Widget _actionBar(BuildContext context, PhotoViewerController controller) {
    final l10n = context.l10n;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final favorite = controller.memory?.isFavorite ?? false;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s8,
        AppSpacing.s3,
        AppSpacing.s8,
        bottom > 0 ? bottom : 34,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: kColorWhiteAlpha12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ViewerAction(
            icon: LucideIcons.download,
            label: l10n.memViewerDownload,
            onTap: () => showAppSnackBar(context, l10n.memViewerDownloaded),
          ),
          _ViewerAction(
            icon: LucideIcons.share2,
            label: l10n.memViewerShare,
            onTap: controller.share,
          ),
          _ViewerAction(
            icon: LucideIcons.heart,
            filled: favorite,
            label: l10n.memMenuFavorite,
            onTap: controller.toggleFavorite,
          ),
          _ViewerAction(
            icon: LucideIcons.info,
            label: l10n.memViewerInfo,
            onTap: () => _openInfo(context, controller),
          ),
        ],
      ),
    );
  }

  Future<void> _openInfo(
    BuildContext context,
    PhotoViewerController controller,
  ) {
    final memory = controller.memory;
    if (memory == null) {
      return Future.value();
    }
    final l10n = context.l10n;
    final author = controller.author;
    return showAppBottomSheet<void>(
      context,
      builder: (sheetContext) {
        Widget row(IconData icon, String text) => Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.resolve(sheetContext, kColorTextSecondary6B625B),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                text,
                style: AppTypography.adapt(sheetContext, AppTypography.body),
              ),
            ),
          ],
        );
        return AppBottomSheet(
          title: l10n.memViewerInfo,
          gap: AppSpacing.s3,
          children: [
            row(
              LucideIcons.calendar,
              memoryDayTime(
                l10n,
                memory.occurredAt,
                controller.childService.today,
              ),
            ),
            if (author != null) row(LucideIcons.user, memberFullName(author)),
            row(
              LucideIcons.baby,
              controller.memoryChildren.map((child) => child.name).join(', '),
            ),
            row(
              LucideIcons.users,
              memoryVisibilityLabel(l10n, memory.visibility),
            ),
          ],
        );
      },
    );
  }
}
