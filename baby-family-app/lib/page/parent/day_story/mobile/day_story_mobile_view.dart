import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/memory/day_story.dart';
import 'package:baby_family/data/model/memory/day_story_item.dart';
import 'package:baby_family/page/parent/day_story/day_story_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/lucide_icon.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_text_action.dart';
import 'package:baby_family/utils/widget/app_text_input_sheet.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/memory_visibility_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/day_cover.dart';
part '../widgets/day_memory_row.dart';
part '../widgets/day_photo_tile.dart';
part '../widgets/day_story_card.dart';
part '../widgets/day_who_sees.dart';

/// REC-01 — Câu chuyện ngày (Pencil `kIqYL`): thanh trên có “Bỏ”, nhãn ngày
/// `primary-600`, bé + tuổi, ảnh bìa 210 bo 20 (“Đổi ảnh bìa”), tiêu đề 22/800
/// + bút chì, thẻ đoạn văn (✨ Gợi ý bởi AI · Viết lại · Tự viết · Báo cáo),
/// “Ký ức hôm nay” (tick), “Ảnh kèm”, “Ai sẽ thấy”, Bỏ / Lưu câu chuyện.
class DayStoryMobileView extends HookConsumerWidget {
  const DayStoryMobileView({this.childId, super.key});

  final String? childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(dayStoryControllerProvider(childId));
    final l10n = context.l10n;
    final story = controller.story;
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else if (story == null) {
      body = EmptyState(title: l10n.recapDayTitle);
    } else {
      body = _content(context, controller, story);
    }
    return BaseScaffold(
      backgroundColor: kColorBgFFFBF7,
      appBar: AppTopBar(
        trailing: AppTextAction(
          label: l10n.recapDayDiscard,
          color: kColorTextSecondary6B625B,
          fontSize: 14,
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: body,
    );
  }

  Future<void> _save(
    BuildContext context,
    DayStoryController controller,
  ) async {
    final message = context.l10n.recapDaySaved;
    if (await controller.save() && context.mounted) {
      showAppSnackBar(context, message);
      await context.router.maybePop();
    }
  }

  Future<void> _editTitle(
    BuildContext context,
    DayStoryController controller,
    DayStory story,
  ) async {
    final l10n = context.l10n;
    final value = await showAppTextInputSheet(
      context,
      title: l10n.recapDayTitleEdit,
      actionLabel: l10n.commonSave,
      initialValue: story.title,
    );
    if (value != null) {
      controller.setTitle(value);
    }
  }

  Widget _content(
    BuildContext context,
    DayStoryController controller,
    DayStory story,
  ) {
    final l10n = context.l10n;
    final locale = l10n.localeName;
    final child = controller.child;
    final birth = child?.birthDate;
    final date = l10n.calendarDayTitle(
      l10n.careWeekdayTitle(weekdayCode(story.date.weekday)),
      story.date.toDayMonth(locale),
    );
    final headingStyle = AppTypography.adapt(
      context,
      AppTypography.title16.copyWith(
        fontFamily: AppTypography.headingFamily,
        fontWeight: FontWeight.w800,
      ),
    );
    final options = controller.photoOptions;
    final items = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.recapDayKicker(date.toUpperCase()),
            style: AppTypography.overline.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.resolve(context, kColorPrimary600C2513F),
            ),
          ),
          if (child != null) ...[
            const SizedBox(height: AppSpacing.s2),
            Row(
              children: [
                ChildAvatar(child: child, size: 28, borderWidth: 0),
                const SizedBox(width: AppSpacing.s2),
                Flexible(
                  child: Text(
                    l10n.recapDayChild(
                      child.name,
                      birth == null
                          ? ''
                          : childAgeText(l10n, birth, story.date),
                    ),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: kColorTextPrimary2E2A27,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      _DayCover(asset: story.coverAsset, onChange: controller.nextCover),
      InkWell(
        onTap: () => _editTitle(context, controller, story),
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: Row(
          children: [
            Flexible(
              child: Text(
                story.title,
                style: AppTypography.adapt(
                  context,
                  AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s2),
            Icon(
              LucideIcons.pencil,
              size: 16,
              color: AppColors.resolve(context, kColorTextTertiary9C928A),
            ),
          ],
        ),
      ),
      _DayStoryCard(
        body: story.body,
        aiGenerated: story.aiGenerated,
        manual: controller.manual,
        onRewrite: () {
          controller.rewrite();
          showAppSnackBar(context, l10n.recapDayRewritten);
        },
        onManual: controller.writeManually,
        onChanged: controller.setBody,
        onReport: () => showAppSnackBar(context, l10n.commonAiReported),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.recapDayMemories, style: headingStyle)),
              Text(
                l10n.recapDaySelected(
                  controller.selectedCount,
                  story.items.length,
                ),
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: 2,
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
                for (final (index, item) in story.items.indexed)
                  _DayMemoryRow(
                    item: item,
                    divider: index < story.items.length - 1,
                    onTap: () => controller.toggleItem(item.id),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            l10n.recapDayHint,
            style: AppTypography.adapt(context, AppTypography.tiny),
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.recapDayPhotos, style: headingStyle),
          const SizedBox(height: AppSpacing.s2),
          Row(
            children: [
              for (final asset in options) ...[
                Expanded(
                  child: _DayPhotoTile(
                    asset: asset,
                    selected: story.photoAssets.contains(asset),
                    onTap: () => controller.togglePhoto(asset),
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
              ],
              const _DayPhotoTile.add(),
            ],
          ),
        ],
      ),
      _DayWhoSees(
        value: switch (story.visibility) {
          MemoryVisibility.parents => l10n.setVisParents,
          final other => memoryVisibilityLabel(l10n, other),
        },
        onTap: () async {
          final next = await showMemoryVisibilitySheet(
            context,
            current: story.visibility,
          );
          if (next != null) {
            controller.setVisibility(next);
          }
        },
      ),
      Row(
        children: [
          Expanded(
            child: AppButton.secondary(
              label: l10n.recapDayDiscard,
              onPressed: () => context.router.maybePop(),
            ),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: AppButton(
              label: l10n.recapDaySave,
              isLoading: controller.saving,
              onPressed: () => _save(context, controller),
            ),
          ),
        ],
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
