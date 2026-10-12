part of '../mobile/request_compose_mobile_view.dart';

/// Ô lựa chọn “Bao lâu?”/“Khi nào?” (Pencil `MYnpP`): cao 36 bo 10, chữ
/// 13/600; đang chọn nền `us-700` chữ `on-primary`, còn lại `surface-variant`.
class _RequestOptionBox extends StatelessWidget {
  const _RequestOptionBox({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorUs7006A549F : kColorSurfaceVariantF7F1EC,
        ),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSpacing.chipHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? AppColors.onPrimary(context)
                        : AppColors.resolve(context, kColorTextSecondary6B625B),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
