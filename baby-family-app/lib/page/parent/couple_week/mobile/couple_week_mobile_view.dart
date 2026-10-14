import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/us/couple_week.dart';
import 'package:baby_family/page/parent/couple_week/couple_week_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/app_week_selector.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/us_private_label.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/week_stat_tile.dart';
part '../widgets/week_thanks_card.dart';
part '../widgets/week_together_card.dart';

/// US-14 — Tuần của hai ta (Pencil `A7OdH4`): nền `us-50`, tiêu đề 26/800 +
/// khoá riêng tư, bộ chọn tuần, câu tóm tắt 18/800, lưới 2×2 số liệu, lời cảm
/// ơn nổi bật (`accent-100`), “Hai ta đã cùng nhau”, ghi chú “không điểm số”,
/// nút “Gửi một lời cảm ơn” (US-05).
class CoupleWeekMobileView extends HookConsumerWidget {
  const CoupleWeekMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(coupleWeekControllerProvider);
    final l10n = context.l10n;
    final week = controller.week;
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else if (week == null) {
      body = EmptyState(
        title: l10n.usWeekShort,
        actionLabel: l10n.usCoupleWeekSendThanks,
        onAction: () => context.router.push(ThanksComposeRoute()),
      );
    } else {
      body = _content(context, controller, week);
    }
    return BaseScaffold(
      backgroundColor: kColorUs50F6F2FC,
      appBar: const AppTopBar(backgroundColor: kColorUs50F6F2FC),
      body: body,
    );
  }

  Widget _content(
    BuildContext context,
    CoupleWeekController controller,
    CoupleWeek week,
  ) {
    final l10n = context.l10n;
    final locale = l10n.localeName;
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final highlightBy = controller.memberByUser(week.highlightByUserId);
    final highlightAt = week.highlightAt;
    String dayTitle(DateTime date) => l10n.calendarDayTitle(
      l10n.careWeekdayTitle(weekdayCode(date.weekday)),
      date.toDayMonth(locale),
    );

    Widget statRow(List<_WeekStatTile> tiles) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: tiles[0]),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(child: tiles[1]),
        ],
      ),
    );

    final items = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.usWeekShort,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.s1),
          UsPrivateLabel(l10n.usOnlyTwo),
        ],
      ),
      AppWeekSelector(
        label: l10n.commonWeekRange(
          '${week.start.toDayMonth(locale)} – ${week.end.toDayMonth(locale)}',
        ),
        previousColor: kColorUs7006A549F,
        nextColor: kColorTextTertiary9C928A,
      ),
      if (week.headline.isNotEmpty)
        Text(
          week.headline,
          style: AppTypography.adapt(
            context,
            AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      statRow([
        _WeekStatTile(
          icon: LucideIcons.smile,
          value: week.checkins,
          label: l10n.usCoupleWeekCheckins,
          hint: l10n.usCoupleWeekCheckinsSub,
        ),
        _WeekStatTile(
          icon: LucideIcons.handHelping,
          value: week.requestsHelped,
          label: l10n.usCoupleWeekRequests,
          hint: l10n.usCoupleWeekRequestsSub,
        ),
      ]),
      statRow([
        _WeekStatTile(
          icon: LucideIcons.heart,
          value: week.thanks,
          label: l10n.usCoupleWeekThanks,
          hint: l10n.usCoupleWeekThanksSub,
        ),
        _WeekStatTile(
          icon: LucideIcons.users,
          value: week.togetherMissions,
          label: l10n.usCoupleWeekTogether,
          hint: l10n.usCoupleWeekTogetherSub,
        ),
      ]),
      if (week.highlightThanks != null)
        _WeekThanksCard(
          quote: week.highlightThanks!,
          meta: l10n.usCoupleWeekThanksMeta(
            highlightBy?.callName ?? '',
            highlightAt == null ? '' : dayTitle(highlightAt),
          ),
        ),
      if (week.together.isNotEmpty)
        _WeekTogetherCard(
          rows: [
            for (final item in week.together) (item.title, dayTitle(item.date)),
          ],
        ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(LucideIcons.leaf, size: 14, color: usDark),
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Text(
              l10n.usCoupleWeekNote,
              style: AppTypography.small.copyWith(height: 1.4, color: usDark),
            ),
          ),
        ],
      ),
      AppButton.us(
        label: l10n.usCoupleWeekSendThanks,
        onPressed: () => context.router.push(ThanksComposeRoute()),
      ),
    ];
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.cardInset),
          items[index],
        ],
      ],
    );
  }
}
