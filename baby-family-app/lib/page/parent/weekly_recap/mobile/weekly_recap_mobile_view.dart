import 'dart:io';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/weekly_recap.dart';
import 'package:baby_family/page/parent/weekly_recap/weekly_recap_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/application_directory.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/recap_actions.dart';
import 'package:baby_family/utils/widget/recap_next_hint.dart';
import 'package:baby_family/utils/widget/recap_stat_card.dart';
import 'package:baby_family/utils/widget/recap_story_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:share_plus/share_plus.dart';

part '../widgets/recap_collage.dart';
part '../widgets/recap_highlight_row.dart';

/// REC-02 Tuần của nhà mình (Pencil `z2YZ8A`): trang 1/6 của bản tổng kết
/// dạng story, nền chuyển `primary-100` → `bg`.
class WeeklyRecapMobileView extends HookConsumerWidget {
  const WeeklyRecapMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(weeklyRecapControllerProvider);
    final l10n = context.l10n;
    final recap = controller.recap;
    final summaryKey = useMemoized(GlobalKey.new);
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else if (recap == null) {
      body = EmptyState(title: l10n.recapWeekTitle);
    } else {
      body = _content(context, controller, recap, summaryKey);
    }
    return Scaffold(
      backgroundColor: AppColors.resolve(context, kColorBgFFFBF7),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0, .45],
            colors: [
              AppColors.resolve(context, kColorPrimary100FFE3DC),
              AppColors.resolve(context, kColorBgFFFBF7),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RecapStoryHeader(
                title: l10n.recapWeekTitle,
                pages: recap?.pageCount ?? 1,
                subtitle: recap == null
                    ? null
                    : l10n.recapWeekRange(
                        recap.start.toRangeLabel(recap.end, l10n.localeName),
                        l10n.memoriesFamily,
                      ),
              ),
              Expanded(child: body),
              if (recap != null) _nextHint(context, recap),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    WeeklyRecapController controller,
    WeeklyRecap recap,
    GlobalKey summaryKey,
  ) {
    final l10n = context.l10n;
    final summary = <Widget>[
      if (recap.heroAssets.isNotEmpty) _RecapCollage(assets: recap.heroAssets),
      Text(
        recap.headline,
        style: AppTypography.adapt(
          context,
          AppTypography.h3.copyWith(
            fontWeight: FontWeight.w800,
            height: 25 / 18,
          ),
        ),
      ),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: RecapStatCard(
                icon: LucideIcons.camera,
                background: kColorPrimary50FFF4F1,
                foreground: kColorPrimary600C2513F,
                value: recap.moments,
                label: l10n.homeMomentLabel,
              ),
            ),
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: RecapStatCard(
                icon: LucideIcons.star,
                background: kColorAccent100FDF1D6,
                foreground: kColorAccent600B7862B,
                value: recap.firsts,
                label: l10n.commonFirsts,
              ),
            ),
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: RecapStatCard(
                icon: LucideIcons.quote,
                background: kColorSecondary100E4F2EA,
                foreground: kColorSecondary7003F7A5C,
                value: recap.quotes,
                label: l10n.homeQuoteLabel,
              ),
            ),
          ],
        ),
      ),
    ];
    final items = <Widget>[
      // “Tải ảnh tổng kết” chụp đúng phần này (ảnh ghép + số liệu).
      RepaintBoundary(
        key: summaryKey,
        child: ColoredBox(
          color: AppColors.resolve(context, kColorBgFFFBF7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s4,
            children: summary,
          ),
        ),
      ),
      if (recap.highlights.isNotEmpty)
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardInset,
            vertical: AppSpacing.s1,
          ),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.resolve(context, kColorBorderEADFD6),
            ),
          ),
          child: Column(
            children: [
              for (var index = 0; index < recap.highlights.length; index++)
                _highlight(
                  context,
                  controller,
                  recap.highlights[index],
                  last: index == recap.highlights.length - 1,
                ),
            ],
          ),
        ),
      if (recap.togetherTitle != null) _together(context, recap),
      if (!controller.readOnly)
        RecapActions(
          shared: recap.shared,
          onShare: () => _share(context, controller, recap),
          onSave: () => _save(context, controller),
          onDownload: () => _download(context, summaryKey, recap),
        ),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s4,
        AppSpacing.screen,
        28,
      ),
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.s4),
          items[index],
        ],
      ],
    );
  }

  /// Gói chưa có Family Circle → SUB-01; có → bật/tắt chia sẻ.
  Future<void> _share(
    BuildContext context,
    WeeklyRecapController controller,
    WeeklyRecap recap,
  ) async {
    final l10n = context.l10n;
    if (!recap.shared && !recap.canShare && recap.id != null) {
      await context.router.push(const UpgradePlanRoute());
      return;
    }
    var shared = recap.shared;
    final done = await runWithErrorSnackBar(context, () async {
      shared = await controller.toggleShare();
    });
    if (done && context.mounted) {
      showAppSnackBar(context, shared ? l10n.recapShared : l10n.recapUnshared);
    }
  }

  Future<void> _save(
    BuildContext context,
    WeeklyRecapController controller,
  ) async {
    final l10n = context.l10n;
    final done = await runWithErrorSnackBar(context, controller.saveToTimeline);
    if (done && context.mounted) {
      showAppSnackBar(context, l10n.recapSaved);
    }
  }

  /// Ảnh tổng kết dựng trên máy (PNG) rồi mở bảng chia sẻ / lưu của hệ thống.
  Future<void> _download(
    BuildContext context,
    GlobalKey summaryKey,
    WeeklyRecap recap,
  ) async {
    await runWithErrorSnackBar(context, () async {
      final boundary =
          summaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        return;
      }
      final image = await boundary.toImage(pixelRatio: 3);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (bytes == null) {
        return;
      }
      final file = File(
        '${ApplicationDirectory().tempApplicationFolder.path}/'
        'week-${recap.start.toIso8601String().substring(0, 10)}.png',
      );
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path, mimeType: 'image/png')]),
      );
    });
  }

  Widget _highlight(
    BuildContext context,
    WeeklyRecapController controller,
    Memory memory, {
    required bool last,
  }) {
    final l10n = context.l10n;
    final child = controller.childById(memory.childIds.firstOrNull);
    final quote = memory.kind == MemoryKind.quote;
    final birth = child?.birthDate;
    return _RecapHighlightRow(
      title: quote ? l10n.commonQuoted(memory.body ?? '') : memory.title ?? '',
      meta: quote
          ? l10n.recapQuoteMeta(
              child?.name ?? '',
              birth == null ? '' : childAgeText(l10n, birth, controller.today),
            )
          : l10n.memDotMeta3(
              child?.name ?? '',
              memory.occurredAt.toDayMonth(l10n.localeName),
              l10n.memAuthorTells(
                controller.memberByUser(memory.authorId)?.callName ?? '',
              ),
            ),
      asset: memory.mediaAssets.firstOrNull,
      badge: memory.kind == MemoryKind.milestone ? l10n.memoriesFirsts : null,
      last: last,
      onTap: () => context.router.push(MemoryDetailRoute(memoryId: memory.id)),
    );
  }

  Widget _together(BuildContext context, WeeklyRecap recap) {
    final secondary = AppColors.resolve(context, kColorSecondary7003F7A5C);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardInset,
        vertical: AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSecondary100E4F2EA),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.trees, size: 22, color: secondary),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recap.togetherTitle!,
                  style: AppTypography.text14.copyWith(
                    fontWeight: FontWeight.w700,
                    color: secondary,
                  ),
                ),
                if (recap.togetherBody != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    recap.togetherBody!,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        height: 1.4,
                        color: kColorTextPrimary2E2A27,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Gợi ý trang sau (`HkNUa`): “1 / 6” + “Ảnh nổi bật ›”.
  Widget _nextHint(BuildContext context, WeeklyRecap recap) {
    final first = recap.highlights
        .where((memory) => memory.mediaAssets.isNotEmpty)
        .firstOrNull;
    return RecapNextHint(
      pageCount: recap.pageCount,
      label: context.l10n.recapNextHighlights,
      onTap: first == null
          ? null
          : () => context.router.push(PhotoViewerRoute(memoryId: first.id)),
    );
  }
}
