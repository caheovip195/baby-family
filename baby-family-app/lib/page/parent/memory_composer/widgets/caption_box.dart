part of '../mobile/memory_composer_mobile_view.dart';

/// Ô chú thích (`As8JM`): nền `surface-variant` bo 14, đệm 14, chữ 16 (1.5);
/// ảnh: nút “✨ Gợi ý chú thích” (nền `surface`, 12/600 `us-700`). Nhật ký /
/// kỷ vật có thêm dòng tiêu đề; nhật ký & thư cao hơn.
class _CaptionBox extends StatelessWidget {
  const _CaptionBox({required this.controller});

  final MemoryComposerController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final kind = controller.kind;
    final long = kind == MemoryKind.diary || kind == MemoryKind.letter;
    final hint = switch (kind) {
      MemoryKind.diary => l10n.memDiaryBodyHint,
      MemoryKind.letter => l10n.memLetterBodyHint,
      MemoryKind.keepsake => l10n.memKeepsakeHint,
      _ => l10n.memoriesCaptionHint,
    };
    final titleHint = switch (kind) {
      MemoryKind.diary => l10n.memDiaryTitleHint,
      MemoryKind.keepsake => l10n.memKeepsakeTitleHint,
      _ => null,
    };
    final text = AppTypography.adapt(
      context,
      AppTypography.bodyLarge.copyWith(fontSize: 16, height: 1.5),
    );
    final hintStyle = text.copyWith(
      color: AppColors.resolve(context, kColorTextTertiary9C928A),
    );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (titleHint != null)
            TextField(
              controller: controller.title,
              readOnly: !controller.canEditContent,
              style: AppTypography.adapt(context, AppTypography.title17),
              decoration: _decoration(
                titleHint,
                AppTypography.adapt(
                  context,
                  AppTypography.title17.copyWith(
                    color: kColorTextTertiary9C928A,
                  ),
                ),
              ),
            ),
          TextField(
            controller: controller.caption,
            readOnly: !controller.canEditContent,
            minLines: long ? 6 : 2,
            maxLines: null,
            style: text,
            decoration: _decoration(hint, hintStyle),
          ),
          if (kind == MemoryKind.photo && !controller.isEditing) ...[
            const SizedBox(height: AppSpacing.itemGap),
            InkWell(
              onTap: () => _suggestCaptions(context, controller),
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.itemGap,
                  vertical: AppSpacing.compact,
                ),
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.sparkles,
                      size: 14,
                      color: AppColors.resolve(context, kColorUs7006A549F),
                    ),
                    const SizedBox(width: AppSpacing.compact),
                    Flexible(
                      child: Text(
                        l10n.memoriesCaptionSuggestion,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small.copyWith(
                            fontWeight: FontWeight.w600,
                            color: kColorUs7006A549F,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _decoration(String hint, TextStyle style) => InputDecoration(
    hintText: hint,
    hintStyle: style,
    isDense: true,
    filled: false,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    contentPadding: EdgeInsets.zero,
  );
}

/// AI 1.2: xin 3 gợi ý (hỏi đồng ý lần đầu) rồi cho chọn một; gợi ý chỉ là
/// bản nháp vào ô chú thích.
Future<void> _suggestCaptions(
  BuildContext context,
  MemoryComposerController controller,
) async {
  final AiDraftRecord? draft;
  try {
    draft = await runWithAiConsent(
      context,
      action: controller.captionSuggestions,
      grant: controller.grantAiConsent,
    );
  } on Object catch (error) {
    if (context.mounted) {
      showAppSnackBar(context, actionErrorMessage(error));
    }
    return;
  }
  final suggestions = draft?.suggestions ?? const <String>[];
  if (suggestions.isEmpty || !context.mounted) {
    return;
  }
  final invocationId = draft?.invocationId;
  final chosen = await showAppBottomSheet<String>(
    context,
    builder: (sheetContext) {
      final l10n = sheetContext.l10n;
      return AppBottomSheet(
        title: l10n.aiCaptionSheetTitle,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.sparkles,
                size: 14,
                color: AppColors.resolve(sheetContext, kColorUs7006A549F),
              ),
              const SizedBox(width: AppSpacing.compact),
              Text(
                l10n.commonAiSuggested,
                style: AppTypography.adapt(sheetContext, AppTypography.small),
              ),
            ],
          ),
          for (final text in suggestions)
            InkWell(
              onTap: () => Navigator.of(sheetContext).pop(text),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.cardInset),
                decoration: BoxDecoration(
                  color: AppColors.resolve(
                    sheetContext,
                    kColorSurfaceVariantF7F1EC,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  text,
                  style: AppTypography.adapt(sheetContext, AppTypography.body),
                ),
              ),
            ),
          if (invocationId != null)
            Center(
              child: AppTextAction(
                label: l10n.commonAiReport,
                color: kColorTextTertiary9C928A,
                onPressed: () async {
                  Navigator.of(sheetContext).pop();
                  try {
                    await controller.reportCaption(
                      invocationId,
                      suggestions.join('\n'),
                    );
                    if (context.mounted) {
                      showAppSnackBar(context, context.l10n.commonAiReported);
                    }
                  } on Object catch (error) {
                    if (context.mounted) {
                      showAppSnackBar(context, actionErrorMessage(error));
                    }
                  }
                },
              ),
            ),
        ],
      );
    },
  );
  if (chosen != null) {
    controller.useCaption(chosen);
  }
}
