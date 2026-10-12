import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Lựa chọn chia đều (Pencil SET-06 “Segment” `lASVK`/`gthX4`): cao 44, đệm 4,
/// cách 4, nền `surface-variant` bo 14. Ô chọn: nền `surface` bo 10 + bóng
/// nhẹ, chữ 14/700 `text-primary`; ô khác: chữ 14/500 `text-secondary`.
/// [compact] (FAM-04 “Segment” `m2Rufj`): cao 38, đệm 3, bo 12, ô cao 32,
/// chữ 13.
class AppPreferenceSegment<T> extends StatelessWidget {
  const AppPreferenceSegment({
    required this.choices,
    required this.selected,
    required this.onChanged,
    this.compact = false,
    super.key,
  });

  final List<(T, String)> choices;
  final T selected;
  final ValueChanged<T> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: compact ? 38 : 44),
      padding: EdgeInsets.all(compact ? 3 : AppSpacing.s1),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(
          compact ? AppRadius.tile : AppRadius.md,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (var index = 0; index < choices.length; index++) ...[
              if (index > 0) const SizedBox(width: AppSpacing.s1),
              Expanded(child: _choice(context, choices[index])),
            ],
          ],
        ),
      ),
    );
  }

  Widget _choice(BuildContext context, (T, String) choice) {
    final isSelected = choice.$1 == selected;
    return Semantics(
      button: true,
      selected: isSelected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(choice.$1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: BoxConstraints(minHeight: compact ? 32 : 36),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s1,
            vertical: AppSpacing.s1,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.resolve(context, kColorSurfaceFFFFFF)
                : kColorTransparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: isSelected ? AppShadows.segment : null,
          ),
          child: Text(
            choice.$2,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(
              context,
              AppTypography.text14.copyWith(
                fontSize: compact ? 13 : null,
                height: compact ? 16 / 13 : null,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? kColorTextPrimary2E2A27
                    : kColorTextSecondary6B625B,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
