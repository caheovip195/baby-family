import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/page/parent/child_edit/child_edit_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/lunar_date.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_action_top_bar.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_outline_chip.dart';
import 'package:baby_family/utils/widget/app_picker_field.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_toggle_row.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/edit_avatar_row.dart';
part '../widgets/edit_color_swatches.dart';
part '../widgets/namer_sheet.dart';

/// CHD-02 “Sửa hồ sơ bé” (Pencil `nX7EO`).
class ChildEditMobileView extends HookConsumerWidget {
  const ChildEditMobileView({required this.childId, super.key});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(childEditControllerProvider);
    final l10n = context.l10n;
    final fullName = useTextEditingController();
    final nickname = useTextEditingController();
    final story = useTextEditingController();
    final food = useTextEditingController();
    final toy = useTextEditingController();
    final song = useTextEditingController();
    useEffect(() {
      controller.init(childId).then((_) {
        if (controller.hasError) {
          return;
        }
        final profile = controller.profile;
        fullName.text = profile.fullName ?? '';
        nickname.text = controller.child.name;
        story.text = profile.nameStory ?? '';
        food.text = profile.favoriteFood ?? '';
        toy.text = profile.favoriteToy ?? '';
        song.text = profile.favoriteSong ?? '';
      });
      return null;
    }, [childId]);

    Future<void> save() async {
      final router = context.router;
      await controller.save();
      await router.maybePop(true);
    }

    final topBar = AppActionTopBar(
      title: controller.loaded && !controller.hasError
          ? l10n.childEditTitleNamed(controller.child.name)
          : l10n.childEditTitle,
      actionLabel: l10n.commonSave,
      onAction: controller.loaded && !controller.hasError ? save : null,
      actionStyle: const TextStyle(
        fontFamily: AppTypography.bodyFamily,
        fontSize: 15,
        height: 19 / 15,
        fontWeight: FontWeight.w700,
        color: kColorPrimary600C2513F,
      ),
    );
    if (!controller.loaded || controller.hasError) {
      return BaseScaffold(
        appBar: topBar,
        body: Center(
          child: controller.hasError
              ? const ErrorState()
              : const CircleLoadingProgress(),
        ),
      );
    }
    final child = controller.child;
    final profile = controller.profile;
    final date = child.isPregnancy ? child.dueDate : child.birthDate;
    final labelStyle = AppTypography.adapt(
      context,
      AppTypography.caption.copyWith(
        fontWeight: FontWeight.w600,
        height: 16 / 13,
      ),
    );

    Future<void> pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: date ?? controller.today,
        firstDate: DateTime(controller.today.year - 18),
        lastDate: DateTime(controller.today.year + 1),
      );
      if (picked != null) {
        controller.setDate(picked);
      }
    }

    Future<void> pickTime() async {
      final parts = (child.birthTime ?? '').split(':');
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: int.tryParse(parts.first) ?? 6,
          minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
        ),
      );
      if (picked != null) {
        controller.setBirthTime(
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}',
        );
      }
    }

    Future<void> addNamer() async {
      final name = await showAppBottomSheet<String>(
        context,
        builder: (_) => const _NamerSheet(),
      );
      if (name != null && name.trim().isNotEmpty) {
        controller.toggleNamer(name.trim());
      }
    }

    const gap = SizedBox(height: 18);
    return BaseScaffold(
      appBar: topBar,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s1,
          AppSpacing.screen,
          28 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          _EditAvatarRow(
            child: child,
            onTap: () => showComingSoonSnackBar(context),
          ),
          gap,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 22,
                child: AppTextField(
                  label: l10n.childFieldName,
                  controller: fullName,
                  onChanged: controller.setFullName,
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                flex: 12,
                child: AppTextField(
                  label: l10n.childFieldNickname,
                  controller: nickname,
                  onChanged: controller.setNickname,
                ),
              ),
            ],
          ),
          gap,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 23,
                child: AppPickerField(
                  label: child.isPregnancy
                      ? l10n.childDueDate
                      : l10n.childBirthDate,
                  value: date?.toFormDate(l10n.localeName),
                  highlighted: true,
                  onTap: pickDate,
                ),
              ),
              if (!child.isPregnancy) ...[
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  flex: 11,
                  child: AppPickerField(
                    label: l10n.childBirthTime,
                    value: child.birthTime,
                    onTap: pickTime,
                  ),
                ),
              ],
            ],
          ),
          if (date != null) ...[
            const SizedBox(height: AppSpacing.s2),
            Text(
              l10n.childLunarBirth(lunarDateWithYearText(l10n, date)),
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s2),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.itemGap,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorAccent100FDF1D6),
              borderRadius: BorderRadius.circular(AppRadius.tile),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.info,
                  size: 16,
                  color: AppColors.resolve(context, kColorAccent7009A6A12),
                ),
                const SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: Text(
                    l10n.childBirthDateWarning,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        height: 17 / 12,
                        fontWeight: FontWeight.w600,
                        color: kColorAccent7009A6A12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!child.isPregnancy) ...[
            gap,
            AppToggleRow(
              title: l10n.childShowBirthTime,
              subtitle: l10n.childShowBirthTimeHint,
              value: profile.showBirthTimeToRelatives,
              onChanged: controller.setShowBirthTime,
              titleStyle: AppTypography.text14.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          gap,
          Text(l10n.childColorLabel, style: labelStyle),
          const SizedBox(height: AppSpacing.itemGap),
          _EditColorSwatches(controller: controller),
          gap,
          Text(l10n.childNameStory, style: labelStyle),
          const SizedBox(height: AppSpacing.s2),
          AppTextField(
            controller: story,
            maxLines: 4,
            onChanged: controller.setNameStory,
          ),
          const SizedBox(height: AppSpacing.s2),
          Wrap(
            spacing: AppSpacing.s2,
            runSpacing: AppSpacing.s2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                l10n.childNameGivenByLabel,
                style: AppTypography.adapt(context, AppTypography.caption),
              ),
              for (final name in controller.namerOptions)
                AppOutlineChip(
                  label: name,
                  height: 32,
                  selectedStrokeWidth: 1,
                  selected: profile.nameGivenBy.contains(name),
                  onTap: () => controller.toggleNamer(name),
                ),
              AppOutlineChip(
                label: l10n.childNameGivenByOther,
                height: 32,
                onTap: addNamer,
              ),
            ],
          ),
          gap,
          AppCapsLabel(l10n.childLikesSection),
          gap,
          AppTextField(
            label: l10n.childFavFood,
            controller: food,
            onChanged: controller.setFavoriteFood,
          ),
          gap,
          AppTextField(
            label: l10n.childFavToy,
            controller: toy,
            onChanged: controller.setFavoriteToy,
          ),
          gap,
          AppTextField(
            label: l10n.childFavSong,
            controller: song,
            onChanged: controller.setFavoriteSong,
          ),
          gap,
          AppButton(
            label: l10n.childSaveChanges,
            isLoading: controller.isLoading,
            onPressed: save,
          ),
        ],
      ),
    );
  }
}
