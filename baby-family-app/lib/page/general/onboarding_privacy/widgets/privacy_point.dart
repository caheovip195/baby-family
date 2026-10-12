part of '../mobile/onboarding_privacy_mobile_view.dart';

/// Điểm cam kết: ô icon 44 bo 14 (icon 22), cách 14; tiêu đề 16/700 Nunito,
/// mô tả 14 (line-height 1.45) `text-secondary`, cách 4.
class _PrivacyPoint extends StatelessWidget {
  const _PrivacyPoint({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.resolve(context, background),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(icon, size: 22, color: AppColors.resolve(context, color)),
      ),
      const SizedBox(width: AppSpacing.cardInset),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.adapt(
                context,
                AppTypography.title16.copyWith(height: 22 / 16),
              ),
            ),
            const SizedBox(height: AppSpacing.s1),
            Text(
              description,
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(
                  height: 1.45,
                  color: kColorTextSecondary6B625B,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
