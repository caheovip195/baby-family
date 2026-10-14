part of '../mobile/ai_settings_mobile_view.dart';

/// “Dữ liệu gửi đi” (Pencil “Data”): nền `us-50`, bo 16, đệm 16, cách 10;
/// mỗi ý icon 16 `us-700` + chữ 13; link 13/600 `us-700` + chevron.
class _AiDataCard extends StatelessWidget {
  const _AiDataCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final points = [
      (LucideIcons.send, l10n.setAiData1),
      (LucideIcons.lock, l10n.setAiData2),
      (LucideIcons.hand, l10n.setAiData3),
      (LucideIcons.sparkles, l10n.setAiData4),
    ];
    final us = AppColors.resolve(context, kColorUs7006A549F);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorUs50F6F2FC),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (icon, text) in points) ...[
            AppIconTextRow(
              icon: icon,
              text: text,
              iconColor: kColorUs7006A549F,
              gap: AppSpacing.itemGap,
            ),
            const SizedBox(height: AppSpacing.itemGap),
          ],
          InkWell(
            onTap: () => showComingSoonSnackBar(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      l10n.setAiDataLink,
                      style: AppTypography.caption.copyWith(
                        height: 16 / 13,
                        fontWeight: FontWeight.w600,
                        color: us,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s1),
                  Icon(LucideIcons.chevronRight, size: 14, color: us),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
