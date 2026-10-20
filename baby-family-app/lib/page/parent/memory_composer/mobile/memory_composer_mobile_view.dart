import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/milestone_option.dart';
import 'package:baby_family/page/parent/memory_composer/memory_composer_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/plan_text.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_action_top_bar.dart';
import 'package:baby_family/utils/widget/app_toggle_row.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/memory_visibility_sheet.dart';
import 'package:baby_family/utils/widget/plan_limit_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/caption_box.dart';
part '../widgets/composer_kid_chip.dart';
part '../widgets/composer_row.dart';
part '../widgets/media_strip.dart';
part '../widgets/voice_recorder.dart';

/// MEM-05 Soạn ký ức (Pencil `U18pC` — loại ảnh). Các loại khác (nhật ký
/// MEM-13, thư MEM-14, cột mốc, ghi âm, kỷ vật, ảnh tháng) dùng cùng ngôn ngữ
/// hình ảnh với trường theo tài liệu 9.4.
class MemoryComposerMobileView extends HookConsumerWidget {
  const MemoryComposerMobileView({
    this.kind,
    this.childId,
    this.memoryId,
    super.key,
  });

  final String? kind;
  final String? childId;

  /// MEM-09: sửa ký ức này (null = soạn mới).
  final String? memoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(memoryComposerControllerProvider);
    useEffect(() {
      Future.microtask(
        () => controller.init(kind, childId, memoryId: memoryId),
      );
      return null;
    }, const []);
    final l10n = context.l10n;
    final type = controller.kind;
    final title = switch (type) {
      _ when controller.isEditing => l10n.memEditTitle,
      MemoryKind.diary => l10n.memComposerDiary,
      MemoryKind.letter => l10n.commonLetter,
      MemoryKind.milestone => l10n.memComposerMilestone,
      MemoryKind.voice => l10n.memComposerVoice,
      MemoryKind.keepsake => l10n.memComposerKeepsake,
      MemoryKind.monthlyPhoto => l10n.memComposerMonthly(
        controller.monthIndex ?? 0,
        controller.firstChild?.name ?? '',
      ),
      _ => l10n.memoriesNew,
    };
    Future<void> save() async {
      final saved = await controller.save();
      final error = controller.saveError;
      if (saved == null && error != null && context.mounted) {
        showAppSnackBar(context, actionErrorMessage(error));
        return;
      }
      if (saved != null && context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(
              controller.isEditing ? l10n.memEditSaved : l10n.memoriesSaved,
            ),
          ),
        );
        await context.router.maybePop(true);
      }
    }

    /// ✕ khi đang soạn dở → lưu nháp trên máy, báo kèm lối “Xem nháp”.
    Future<void> close() async {
      final router = context.router;
      if (!controller.hasContent) {
        await router.maybePop();
        return;
      }
      final messenger = ScaffoldMessenger.maybeOf(context);
      await controller.saveDraft();
      messenger
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.memDraftSaved),
            action: SnackBarAction(
              label: l10n.memDraftView,
              onPressed: () => router.push(const DraftsRoute()),
            ),
          ),
        );
      await router.maybePop();
    }

    return BaseScaffold(
      isLoading: controller.isLoading,
      appBar: AppActionTopBar(
        title: title,
        actionLabel: l10n.commonSave,
        onAction: controller.loaded ? save : null,
        onClose: close,
      ),
      body: !controller.loaded
          ? const Center(child: CircleLoadingProgress())
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.s1,
                AppSpacing.screen,
                AppSpacing.s8,
              ),
              children: _sections(context, controller),
            ),
    );
  }

  List<Widget> _sections(
    BuildContext context,
    MemoryComposerController controller,
  ) {
    final l10n = context.l10n;
    final type = controller.kind;
    final editing = controller.isEditing;
    final sections = <Widget>[
      if (editing && !controller.canEditContent)
        _hint(context, LucideIcons.lock, l10n.memEditAuthorOnlyHint),
      if (type == MemoryKind.voice && !editing)
        _VoiceRecorder(controller: controller),
      if (controller.hasMedia &&
          (!editing || controller.mediaAssets.isNotEmpty))
        _MediaStrip(
          controller: controller,
          onAdd: controller.canEditMedia
              ? () => _pickMedia(context, controller)
              : null,
        ),
      if (editing && controller.hasMedia && !controller.canEditMedia)
        _hint(context, LucideIcons.images, l10n.memEditMediaHint),
      _CaptionBox(controller: controller),
      _kids(context, controller),
      _ComposerRow(
        icon: LucideIcons.calendar,
        label: l10n.memoriesDate,
        value: memoryDayLabel(l10n, controller.occurredAt, controller.today),
        onTap: controller.canEditContent
            ? () => _pickDate(context, controller)
            : null,
      ),
      if (type == MemoryKind.letter && !editing)
        _ComposerRow(
          icon: LucideIcons.mailOpen,
          label: l10n.memLetterOpenDate,
          value: controller.sealedUntil == null
              ? l10n.memLetterOpenNone
              : memoryDayLabel(l10n, controller.sealedUntil!, controller.today),
          onTap: () => _pickOpenDate(context, controller),
        ),
      _ComposerRow(
        icon: LucideIcons.users,
        label: l10n.memoriesVisibility,
        value:
            controller.visibility == MemoryVisibility.family &&
                controller.relativeCount > 0
            ? l10n.memAudienceRelatives(controller.relativeCount)
            : memoryVisibilityLabel(l10n, controller.visibility),
        onTap: () async {
          final value = await showMemoryVisibilitySheet(
            context,
            current: controller.visibility,
            options: controller.visibilityOptions,
          );
          if (value != null) {
            controller.setVisibility(value);
          }
        },
      ),
      if (editing && controller.canEditContent)
        AppToggleRow(
          icon: LucideIcons.messageCircle,
          title: l10n.memCommentsAllow,
          subtitle: l10n.memCommentsAllowHint,
          value: controller.commentsEnabled,
          onChanged: controller.setCommentsEnabled,
        ),
      if ((type == MemoryKind.photo || type == MemoryKind.milestone) &&
          !editing)
        _ComposerRow(
          icon: LucideIcons.star,
          label: l10n.memoriesMarkMilestone,
          value: controller.milestoneTitle ?? l10n.memChooseMilestone,
          onTap: () => _pickMilestone(context, controller),
        ),
      if (type == MemoryKind.photo && !editing)
        _ComposerRow(
          icon: LucideIcons.folderHeart,
          label: l10n.memoriesAlbum,
          value: l10n.memoriesChooseAlbum,
          onTap: () => context.router.push(const AlbumsRoute()),
        ),
      if (controller.hasMedia)
        Row(
          children: [
            Icon(
              LucideIcons.shieldCheck,
              size: 16,
              color: AppColors.resolve(context, kColorSecondary7003F7A5C),
            ),
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: Text(
                l10n.memoriesPrivacyHint,
                style: AppTypography.adapt(context, AppTypography.small),
              ),
            ),
          ],
        ),
    ];
    return [
      for (var index = 0; index < sections.length; index++) ...[
        if (index > 0) const SizedBox(height: AppSpacing.sectionGap),
        sections[index],
      ],
    ];
  }

  /// Dòng ghi chú nhỏ (icon 16 + chữ `small`) — MEM-09 giải thích trường bị khoá.
  Widget _hint(BuildContext context, IconData icon, String text) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(
        icon,
        size: 16,
        color: AppColors.resolve(context, kColorTextSecondary6B625B),
      ),
      const SizedBox(width: AppSpacing.s2),
      Expanded(
        child: Text(
          text,
          style: AppTypography.adapt(context, AppTypography.small),
        ),
      ),
    ],
  );

  Widget _kids(BuildContext context, MemoryComposerController controller) {
    final l10n = context.l10n;
    final letter = controller.kind == MemoryKind.letter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          letter ? l10n.memLetterTo : l10n.memoriesChildren,
          style: AppTypography.adapt(
            context,
            AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: [
            for (final child in controller.children)
              _ComposerKidChip(
                child: child,
                label: child.name,
                selected: controller.childIds.contains(child.id),
                onTap: () => controller.toggleChild(child.id),
              ),
            if (!letter)
              _ComposerKidChip(
                label: l10n.memoriesFamily,
                selected: controller.familyMoment,
                onTap: controller.toggleFamilyMoment,
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    MemoryComposerController controller,
  ) async {
    final value = await showDatePicker(
      context: context,
      initialDate: controller.occurredAt,
      firstDate: DateTime(2000),
      lastDate: controller.today,
    );
    if (value != null) {
      controller.setDate(value);
    }
  }

  Future<void> _pickOpenDate(
    BuildContext context,
    MemoryComposerController controller,
  ) async {
    final value = await showDatePicker(
      context: context,
      initialDate: controller.sealedUntil ?? controller.today,
      firstDate: controller.today,
      lastDate: DateTime(controller.today.year + 30),
    );
    controller.setSealedUntil(value);
  }

  /// Ô “+”. Chế độ server: photo picker hệ thống (MEM-04 — không xin quyền
  /// toàn bộ thư viện), ảnh thu nhỏ về JPEG trước khi tải lên. Bản mẫu: luôn
  /// chọn một video dài [kValueMockPickedVideoMinutes] phút; dài hơn giới hạn
  /// của gói → SUB-05: cắt ngắn, chọn video khác, lưu dạng nhật ký chữ
  /// (MEM-13) hoặc nâng cấp (SUB-04/SUB-01).
  Future<void> _pickMedia(
    BuildContext context,
    MemoryComposerController controller,
  ) async {
    if (kValueUseRemoteSession) {
      // Ảnh và video (MEM-04); video dài hơn giới hạn của gói không được thêm
      // mà hiện SUB-05 như bản mẫu.
      final picked = await ImagePicker().pickMultipleMedia(
        maxWidth: kValueUploadImageMaxSide,
        maxHeight: kValueUploadImageMaxSide,
        imageQuality: kValueUploadImageQuality,
      );
      final (:accepted, :tooLongMinutes) = await controller.screenPicked([
        for (final file in picked) file.path,
      ]);
      controller.addMedia(accepted);
      if (tooLongMinutes != null && context.mounted) {
        await _showVideoLimit(context, controller, tooLongMinutes);
      }
      return;
    }
    await _showVideoLimit(context, controller, kValueMockPickedVideoMinutes);
  }

  /// SUB-05 video dài [minutes] phút vượt giới hạn của gói.
  Future<void> _showVideoLimit(
    BuildContext context,
    MemoryComposerController controller,
    int minutes,
  ) async {
    final limit = await controller.videoLimit();
    if (!context.mounted || minutes <= limit.maxMinutes) {
      return;
    }
    final l10n = context.l10n;
    final choice = await showPlanLimitSheet(
      context,
      title: l10n.subLimitVideoTitle(minutes),
      message: l10n.subLimitVideoBody(
        planTitle(l10n, limit.plan),
        limit.maxMinutes,
      ),
      primaryLabel: l10n.subLimitTrim(limit.maxMinutes),
      secondaryLabel: l10n.subLimitPickAnother,
      textActionLabel: l10n.subLimitSaveDiary,
      isTopPlan: limit.plan == PlanState.family,
    );
    if (!context.mounted) {
      return;
    }
    switch (choice) {
      case PlanLimitChoice.primary:
        showAppSnackBar(context, l10n.subLimitTrimmed(limit.maxMinutes));
      case PlanLimitChoice.saveAsText:
        await context.router.push(
          DiaryEditorRoute(childId: controller.milestoneChildId),
        );
      case PlanLimitChoice.upgrade:
        await context.router.push(
          limit.plan == PlanState.house
              ? const UpgradePlanRoute()
              : const PlansRoute(),
        );
      case PlanLimitChoice.secondary || null:
        break;
    }
  }

  /// “Đánh dấu cột mốc” → MEM-11; cột mốc chọn được điền lại vào form.
  Future<void> _pickMilestone(
    BuildContext context,
    MemoryComposerController controller,
  ) async {
    final picked = await context.router.push<MilestoneOption>(
      MilestonePickerRoute(childId: controller.milestoneChildId),
    );
    if (picked != null) {
      controller.setMilestone(code: picked.code, title: picked.title);
    }
  }
}
