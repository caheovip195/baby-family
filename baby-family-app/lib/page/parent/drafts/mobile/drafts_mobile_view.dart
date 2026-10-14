import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/memory/memory_draft_item.dart';
import 'package:baby_family/page/parent/drafts/drafts_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/memory_list_skeleton.dart';
import 'package:baby_family/utils/widget/memory_thumb.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/draft_card.dart';
part '../widgets/draft_section_label.dart';

/// MEM-18 — Nháp (Pencil `ACNFh`).
class DraftsMobileView extends HookConsumerWidget {
  const DraftsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(draftsControllerProvider);
    final l10n = context.l10n;
    final drafts = controller.drafts;

    Future<void> delete(MemoryDraftItem draft) async {
      await controller.delete(draft);
      if (context.mounted) {
        showAppSnackBar(context, l10n.memDraftDeleted);
      }
    }

    void resume(MemoryDraftItem draft) {
      final childId = draft.childIds.firstOrNull;
      context.router.push(switch (draft.kind) {
        MemoryKind.letter => LetterComposerRoute(childId: childId),
        MemoryKind.diary => DiaryEditorRoute(childId: childId),
        final kind => MemoryComposerRoute(kind: kind.name, childId: childId),
      });
    }

    Widget card(MemoryDraftItem draft) => _DraftCard(
      draft: draft,
      meta: _meta(context, controller, draft),
      onResume: () => resume(draft),
      onDelete: () => delete(draft),
    );

    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (drafts == null) {
      body = const Padding(
        padding: EdgeInsets.all(AppSpacing.screen),
        child: MemoryListSkeleton(),
      );
    } else {
      const gap = SizedBox(height: AppSpacing.itemGap);
      final note = AppTypography.adapt(
        context,
        AppTypography.small.copyWith(
          height: 15 / 12,
          color: kColorTextTertiary9C928A,
        ),
      );
      final device = controller.onDevice;
      final cloud = controller.inCloud;
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.memDraftsTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            l10n.memDraftsSubtitle,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                height: 19 / 13,
                color: kColorTextSecondary6B625B,
              ),
            ),
          ),
          if (drafts.isEmpty) ...[
            const SizedBox(height: AppSpacing.s8),
            EmptyState(
              title: l10n.memDraftsEmpty,
              description: l10n.memDraftsEmptyHint,
            ),
          ],
          if (device.isNotEmpty) ...[
            gap,
            _DraftSectionLabel(
              icon: LucideIcons.smartphone,
              label: l10n.memDraftsDevice,
            ),
            for (final draft in device) ...[gap, card(draft)],
            gap,
            Row(
              children: [
                Icon(
                  LucideIcons.cloudOff,
                  size: 14,
                  color: AppColors.resolve(context, kColorTextTertiary9C928A),
                ),
                const SizedBox(width: AppSpacing.s2),
                Expanded(child: Text(l10n.memDraftsLocalNote, style: note)),
              ],
            ),
          ],
          if (cloud.isNotEmpty) ...[
            gap,
            _DraftSectionLabel(
              icon: LucideIcons.cloud,
              label: l10n.memDraftsCloud,
            ),
            for (final draft in cloud) ...[gap, card(draft)],
          ],
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }

  /// “Khoảnh khắc · Haru · Sửa lúc 21:40 hôm qua” •
  /// “Thư gửi con · Haru · Lưu 06/10, 22:15 trên iPad”.
  static String _meta(
    BuildContext context,
    DraftsController controller,
    MemoryDraftItem draft,
  ) {
    final l10n = context.l10n;
    final locale = l10n.localeName;
    final at = draft.updatedAt;
    final time = at.toDisplayTime(locale);
    final date = at.toDayMonth(locale);
    final today = controller.today;
    final duration = draft.voiceDurationSec;
    final String when;
    if (draft.location == DraftLocation.cloud) {
      final device = draft.deviceName;
      when = device == null
          ? l10n.memDraftSavedOn(date, time)
          : l10n.memDraftSavedOnDevice(date, time, device);
    } else if (at.isSameDay(today)) {
      when = l10n.memDraftEditedToday(time);
    } else if (at.isSameDay(today.subtract(const Duration(days: 1)))) {
      when = l10n.memDraftEditedYesterday(time);
    } else {
      when = l10n.memDraftEditedOn(date, time);
    }
    final names = controller.childNames(draft);
    return [
      if (draft.kind == MemoryKind.voice && duration != null)
        l10n.memKindVoiceDuration(memoryDuration(duration))
      else
        memoryKindLabel(l10n, draft.kind),
      if (names.isNotEmpty) names,
      when,
    ].reduce(l10n.commonDotJoin);
  }
}
