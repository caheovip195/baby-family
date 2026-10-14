import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// SUB-06 — banner trạng thái gói trên HOME-01 (Pencil `Fxgro` “Plan
/// Banner”, thanh toán gia hạn chưa thành công): nền `primary-50`, viền
/// `primary-300`, bo 16, đệm 12/12/12/14; ô icon 36 trắng bo 10 (icon 18
/// `error`), tiêu đề 14/700, mô tả 12 (dòng 1.4), link 13/700 + chevron, nút
/// đóng 24.
class PlanStatusBanner extends StatelessWidget {
  const PlanStatusBanner({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.onClose,
    this.icon = LucideIcons.creditCard,
    super.key,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final VoidCallback? onClose;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final link = AppColors.resolve(context, kColorPrimary600C2513F);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.cardInset,
        AppSpacing.s3,
        AppSpacing.s3,
        AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorPrimary50FFF4F1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorPrimary300F7A796),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.resolve(context, kColorErrorD14B4B),
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: AppSpacing.s1),
                Text(
                  message,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(height: 1.4),
                  ),
                ),
                const SizedBox(height: AppSpacing.s1),
                InkWell(
                  onTap: onAction,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.s1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            actionLabel,
                            style: AppTypography.caption.copyWith(
                              height: 16 / 13,
                              fontWeight: FontWeight.w700,
                              color: link,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s1),
                        Icon(LucideIcons.chevronRight, size: 14, color: link),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: AppSpacing.s3),
            InkResponse(
              onTap: onClose,
              radius: AppSpacing.s5,
              child: Semantics(
                button: true,
                label: context.l10n.commonClose,
                child: SizedBox.square(
                  dimension: AppSpacing.s6,
                  child: Icon(
                    LucideIcons.x,
                    size: 16,
                    color: AppColors.resolve(context, kColorTextTertiary9C928A),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
