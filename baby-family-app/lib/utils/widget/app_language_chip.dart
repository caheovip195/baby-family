import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Chip chọn ngôn ngữ (Pencil LanguageChip `fFQ5S`): cao 40, đệm ngang 12,
/// nền `surface-variant`, icon `globe` 18 + nhãn 13 + `chevron-down` 16, cách 6,
/// tất cả `text-secondary`. Dùng ở ONB-01, AUTH-01.
class AppLanguageChip extends StatelessWidget {
  const AppLanguageChip({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(context, kColorTextSecondary6B625B);
    return Semantics(
      button: true,
      child: Material(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSpacing.s10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.globe, size: 18, color: color),
                  const SizedBox(width: AppSpacing.compact),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(color: color),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.compact),
                  Icon(LucideIcons.chevronDown, size: 16, color: color),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
