part of '../mobile/notification_settings_mobile_view.dart';

/// Khoảng giờ yên tĩnh (Pencil `Infec`): đệm [10,16], hai ô cao 44 nền
/// `surface-variant` bo 12 (cách 10) — nhãn “Từ/Đến” 13 + giờ 17/800 Nunito.
class _QuietTimeRange extends StatelessWidget {
  const _QuietTimeRange({
    required this.from,
    required this.to,
    required this.onTap,
  });

  final String from;
  final String to;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget box(String label, String value) => Expanded(
      child: Material(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.tile),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardInset,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption,
                      ),
                    ),
                  ),
                  Text(
                    value,
                    style: AppTypography.adapt(context, AppTypography.title17),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.itemGap,
      ),
      child: Row(
        children: [
          box(l10n.setFrom, from),
          const SizedBox(width: AppSpacing.itemGap),
          box(l10n.setTo, to),
        ],
      ),
    );
  }
}
