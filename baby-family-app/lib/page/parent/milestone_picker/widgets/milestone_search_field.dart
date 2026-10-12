part of '../mobile/milestone_picker_mobile_view.dart';

/// Ô tìm cột mốc (`s6znXh`): cao 46, nền `surface`, viền, bo 14, đệm 14;
/// icon `search` 18 `text-tertiary`, cách 10; gợi ý 14 `text-tertiary`.
class _MilestoneSearchField extends StatelessWidget {
  const _MilestoneSearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(
        color: AppColors.resolve(context, kColorBorderEADFD6),
      ),
    );
    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: AppTypography.adapt(context, AppTypography.text14),
      decoration: InputDecoration(
        hintText: context.l10n.memMilestoneSearchHint,
        hintMaxLines: 1,
        hintStyle: AppTypography.text14.copyWith(color: tertiary),
        filled: true,
        fillColor: AppColors.resolve(context, kColorSurfaceFFFFFF),
        isDense: true,
        prefixIcon: Icon(LucideIcons.search, size: 18, color: tertiary),
        prefixIconConstraints: const BoxConstraints(minWidth: 42),
        contentPadding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(
            color: AppColors.resolve(context, kColorPrimary500EE7B67),
          ),
        ),
      ),
    );
  }
}
