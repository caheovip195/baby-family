import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/month_recap.dart';
import 'package:baby_family/page/parent/month_recap/month_recap_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
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
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/month_first_row.dart';
part '../widgets/month_photo_pair.dart';
part '../widgets/month_voice_row.dart';

/// REC-03 — Tháng tuổi (Pencil `OtCDE`): trang 1/6 dạng story như REC-02
/// (nền chuyển `primary-100` → `bg`), ảnh tháng trước 120×150 cạnh ảnh tháng
/// này cao 200 viền trắng, 3 ô số liệu, danh sách lần đầu, khối câu nói &
/// giọng nói (`secondary-100`), hành động chia sẻ.
class MonthRecapMobileView extends HookConsumerWidget {
  const MonthRecapMobileView({this.childId, super.key});

  final String? childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(monthRecapControllerProvider(childId));
    final l10n = context.l10n;
    final recap = controller.recap;
    final name = controller.child?.name ?? '';
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else if (recap == null) {
      body = EmptyState(title: l10n.recapMonthTitle);
    } else {
      body = _content(context, controller, recap);
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
                title: recap == null
                    ? l10n.recapMonthTitle
                    : l10n.recapMonthHeadline(name, recap.monthIndex),
                pages: recap?.pageCount ?? 1,
                subtitle: recap == null
                    ? null
                    : l10n.recapMonthRange(
                        recap.monthIndex,
                        recap.start.toRangeLabel(recap.end, l10n.localeName),
                      ),
              ),
              Expanded(child: body),
              if (recap != null)
                RecapNextHint(
                  pageCount: recap.pageCount,
                  label: l10n.recapNextHighlights,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    MonthRecapController controller,
    MonthRecap recap,
  ) {
    final l10n = context.l10n;
    final child = controller.child;
    final birth = child?.birthDate;
    final locale = l10n.localeName;
    final items = <Widget>[
      _MonthPhotoPair(
        previousAsset: recap.previousPhotoAsset,
        currentAsset: recap.currentPhotoAsset,
        previousLabel: l10n.recapMonthLabel(recap.monthIndex - 1),
        currentLabel: l10n.recapMonthNow(recap.monthIndex),
        onOpen: child == null
            ? null
            : () => context.router.push(MonthlyPhotosRoute(childId: child.id)),
        onCapture: child == null
            ? null
            : () => context.router.push(
                MonthlyCameraRoute(childId: child.id, month: recap.monthIndex),
              ),
      ),
      if (recap.headline.isNotEmpty)
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
                icon: LucideIcons.mic,
                background: kColorSecondary100E4F2EA,
                foreground: kColorSecondary7003F7A5C,
                value: recap.voices,
                label: l10n.recapMonthVoices,
              ),
            ),
          ],
        ),
      ),
      if (recap.firstMemories.isNotEmpty)
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
              for (final (index, memory) in recap.firstMemories.indexed)
                _MonthFirstRow(
                  title: memory.title ?? '',
                  meta: l10n.recapMonthFirstMeta(
                    birth == null
                        ? ''
                        : childAgeText(l10n, birth, memory.occurredAt),
                    memory.occurredAt.toDayMonth(locale),
                  ),
                  asset: memory.mediaAssets.firstOrNull,
                  divider: index < recap.firstMemories.length - 1,
                ),
            ],
          ),
        ),
      if (recap.voiceMemories.isNotEmpty)
        _voices(context, controller, recap.voiceMemories),
      RecapActions(
        onShare: () => showAppSnackBar(context, l10n.recapShared),
        onSave: () => showAppSnackBar(context, l10n.recapSaved),
        onDownload: () => showAppSnackBar(context, l10n.memViewerDownloaded),
      ),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s4,
        AppSpacing.screen,
        AppSpacing.s5,
      ),
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.s4),
          items[index],
        ],
      ],
    );
  }

  /// “Câu nói & giọng nói” (`l4Ft68`): nền `secondary-100` bo 16, đệm 12/14,
  /// cách 10; nhãn 11/700 `secondary-700`.
  Widget _voices(
    BuildContext context,
    MonthRecapController controller,
    List<Memory> voices,
  ) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardInset,
        vertical: AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSecondary100E4F2EA),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.recapMonthVoicesKicker,
            style: AppTypography.tiny.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.resolve(context, kColorSecondary7003F7A5C),
            ),
          ),
          for (final memory in voices) ...[
            const SizedBox(height: AppSpacing.itemGap),
            _MonthVoiceRow(
              title: memory.title ?? memory.body ?? '',
              meta: l10n.recapMonthVoiceMeta(
                memory.occurredAt.toDayMonth(l10n.localeName),
                controller.memberByUser(memory.authorId)?.callName ?? '',
              ),
              duration: memoryDuration(memory.voiceDurationSec ?? 0),
            ),
          ],
        ],
      ),
    );
  }
}
