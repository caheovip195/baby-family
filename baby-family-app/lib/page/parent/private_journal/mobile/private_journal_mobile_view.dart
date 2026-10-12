import 'package:baby_family/data/model/us/journal_entry.dart';
import 'package:baby_family/page/parent/private_journal/private_journal_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_extended_fab.dart';
import 'package:baby_family/utils/widget/app_selectable_chip.dart';
import 'package:baby_family/utils/widget/app_setting_row.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/journal_editor_sheet.dart';
part '../widgets/journal_entry_card.dart';
part '../widgets/journal_only_you_card.dart';

/// Icon + màu nền/chữ của nhãn cảm xúc (Pencil “Mood”).
(IconData, Color, Color) _moodStyle(JournalMood mood) => switch (mood) {
  JournalMood.tired => (
    LucideIcons.batteryLow,
    kColorPrimary50FFF4F1,
    kColorPrimary700A2402F,
  ),
  JournalMood.grateful => (
    LucideIcons.heart,
    kColorSecondary100E4F2EA,
    kColorSecondary7003F7A5C,
  ),
  JournalMood.worried => (
    LucideIcons.cloudDrizzle,
    kColorAccent100FDF1D6,
    kColorAccent7009A6A12,
  ),
  JournalMood.calm => (
    LucideIcons.leaf,
    kColorSecondary100E4F2EA,
    kColorSecondary7003F7A5C,
  ),
};

/// US-07 “Nhật ký riêng” (Pencil `L5Opmj`).
class PrivateJournalMobileView extends HookConsumerWidget {
  const PrivateJournalMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(privateJournalControllerProvider);
    final l10n = context.l10n;

    Future<void> write() => showAppBottomSheet<void>(
      context,
      strongScrim: true,
      builder: (_) => _JournalEditorSheet(controller: controller),
    );

    Future<void> share(JournalEntry entry) async {
      final confirmed = await showAppBottomSheet<bool>(
        context,
        strongScrim: true,
        builder: (sheetContext) => AppBottomSheet(
          title: l10n.usJournalShareAction,
          children: [
            Text(
              l10n.usJournalSharePreview(controller.partnerCallName),
              style: AppTypography.adapt(context, AppTypography.caption),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardInset),
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorUs50F6F2FC),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                entry.body,
                style: AppTypography.adapt(context, AppTypography.body),
              ),
            ),
            AppButton.us(
              label: l10n.usJournalShareConfirm(controller.partnerCallName),
              onPressed: () => Navigator.of(sheetContext).pop(true),
            ),
          ],
        ),
      );
      if (confirmed ?? false) {
        await controller.share(entry.id);
      }
    }

    Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else {
      final entries = controller.entries;
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          92 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.usJournal,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          _JournalOnlyYouCard(partnerCallName: controller.partnerCallName),
          const SizedBox(height: AppSpacing.cardInset),
          AppCard(
            padding: EdgeInsets.zero,
            borderColor: kColorUs100EAE2F8,
            child: AppSettingRow(
              icon: LucideIcons.scanFace,
              iconSize: 22,
              iconColor: kColorUs7006A549F,
              title: l10n.usJournalFaceId,
              subtitle: l10n.usJournalFaceIdHint,
              onTap: () => controller.setFaceIdLock(
                !controller.settings.journalFaceIdLock,
              ),
              trailing: AppSwitch(
                value: controller.settings.journalFaceIdLock,
                activeColor: kColorUs5009B85D1,
                onChanged: controller.setFaceIdLock,
              ),
            ),
          ),
          if (entries.isEmpty) ...[
            const SizedBox(height: AppSpacing.s6),
            EmptyState(title: l10n.usJournalEmpty, illustrationSize: 140),
          ],
          for (final (index, entry) in entries.indexed) ...[
            if (index == 0 ||
                entries[index - 1].createdAt.month !=
                    entry.createdAt.month) ...[
              const SizedBox(height: AppSpacing.cardInset),
              AppCapsLabel(l10n.usJournalMonth('${entry.createdAt.month}')),
            ],
            const SizedBox(height: AppSpacing.cardInset),
            _JournalEntryCard(
              entry: entry,
              partnerCallName: controller.partnerCallName,
              onShare: controller.shareableId == entry.id
                  ? () => share(entry)
                  : null,
            ),
          ],
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
              label: l10n.usJournalWrite,
              icon: LucideIcons.penLine,
              onTap: write,
            ),
          ),
        ],
      ),
    );
  }
}
