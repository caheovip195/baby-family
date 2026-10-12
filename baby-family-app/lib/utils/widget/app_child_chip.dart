import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Child selection pill with the full-sized photo from the memory designs.
class AppChildChip extends StatelessWidget {
  const AppChildChip({
    required this.label,
    required this.onTap,
    this.avatar,
    this.selected = false,
    super.key,
  });
  final String label;
  final VoidCallback onTap;
  final Widget? avatar;
  final bool selected;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: Material(
      color: AppColors.resolve(
        context,
        selected ? kColorPrimary50FFF4F1 : kColorSurfaceVariantF7F1EC,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        side: selected
            ? BorderSide(
                color: AppColors.resolve(context, kColorPrimary500EE7B67),
              )
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.full),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (avatar != null) ...[
                avatar!,
                const SizedBox(width: AppSpacing.s2),
              ],
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
