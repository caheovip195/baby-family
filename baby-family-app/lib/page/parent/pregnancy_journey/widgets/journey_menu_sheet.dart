part of '../mobile/pregnancy_journey_mobile_view.dart';

/// Menu ⋯ của PREG-01 (mục 9.5): Sửa thai kỳ • Lưu trữ • Bé đã chào đời.
class _JourneyMenuSheet extends StatelessWidget {
  const _JourneyMenuSheet({
    required this.onEdit,
    required this.onArchive,
    required this.onBirth,
  });

  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onBirth;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget item(IconData icon, String label, VoidCallback action) => InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () {
        Navigator.of(context).pop();
        action();
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.resolve(context, kColorTextSecondary6B625B),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                label,
                style: AppTypography.adapt(context, AppTypography.body),
              ),
            ),
          ],
        ),
      ),
    );
    return AppBottomSheet(
      gap: AppSpacing.s1,
      children: [
        item(LucideIcons.pencil, l10n.pregMenuEdit, onEdit),
        item(LucideIcons.archive, l10n.pregMenuArchive, onArchive),
        item(LucideIcons.baby, l10n.pregnancyBirth, onBirth),
      ],
    );
  }
}
