import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Gợi ý trang sau của bản tổng kết dạng story (REC-02 `HkNUa`, REC-03
/// `nIUM4`): “1 / 6” 12/700 `text-tertiary` + “[label] ›” 13/600
/// `text-secondary`; đệm đáy 24 + vùng an toàn.
class RecapNextHint extends StatelessWidget {
  const RecapNextHint({
    required this.pageCount,
    required this.label,
    this.onTap,
    super.key,
  });

  final int pageCount;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s2,
        AppSpacing.screen,
        AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        children: [
          Text(
            '1 / $pageCount',
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(
                fontWeight: FontWeight.w700,
                color: kColorTextTertiary9C928A,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 16 / 13,
                    color: secondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.s1),
                Icon(LucideIcons.chevronRight, size: 16, color: secondary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
