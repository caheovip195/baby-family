part of '../mobile/pending_review_mobile_view.dart';

/// Sửa trước khi duyệt (Pencil “Edit before approve”): nền `surface-variant`
/// bo 14 đệm [2,12]; dòng “Bé trong ảnh” (chip bé đã gắn: nền `surface`
/// chấm màu bé 12/600; bé khác: viền + `plus` 12) + `pencil`; dòng “Ai nhìn
/// thấy” `users` “Cả nhà · 5 người”.
class _ChildEditPanel extends StatelessWidget {
  const _ChildEditPanel({required this.post, required this.controller});

  final Memory post;
  final PendingReviewController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = controller.childIdsOf(post);
    final label = AppTypography.adapt(
      context,
      AppTypography.caption.copyWith(color: kColorTextSecondary6B625B),
    );
    const labelWidth = 96.0;
    Widget chip(Child child) {
      final on = selected.contains(child.id);
      return Semantics(
        button: true,
        selected: on,
        label: on ? child.name : l10n.memPendingAddChild(child.name),
        excludeSemantics: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.full),
          onTap: () => controller.toggleChild(post, child.id),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.itemGap,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: on
                  ? AppColors.resolve(context, kColorSurfaceFFFFFF)
                  : null,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: AppColors.resolve(context, kColorBorderEADFD6),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (on)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.resolve(
                        context,
                        ChildAvatar.colorOf(child),
                      ),
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  Icon(
                    LucideIcons.plus,
                    size: 12,
                    color: AppColors.resolve(
                      context,
                      kColorTextSecondary6B625B,
                    ),
                  ),
                SizedBox(width: on ? AppSpacing.compact : AppSpacing.s1),
                Text(
                  child.name,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(
                      fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                      color: on
                          ? kColorTextPrimary2E2A27
                          : kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: labelWidth,
                  child: Text(l10n.memPendingKids, style: label),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Wrap(
                    spacing: AppSpacing.compact,
                    runSpacing: AppSpacing.compact,
                    children: [
                      // Bé đã gắn trước (Pencil: “Haru” rồi “+ Hana”).
                      for (final on in [true, false])
                        for (final child in controller.children)
                          if (selected.contains(child.id) == on) chip(child),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Icon(
                  LucideIcons.pencil,
                  size: 16,
                  color: AppColors.resolve(context, kColorPrimary700A2402F),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.itemGap),
            child: Row(
              children: [
                SizedBox(
                  width: labelWidth,
                  child: Text(l10n.memPendingAudience, style: label),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Icon(
                  LucideIcons.users,
                  size: 14,
                  color: AppColors.resolve(context, kColorTextPrimary2E2A27),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Text(
                    memoryAudience(
                      l10n,
                      post.visibility,
                      controller.familySize,
                    ),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: AppColors.resolve(context, kColorTextTertiary9C928A),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
