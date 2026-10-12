part of '../mobile/mission_create_mobile_view.dart';

/// Ô “Việc gì?” (Pencil `ixGYZ`): cao 56, nền `surface`, viền `primary-500`,
/// bo 14, đệm ngang 16; icon 22 `primary-600`, chữ 17/600, link “Thư viện”
/// 13/600 `primary-600` (mở CARE-04).
class _CreateTitleField extends StatelessWidget {
  const _CreateTitleField({
    required this.controller,
    required this.icon,
    required this.onChanged,
    required this.onLibrary,
  });

  final TextEditingController controller;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final VoidCallback onLibrary;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.resolve(context, kColorPrimary600C2513F);
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.only(left: AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.resolve(context, kColorPrimary500EE7B67),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: primary),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTypography.adapt(
                context,
                AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 22 / 17,
                ),
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: context.l10n.careTitleHint,
              ),
            ),
          ),
          TextButton(
            onPressed: onLibrary,
            style: TextButton.styleFrom(
              foregroundColor: primary,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
            ),
            child: Text(
              context.l10n.careLibraryLink,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
