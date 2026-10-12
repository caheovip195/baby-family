part of '../mobile/memories_tab_mobile_view.dart';

/// Header bé (`jkasW`): avatar 52 viền màu bé, “Haru · 5 tháng 6 ngày”
/// 17/800, số liệu 12 `text-secondary`. Cả nhà → avatar nhà + “Cả nhà”.
class _ChildHeader extends StatelessWidget {
  const _ChildHeader({required this.controller});

  final MemoriesTabController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final child = controller.subject;
    final stats = controller.stats;
    final String title;
    if (child == null) {
      title = l10n.commonAllFamily;
    } else if (child.isPregnancy && child.dueDate != null) {
      title = l10n.commonChildNameAge(
        child.name,
        pregnancyWeekText(l10n, child.dueDate!, controller.today),
      );
    } else if (child.birthDate != null) {
      title = l10n.commonChildNameAge(
        child.name,
        childAgeText(l10n, child.birthDate!, controller.today),
      );
    } else {
      title = child.name;
    }
    return Row(
      children: [
        ChildAvatar(
          child: child,
          size: 52,
          borderColor: child == null ? null : ChildAvatar.colorOf(child),
        ),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.adapt(context, AppTypography.title17),
              ),
              if (stats != null) ...[
                const SizedBox(height: 2),
                Text(
                  l10n.memChildStats(
                    stats.memories,
                    stats.firsts,
                    stats.voices,
                  ),
                  style: AppTypography.adapt(context, AppTypography.small),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
