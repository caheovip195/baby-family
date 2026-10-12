part of '../mobile/memory_perspective_mobile_view.dart';

/// Ô thêm media (`Uyfvk`): 72×72 bo 12 viền `border`; icon 20 + nhãn
/// 11/600 `text-secondary`.
class _MediaTile extends StatelessWidget {
  const _MediaTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(context, kColorTextSecondary6B625B);
    return Container(
      width: 72,
      constraints: const BoxConstraints(minHeight: 72),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: AppSpacing.s1),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.tiny.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
