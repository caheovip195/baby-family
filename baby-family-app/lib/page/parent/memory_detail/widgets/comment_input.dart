part of '../mobile/memory_detail_mobile_view.dart';

/// Ô bình luận cố định đáy (`s05EBv`): nền `surface`, viền trên, đệm
/// 10/16/28/16; ô 44 bo tròn `surface-variant`; nút gửi 44 `primary-600`
/// (`send-horizontal` 20).
class _CommentInput extends StatelessWidget {
  const _CommentInput({required this.controller});

  final MemoryDetailController controller;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s4,
        AppSpacing.itemGap,
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.comment,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => controller.sendComment(),
              style: AppTypography.adapt(context, AppTypography.text14),
              decoration: InputDecoration(
                hintText: context.l10n.memoriesCommentHint,
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s4,
                  vertical: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Semantics(
            button: true,
            label: context.l10n.memoriesSend,
            excludeSemantics: true,
            child: InkResponse(
              onTap: controller.sendComment,
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
    );
  }
}
