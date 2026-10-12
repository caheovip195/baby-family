part of '../mobile/child_profile_mobile_view.dart';

/// Ô thống kê (Pencil “ký ức”…): đệm 12, cách 2, bo 16 viền `border`; icon 16
/// `secondary-700`, số 20/800, nhãn 12 `text-secondary`.
class _ProfileStatTile extends StatelessWidget {
  const _ProfileStatTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.resolve(context, kColorSecondary7003F7A5C),
          ),
          const SizedBox(height: 2),
          Text(
            '$value',
            style: AppTypography.adapt(context, AppTypography.title20),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.adapt(context, AppTypography.small)),
        ],
      ),
    );
  }
}
