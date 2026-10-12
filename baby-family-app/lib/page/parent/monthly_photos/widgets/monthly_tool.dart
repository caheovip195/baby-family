part of '../mobile/monthly_photos_mobile_view.dart';

/// Nút công cụ (`XTuXn`): cao 44, nền `surface`, viền, bo 14; icon 16
/// `primary-600` + nhãn 13/600. So sánh / Ghép ảnh / Video [1.1] — tính năng
/// chưa có màn trong kế hoạch.
class _MonthlyTool extends StatelessWidget {
  const _MonthlyTool({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: AppSpacing.iconButton),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.resolve(context, kColorPrimary600C2513F),
          ),
          const SizedBox(width: AppSpacing.compact),
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 16 / 13,
                  color: kColorTextPrimary2E2A27,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
