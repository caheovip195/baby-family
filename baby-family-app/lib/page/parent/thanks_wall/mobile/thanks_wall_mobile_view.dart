import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/us/thanks.dart';
import 'package:baby_family/page/parent/thanks_wall/thanks_wall_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/lucide_icon.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_extended_fab.dart';
import 'package:baby_family/utils/widget/app_selectable_chip.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/thanks_legend.dart';
part '../widgets/thanks_note_card.dart';

/// Nền giấy note theo người gửi (US-06 `#FFE9B8` của tôi / `#D9EEDF` của bạn
/// đời); chế độ tối dùng `accent-100` / `secondary-100` tối.
Color _noteColor(BuildContext context, {required bool mine}) {
  if (AppColors.isDark(context)) {
    return mine ? kColorDarkAccent10033291A : kColorDarkSecondary1001C2B23;
  }
  return mine ? kColorNoteYellowFFE9B8 : kColorNoteGreenD9EEDF;
}

/// US-06 “Bức tường cảm ơn” (Pencil `ihnhh`).
class ThanksWallMobileView extends HookConsumerWidget {
  const ThanksWallMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(thanksWallControllerProvider);
    final l10n = context.l10n;
    final usDark = AppColors.resolve(context, kColorUs7006A549F);

    // Bức tường xếp theo cột như thiết kế: nửa đầu (theo thứ tự bức tường)
    // ở cột trái, phần còn lại ở cột phải (lệch xuống 18).
    Widget wall() {
      final items = controller.thanks;
      final split = items.length ~/ 2;
      Widget column(Iterable<Thanks> notes) => Column(
        children: [
          for (final (index, note) in notes.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.itemGap),
            _ThanksNoteCard(item: note, controller: controller),
          ],
        ],
      );
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: column(items.take(split))),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: column(items.skip(split)),
            ),
          ),
        ],
      );
    }

    Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else {
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          92 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.usThanksWall,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.compact),
          Row(
            children: [
              Icon(LucideIcons.lock, size: 14, color: usDark),
              const SizedBox(width: AppSpacing.compact),
              Flexible(
                child: Text(
                  l10n.usOnlyTwo,
                  style: AppTypography.small.copyWith(
                    fontWeight: FontWeight.w600,
                    color: usDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.cardInset),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final month in [...controller.months, null]) ...[
                  if (month != controller.months.first)
                    const SizedBox(width: AppSpacing.s2),
                  AppSelectableChip(
                    label: month == null
                        ? l10n.usThanksAll
                        : l10n.usThanksMonth('${month.month}'),
                    height: 34,
                    outlined: true,
                    selected: controller.month == month,
                    onPressed: () => controller.selectMonth(month),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          _ThanksLegend(
            partnerCallName: controller.partner?.callName ?? '',
            count: controller.thanks.length,
          ),
          const SizedBox(height: AppSpacing.cardInset),
          if (controller.thanks.isEmpty)
            EmptyState(title: l10n.usThanksWallEmpty, illustrationSize: 140)
          else
            wall(),
        ],
      );
    }
    return BaseScaffold(
      backgroundColor: kColorUs50F6F2FC,
      appBar: const AppTopBar(backgroundColor: kColorUs50F6F2FC),
      body: Stack(
        children: [
          Positioned.fill(child: body),
          Positioned(
            right: AppSpacing.screen,
            bottom: AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
            child: AppExtendedFab(
              label: l10n.usThanksSendCta,
              icon: LucideIcons.heartHandshake,
              onTap: () => context.router.push(ThanksComposeRoute()),
            ),
          ),
        ],
      ),
    );
  }
}
