part of '../mobile/relative_detail_mobile_view.dart';

/// Dòng quyền theo bé (Pencil `iHTtD`): đệm [14,16], cách 10 — avatar 36,
/// tên 15/600 + tuổi 12; đang chia sẻ: “Tạm ẩn” 12/600 + segment Xem /
/// Bình luận / Đóng góp; chưa chia sẻ hoặc tạm ẩn: nhãn 12 `text-tertiary` +
/// nút viền “Chia sẻ”.
class _ChildPermissionRow extends StatelessWidget {
  const _ChildPermissionRow({
    required this.child,
    required this.today,
    required this.permission,
    required this.onChanged,
  });

  final Child child;
  final DateTime today;
  final RelativePermission? permission;
  final ValueChanged<RelativePermission?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final due = child.dueDate;
    final birth = child.birthDate;
    final String? subtitle;
    if (child.isPregnancy && due != null) {
      subtitle = l10n.famPregnancyWeekShort(pregnancyWeek(due, today).week);
    } else if (birth != null) {
      subtitle = childAgeText(l10n, birth, today);
    } else {
      subtitle = null;
    }
    final shared =
        permission != null && permission != RelativePermission.hidden;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.cardInset,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ChildAvatar(child: child, size: 36, borderWidth: 0),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.name,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.bodyStrong.copyWith(height: 19 / 15),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              if (shared)
                InkWell(
                  onTap: () => onChanged(RelativePermission.hidden),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s1),
                    child: Text(
                      l10n.famPermHide,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              else ...[
                Flexible(
                  child: Text(
                    permission == RelativePermission.hidden
                        ? l10n.famPermHidden
                        : l10n.famNotShared,
                    textAlign: TextAlign.end,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        color: kColorTextTertiary9C928A,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
                AppPillButton(
                  label: l10n.famShare,
                  onPressed: () => onChanged(RelativePermission.view),
                  outlined: true,
                  height: 25,
                  fontSize: 12,
                  horizontalPadding: AppSpacing.s3,
                  color: kColorTransparent,
                  foreground: kColorPrimary600C2513F,
                  borderColor: kColorPrimary600C2513F,
                ),
              ],
            ],
          ),
          if (shared) ...[
            const SizedBox(height: AppSpacing.itemGap),
            AppPreferenceSegment<RelativePermission>(
              compact: true,
              choices: [
                (RelativePermission.view, l10n.famPermLevelView),
                (RelativePermission.comment, l10n.famPermLevelComment),
                (RelativePermission.contribute, l10n.famPermLevelContribute),
              ],
              selected: permission!,
              onChanged: onChanged,
            ),
          ],
        ],
      ),
    );
  }
}
