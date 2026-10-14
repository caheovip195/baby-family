part of '../mobile/safety_support_mobile_view.dart';

/// Khối riêng tư (`u5Vxku`): nền `surface-variant` bo 16, đệm 14, cách 10;
/// mỗi dòng icon 15 + 12 (dòng 1.4) `text-secondary`.
class _SafetyPrivacyCard extends StatelessWidget {
  const _SafetyPrivacyCard({required this.partnerName});

  final String partnerName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = AppColors.resolve(context, kColorTextSecondary6B625B);
    final rows = [
      (LucideIcons.lock, l10n.usSafetyPrivateNote),
      (LucideIcons.bellOff, l10n.usSafetyNoNotify(partnerName)),
      (LucideIcons.eyeOff, l10n.usSafetyNoHistory),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, (icon, text)) in rows.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.itemGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 15, color: color),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Text(
                    text,
                    style: AppTypography.small.copyWith(
                      height: 1.4,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
