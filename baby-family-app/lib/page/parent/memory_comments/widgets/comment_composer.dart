part of '../mobile/memory_comments_mobile_view.dart';

/// Ô nhập đáy (`NlGDc`): nền `surface`, viền trên, đệm 8/16/28/16, cách 8;
/// dòng “Đang trả lời …” (12/500 + `x` 16) khi trả lời / sửa; ô 44 bo tròn
/// `surface-variant` có nút emoji 32 (`smile` 20); nút gửi 44 `primary-600`.
class _CommentComposer extends StatelessWidget {
  const _CommentComposer({
    required this.controller,
    required this.replyingName,
    required this.onEmoji,
  });

  final MemoryCommentsController controller;
  final String? replyingName;
  final VoidCallback onEmoji;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final mode = controller.editing != null
        ? l10n.memCommentEditing
        : replyingName == null
        ? null
        : l10n.memCommentReplying(replyingName!);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.full),
      borderSide: BorderSide.none,
    );
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s4,
        AppSpacing.s2,
        AppSpacing.s4,
        bottom > 0 ? bottom : 28,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        border: Border(
          top: BorderSide(
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (mode != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      mode,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: l10n.commonCancel,
                    excludeSemantics: true,
                    child: InkResponse(
                      onTap: controller.cancelComposerMode,
                      child: Icon(
                        LucideIcons.x,
                        size: 16,
                        color: AppColors.resolve(
                          context,
                          kColorTextTertiary9C928A,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s2),
          ],
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.input,
                  focusNode: controller.focus,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => controller.send(),
                  style: AppTypography.adapt(context, AppTypography.text14),
                  decoration: InputDecoration(
                    hintText: l10n.memoriesCommentHint,
                    hintStyle: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        color: kColorTextTertiary9C928A,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.resolve(
                      context,
                      kColorSurfaceVariantF7F1EC,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(
                      AppSpacing.s4,
                      13,
                      AppSpacing.s2,
                      13,
                    ),
                    suffixIcon: Semantics(
                      button: true,
                      label: l10n.memCommentEmoji,
                      excludeSemantics: true,
                      child: InkResponse(
                        onTap: onEmoji,
                        child: Icon(
                          LucideIcons.smile,
                          size: 20,
                          color: AppColors.resolve(
                            context,
                            kColorTextSecondary6B625B,
                          ),
                        ),
                      ),
                    ),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Semantics(
                button: true,
                label: l10n.memoriesSend,
                excludeSemantics: true,
                child: InkResponse(
                  onTap: controller.send,
                  child: Container(
                    width: AppSpacing.iconButton,
                    height: AppSpacing.iconButton,
                    decoration: BoxDecoration(
                      color: AppColors.resolve(context, kColorPrimary600C2513F),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.sendHorizontal,
                      size: 20,
                      color: AppColors.onPrimary(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
