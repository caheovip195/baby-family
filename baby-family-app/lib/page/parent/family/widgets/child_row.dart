part of '../mobile/family_mobile_view.dart';

/// Dòng bé (Pencil `oA95y`): avatar 44 (viền `surface` 2), tên 15/600, tuổi
/// hoặc “Thai 24 tuần · dự sinh 24/01/2027” 12.
class _ChildRow extends StatelessWidget {
  const _ChildRow({required this.child, required this.today, this.onTap});

  final Child child;
  final DateTime today;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final due = child.dueDate;
    final birth = child.birthDate;
    final String? subtitle;
    if (child.isPregnancy && due != null) {
      subtitle = l10n.famPregnancySubtitle(
        pregnancyWeek(due, today).week,
        due.toFormDate(context.localeName),
      );
    } else if (birth != null) {
      subtitle = childAgeText(l10n, birth, today);
    } else {
      subtitle = null;
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Row(
        children: [
          ChildAvatar(
            child: child,
            borderColor: kColorSurfaceFFFFFF,
            iconSize: 18,
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: AppTypography.adapt(context, AppTypography.bodyStrong),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.adapt(context, AppTypography.small),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
