part of '../mobile/memory_comments_mobile_view.dart';

/// Menu giữ lâu (`GD8GV`) nổi phía trên bong bóng: nền `text-primary` bo 14,
/// đệm 4, cách 2; mục cao 32 đệm 8/12, icon 15 + chữ 13/600 trắng (Xoá
/// `#FF9A8A`); bóng `#2E2A2740` (y 6, blur 20).
Future<CommentAction?> _showCommentActionMenu(
  BuildContext context, {
  required Rect anchor,
  required bool canEdit,
  required bool canDelete,
}) => showGeneralDialog<CommentAction>(
  context: context,
  barrierDismissible: true,
  barrierLabel: context.l10n.commonClose,
  barrierColor: kColorTransparent,
  pageBuilder: (dialogContext, _, _) {
    final l10n = dialogContext.l10n;
    final screen = MediaQuery.sizeOf(dialogContext);
    final top = anchor.top - 48 < MediaQuery.paddingOf(dialogContext).top
        ? anchor.bottom + AppSpacing.s2
        : anchor.top - 48;
    Widget action(
      CommentAction value,
      IconData icon,
      String label, {
      Color color = kColorWhite,
    }) => InkWell(
      onTap: () => Navigator.of(dialogContext).pop(value),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3,
          vertical: AppSpacing.s2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: AppSpacing.compact),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
                height: 16 / 13,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
    return Stack(
      children: [
        Positioned(
          top: top,
          left: AppSpacing.screen,
          width: screen.width - AppSpacing.screen * 2,
          child: Align(
            alignment: Alignment.center,
            child: Material(
              color: kColorTextPrimary2E2A27,
              borderRadius: BorderRadius.circular(AppRadius.md),
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.s1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: const [
                    BoxShadow(
                      color: kColorShadow2E2A27Alpha25,
                      offset: Offset(0, 6),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (canEdit)
                      action(
                        CommentAction.edit,
                        LucideIcons.pencil,
                        l10n.memCommentEdit,
                      ),
                    action(
                      CommentAction.copy,
                      LucideIcons.copy,
                      l10n.memCommentCopy,
                    ),
                    if (canDelete)
                      action(
                        CommentAction.delete,
                        LucideIcons.trash2,
                        l10n.memCommentDelete,
                        color: kColorDangerOnDarkFF9A8A,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  },
);
