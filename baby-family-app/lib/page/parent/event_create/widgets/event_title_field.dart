part of '../mobile/event_create_mobile_view.dart';

/// Ô tiêu đề (Pencil `A23s92`): cao 56, đệm ngang 16, nền `surface` bo 14 viền
/// `primary-500` 2; icon 22 `primary-600`, chữ 17/600.
class _EventTitleField extends StatelessWidget {
  const _EventTitleField({
    required this.controller,
    required this.icon,
    required this.onChanged,
  });

  final TextEditingController controller;
  final IconData icon;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.resolve(context, kColorPrimary500EE7B67),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: AppColors.resolve(context, kColorPrimary600C2513F),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTypography.adapt(
                context,
                AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
              cursorColor: AppColors.resolve(context, kColorPrimary600C2513F),
              decoration: const InputDecoration(
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
