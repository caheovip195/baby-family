part of '../mobile/memory_perspective_mobile_view.dart';

/// Ô thêm media (`Uyfvk`): 72×72 bo 12 viền `border`; icon 20 + nhãn
/// 11/600 `text-secondary`.
class _MediaTile extends StatelessWidget {
  const _MediaTile({
    required this.icon,
    super.key,
    required this.label,
    this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  /// Đang ghi âm (viền + màu `us-700`).
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(
      context,
      active ? kColorUs7006A549F : kColorTextSecondary6B625B,
    );
    final tile = Container(
      width: 72,
      constraints: const BoxConstraints(minHeight: 72),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(
          color: active
              ? color
              : AppColors.resolve(context, kColorBorderEADFD6),
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
    return onTap == null
        ? tile
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.tile),
            child: tile,
          );
  }
}
