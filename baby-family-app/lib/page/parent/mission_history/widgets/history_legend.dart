part of '../mobile/mission_history_mobile_view.dart';

/// Chú thích (Pencil `AbJu7`): icon 14 + chữ 12 `text-secondary`, cách 14.
class _HistoryLegend extends StatelessWidget {
  const _HistoryLegend({required this.partnerCallName});

  final String partnerCallName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = AppColors.resolve(context, kColorTextSecondary6B625B);
    final style = AppTypography.adapt(context, AppTypography.small);
    return Wrap(
      spacing: AppSpacing.cardInset,
      runSpacing: AppSpacing.s1,
      children: [
        for (final (icon, label) in [
          (LucideIcons.circleCheck, l10n.careHistoryLegendMine),
          (LucideIcons.users, l10n.careTogether),
          (LucideIcons.check, l10n.careHistoryLegendPartner(partnerCallName)),
        ])
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 5),
              Text(label, style: style),
            ],
          ),
      ],
    );
  }
}
