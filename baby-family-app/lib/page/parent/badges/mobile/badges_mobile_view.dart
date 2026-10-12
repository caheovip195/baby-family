import 'package:baby_family/data/model/care/family_badge.dart';
import 'package:baby_family/page/parent/badges/badges_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/lucide_icon.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_progress_bar.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/badge_tile.dart';
part '../widgets/badges_summary.dart';

/// Cặp màu nền/icon của huy hiệu đã đạt (Pencil: `us`, `accent`, `primary`,
/// `secondary` lần lượt).
const _earnedPalette = [
  (kColorUs100EAE2F8, kColorUs7006A549F),
  (kColorAccent100FDF1D6, kColorAccent7009A6A12),
  (kColorPrimary100FFE3DC, kColorPrimary600C2513F),
  (kColorSecondary100E4F2EA, kColorSecondary7003F7A5C),
];

/// CARE-10 “Huy hiệu của nhà mình” (Pencil `sCdEt`).
class BadgesMobileView extends HookConsumerWidget {
  const BadgesMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(badgesControllerProvider);
    final l10n = context.l10n;

    String detail(FamilyBadge badge) {
      if (!badge.achieved) {
        return badge.hint ?? '';
      }
      final date = l10n.careBadgeAchievedOn(
        badge.achievedAt!.toFormDate(l10n.localeName),
      );
      final child = controller.childName(badge.childId);
      return child == null ? date : l10n.commonDotJoin(date, child);
    }

    void open(FamilyBadge badge) => showAppBottomSheet<void>(
      context,
      builder: (_) => AppBottomSheet(
        children: [
          Center(child: _BadgeTile.icon(context, badge, controller)),
          Text(
            badge.title,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(context, AppTypography.h3),
          ),
          Text(
            detail(badge),
            textAlign: TextAlign.center,
            style: AppTypography.adapt(context, AppTypography.caption),
          ),
        ],
      ),
    );

    List<Widget> grid(List<FamilyBadge> badges) => [
      for (var start = 0; start < badges.length; start += 2) ...[
        if (start > 0) const SizedBox(height: AppSpacing.itemGap),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = start; i < start + 2; i++) ...[
                if (i > start) const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: i < badges.length
                      ? _BadgeTile(
                          badge: badges[i],
                          detail: detail(badges[i]),
                          controller: controller,
                          onTap: () => open(badges[i]),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      ],
    ];

    Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else {
      final latest = controller.latest;
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          28 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.careBadgesTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            l10n.careBadgesSubtitle,
            style: AppTypography.adapt(context, AppTypography.caption),
          ),
          const SizedBox(height: AppSpacing.s4),
          _BadgesSummary(
            done: controller.earned.length,
            total: controller.badges.length,
            latest: latest == null
                ? null
                : l10n.careBadgesLatest(
                    latest.title,
                    latest.achievedAt!.toFormDate(l10n.localeName),
                  ),
          ),
          if (controller.earned.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s4),
            AppCapsLabel(l10n.careBadgesEarned),
            const SizedBox(height: AppSpacing.s4),
            ...grid(controller.earned),
          ],
          if (controller.upcoming.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s4),
            AppCapsLabel(l10n.careBadgesUpcoming),
            const SizedBox(height: AppSpacing.s4),
            ...grid(controller.upcoming),
          ],
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
