import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/dto/diary_block.dart';
import 'package:baby_family/page/parent/diary_editor/diary_editor_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/memory_visibility_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/diary_block_field.dart';
part '../widgets/diary_format_bar.dart';
part '../widgets/diary_meta_chip.dart';
part '../widgets/diary_prompts.dart';
part '../widgets/diary_top_bar.dart';

/// MEM-13 Viết nhật ký (Pencil `Z9a5ZF`): trình soạn toàn màn hình nền
/// `surface`.
class DiaryEditorMobileView extends HookConsumerWidget {
  const DiaryEditorMobileView({this.childId, super.key});

  final String? childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(diaryEditorControllerProvider(childId));
    final l10n = context.l10n;
    final surface = AppColors.resolve(context, kColorSurfaceFFFFFF);
    if (!controller.loaded) {
      return Scaffold(
        backgroundColor: surface,
        body: const Center(child: CircleLoadingProgress()),
      );
    }
    final child = controller.child;
    final date = controller.occurredAt;
    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DiaryTopBar(
              savedLabel: controller.savedAt == null
                  ? null
                  : l10n.memDiarySavedDraft(
                      controller.savedAt!.toDisplayTime(l10n.localeName),
                    ),
              onSave: () => _save(context, controller),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.compact,
                AppSpacing.screen,
                AppSpacing.itemGap,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.resolve(context, kColorBorderEADFD6),
                  ),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (child != null)
                      _DiaryMetaChip(
                        leading: ChildAvatar(
                          child: child,
                          size: 24,
                          borderWidth: 0,
                        ),
                        label: child.name,
                        onTap: () => _pickChild(context, controller),
                      ),
                    const SizedBox(width: AppSpacing.s2),
                    _DiaryMetaChip(
                      icon: LucideIcons.calendar,
                      label: date == null || date.isSameDay(controller.today)
                          ? l10n.memoriesToday
                          : date.toFormDate(l10n.localeName),
                      onTap: () => _pickDate(context, controller),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    _DiaryMetaChip(
                      icon: LucideIcons.users,
                      label: memoryVisibilityLabel(l10n, controller.visibility),
                      onTap: () async {
                        final value = await showMemoryVisibilitySheet(
                          context,
                          current: controller.visibility,
                        );
                        if (value != null) {
                          controller.setVisibility(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: _editor(context, controller)),
            if (child != null && controller.prompts.isNotEmpty)
              _DiaryPrompts(
                title: l10n.careSuggestFor(
                  child.name,
                  childAgeText(
                    l10n,
                    child.birthDate ?? controller.today,
                    controller.today,
                  ),
                ),
                prompts: controller.visiblePrompts,
                onPrompt: controller.usePrompt,
                onMore: controller.nextPrompts,
              ),
            _DiaryFormatBar(controller: controller),
          ],
        ),
      ),
    );
  }

  Widget _editor(BuildContext context, DiaryEditorController controller) {
    final l10n = context.l10n;
    final blocks = controller.blocks;
    final items = <Widget>[
      TextField(
        controller: controller.title,
        maxLines: null,
        textInputAction: TextInputAction.next,
        style: AppTypography.adapt(
          context,
          AppTypography.h1.copyWith(
            fontSize: 24,
            height: 1.25,
            letterSpacing: 0,
          ),
        ),
        decoration: InputDecoration.collapsed(
          hintText: l10n.memDiaryTitleHint,
          hintStyle: AppTypography.h1.copyWith(
            fontSize: 24,
            height: 1.25,
            color: AppColors.resolve(context, kColorTextTertiary9C928A),
          ),
        ),
      ),
    ];
    var number = 0;
    for (var index = 0; index <= blocks.length; index++) {
      if (controller.photo != null && index == controller.photoIndex) {
        items.add(_photo(context, controller));
      }
      if (index == blocks.length) {
        break;
      }
      final block = blocks[index];
      number = block.kind == DiaryBlockKind.numbered ? number + 1 : 0;
      final previous = index > 0 ? blocks[index - 1] : null;
      final listGap =
          previous != null &&
          previous.kind != DiaryBlockKind.paragraph &&
          block.kind != DiaryBlockKind.paragraph &&
          !(controller.photo != null && index == controller.photoIndex);
      items.add(
        Padding(
          padding: EdgeInsets.only(
            top: listGap ? AppSpacing.s1 : AppSpacing.s3,
            left: block.kind == DiaryBlockKind.paragraph ? 0 : AppSpacing.s1,
          ),
          child: _DiaryBlockField(
            block: block,
            number: number,
            hint: blocks.length == 1 ? l10n.memDiaryBodyHint : null,
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s4,
        AppSpacing.screen,
        AppSpacing.s3,
      ),
      children: items,
    );
  }

  Widget _photo(BuildContext context, DiaryEditorController controller) =>
      Padding(
        padding: const EdgeInsets.only(top: AppSpacing.s3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: SizedBox(
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(controller.photo!, fit: BoxFit.cover),
                Positioned(
                  top: AppSpacing.s2,
                  right: AppSpacing.s2,
                  child: Semantics(
                    button: true,
                    label: context.l10n.commonRemovePhoto,
                    excludeSemantics: true,
                    child: InkResponse(
                      onTap: controller.removePhoto,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: kColorSheetScrim2E2A27Alpha60,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.x,
                          size: 14,
                          color: kColorWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _save(
    BuildContext context,
    DiaryEditorController controller,
  ) async {
    final router = context.router;
    final message = context.l10n.memDiarySaved;
    if (await controller.save()) {
      await router.maybePop();
      final current = router.navigatorKey.currentContext;
      if (current != null && current.mounted) {
        showAppSnackBar(current, message);
      }
    }
  }

  Future<void> _pickChild(
    BuildContext context,
    DiaryEditorController controller,
  ) async {
    final id = await showAppBottomSheet<String>(
      context,
      builder: (sheetContext) => AppBottomSheet(
        title: sheetContext.l10n.memoriesChildren,
        gap: 0,
        children: [
          for (final item in controller.children)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ChildAvatar(child: item, size: 36),
              title: Text(
                item.name,
                style: AppTypography.adapt(
                  sheetContext,
                  AppTypography.bodyStrong,
                ),
              ),
              trailing: item.id == controller.child?.id
                  ? Icon(
                      LucideIcons.check,
                      color: AppColors.resolve(
                        sheetContext,
                        kColorPrimary600C2513F,
                      ),
                    )
                  : null,
              onTap: () => Navigator.of(sheetContext).pop(item.id),
            ),
        ],
      ),
    );
    if (id != null) {
      controller.selectChild(id);
    }
  }

  Future<void> _pickDate(
    BuildContext context,
    DiaryEditorController controller,
  ) async {
    final value = await showDatePicker(
      context: context,
      initialDate: controller.occurredAt ?? controller.today,
      firstDate: DateTime(2000),
      lastDate: controller.today,
    );
    if (value != null) {
      controller.setDate(value);
    }
  }
}
