part of '../mobile/request_detail_mobile_view.dart';

/// Chip thông tin lời nhờ (Pencil `GD6lY`/`HkF9Z`): cao 32 nền
/// `surface-variant` bo tròn, ảnh bé 26 hoặc icon 14 + chữ 12/600.
class _RequestInfoChip extends StatelessWidget {
  const _RequestInfoChip({required this.label, this.icon, this.child});

  final String label;
  final IconData? icon;
  final Child? child;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(context, kColorTextSecondary6B625B);
    final baby = child;
    return Container(
      constraints: const BoxConstraints(minHeight: 32),
      padding: EdgeInsets.only(
        left: baby != null ? 3 : AppSpacing.itemGap,
        right: AppSpacing.itemGap,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (baby != null)
            ChildAvatar(child: baby, size: 26, borderWidth: 0)
          else if (icon != null)
            Icon(icon, size: 14, color: color),
          const SizedBox(width: AppSpacing.compact),
          Flexible(
            child: Text(
              label,
              style: AppTypography.small.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
