import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/on_this_day_group.dart';
import 'package:baby_family/page/parent/on_this_day/on_this_day_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_back_title_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/past_memory_card.dart';
part '../widgets/past_quote_card.dart';
part '../widgets/reshare_button.dart';
part '../widgets/today_header.dart';

/// MEM-16 Ngày này năm xưa (Pencil `Ysvtl`).
class OnThisDayMobileView extends HookConsumerWidget {
  const OnThisDayMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onThisDayControllerProvider);
    final l10n = context.l10n;
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else if (controller.groups.isEmpty) {
      body = EmptyState(title: l10n.memOnThisDayEmpty);
    } else {
      final today = controller.today;
      final items = <Widget>[
        _TodayHeader(
          month: l10n.memOnThisDayMonthShort(today.month),
          day: DateFormat('dd', l10n.localeName).format(today),
          title: l10n.memOnThisDayHeader(today.day, today.month),
          subtitle: l10n.memOnThisDaySummary(
            controller.groups.length,
            controller.memoryCount,
          ),
        ),
        for (final group in controller.groups)
          _group(context, controller, group),
        Text(
          l10n.memOnThisDayFooter,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(context, AppTypography.tiny),
        ),
      ];
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s1,
          AppSpacing.screen,
          28 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.sectionGap),
            items[index],
          ],
        ],
      );
    }
    return BaseScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBackTitleBar(
            title: l10n.memOnThisDayTitle,
            trailing: Semantics(
              button: true,
              label: l10n.settingsNotifications,
              excludeSemantics: true,
              child: InkResponse(
                onTap: () =>
                    context.router.push(const NotificationSettingsRoute()),
                radius: 24,
                child: SizedBox.square(
                  dimension: 40,
                  child: Icon(
                    LucideIcons.settings2,
                    size: 20,
                    color: AppColors.resolve(
                      context,
                      kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _group(
    BuildContext context,
    OnThisDayController controller,
    OnThisDayGroup group,
  ) {
    final l10n = context.l10n;
    final child = controller.childById(group.childId);
    final birth = child?.birthDate;
    final age = birth == null ? '' : childAgeShortText(l10n, birth, group.date);
    final date = group.date.toFormDate(l10n.localeName);
    final items = <Widget>[
      Row(
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 28),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorPrimary600C2513F),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              l10n.memOnThisDayYearsAgo(group.yearsAgo),
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
                height: 16 / 13,
                color: AppColors.onPrimary(context),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Text(
              child == null
                  ? date
                  : l10n.memOnThisDayYearMeta(date, child.name, age),
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 16 / 13,
                ),
              ),
            ),
          ),
        ],
      ),
      for (final memory in group.memories)
        if (memory.kind == MemoryKind.quote)
          _PastQuoteCard(
            quote: l10n.commonQuoted(memory.body ?? ''),
            meta: l10n.memQuoteOfChild(child?.name ?? '', age),
            onTap: () => _open(context, memory),
          )
        else
          _PastMemoryCard(
            memory: memory,
            meta: _meta(context, controller, memory),
            onTap: () => _open(context, memory),
          ),
      _ReshareButton(
        onTap: () => context.router.push(
          MemoryComposerRoute(
            kind: MemoryKind.photo.name,
            childId: group.childId,
          ),
        ),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.itemGap),
          items[index],
        ],
      ],
    );
  }

  /// “Papa kể · ⭐ Bước đi đầu tiên” • “Mama kể · ⭐ Lẫy · 4 ảnh”.
  String _meta(
    BuildContext context,
    OnThisDayController controller,
    Memory memory,
  ) {
    final l10n = context.l10n;
    var text = l10n.memAuthorTells(
      controller.memberByUser(memory.authorId)?.callName ?? '',
    );
    if (memory.milestoneTitle case final title?) {
      text = l10n.memDotMeta2(text, l10n.memOnThisDayMilestone(title));
    }
    if (memory.mediaAssets.length > 1) {
      text = l10n.memDotMeta2(
        text,
        l10n.memOnThisDayPhotos(memory.mediaAssets.length),
      );
    }
    return text;
  }

  void _open(BuildContext context, Memory memory) =>
      context.router.push(MemoryDetailRoute(memoryId: memory.id));
}
