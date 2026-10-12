part of '../mobile/private_journal_mobile_view.dart';

/// Thẻ “Chỉ mình bạn đọc được” (Pencil `Z1An1Q`): nền `us-100` bo 16 đệm 14,
/// vòng `surface` 40 (`lock` 20 `us-700`), chữ `us-700` 14/700 + 12.
class _JournalOnlyYouCard extends StatelessWidget {
  const _JournalOnlyYouCard({required this.partnerCallName});

  final String partnerCallName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = AppColors.resolve(context, kColorUs7006A549F);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorUs100EAE2F8),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            ),
            child: Icon(LucideIcons.lock, size: 20, color: color),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.usJournalOnlyYou,
                  style: AppTypography.text14.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.usJournalOnlyYouHint(partnerCallName),
                  style: AppTypography.small.copyWith(
                    height: 17 / 12,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
