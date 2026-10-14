part of '../mobile/circle_me_mobile_view.dart';

/// Dòng trong nhóm “More” (Pencil “Chuyển gia đình”…): đệm 16 cách 14, icon
/// 24, tiêu đề 17/600 (+ dòng phụ 15 `text-secondary`), `chevron-right` 20;
/// kẻ `border` ở đáy trừ dòng cuối.
class _MeLinkRow extends StatelessWidget {
  const _MeLinkRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.color = kColorTextPrimary2E2A27,
    this.last = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = AppColors.resolve(context, color);
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.all(AppSpacing.s4),
        decoration: last
            ? null
            : BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.resolve(context, kColorBorderEADFD6),
                  ),
                ),
              ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: fg),
            const SizedBox(width: AppSpacing.cardInset),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.bodyLarge.copyWith(
                        height: 22 / 17,
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.body.copyWith(
                          height: 19 / 15,
                          color: kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.cardInset),
            Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: AppColors.resolve(context, kColorTextTertiary9C928A),
            ),
          ],
        ),
      ),
    );
  }
}
