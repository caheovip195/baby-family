part of '../mobile/pregnancy_journey_mobile_view.dart';

/// “Ai lo mục này?” — Cùng nhau / Của tôi / Nhờ Papa (gửi Lời nhờ).
class _PrepOwnerSheet extends StatelessWidget {
  const _PrepOwnerSheet({
    required this.partnerCallName,
    required this.onSelected,
  });

  final String partnerCallName;
  final ValueChanged<MissionOwnerKind> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget chip(String label, MissionOwnerKind owner) => AppChip(
      label: label,
      onTap: () {
        Navigator.of(context).pop();
        onSelected(owner);
      },
    );
    return AppBottomSheet(
      title: l10n.pregOwnerTitle,
      children: [
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: [
            chip(l10n.careTogether, MissionOwnerKind.together),
            chip(l10n.commonMine, MissionOwnerKind.me),
            chip(l10n.pregOwnerAsk(partnerCallName), MissionOwnerKind.partner),
          ],
        ),
      ],
    );
  }
}
