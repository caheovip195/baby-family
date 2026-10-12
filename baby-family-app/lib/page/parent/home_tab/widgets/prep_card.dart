part of '../mobile/home_tab_mobile_view.dart';

/// “Chuẩn bị đón bé” (Pencil `bKlhj`): thanh 8 (`surface-variant` /
/// `secondary-500`), 2 việc chưa xong của tôi/cùng nhau: ô 22 bo 7 viền 2,
/// tên 14, nhãn người làm 10/700 trên nền `surface-variant`.
class _PrepCard extends StatelessWidget {
  const _PrepCard({required this.controller, required this.onTap});

  final HomeTabController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final prep = controller.prep!;
    String owner(PrepItem item) => switch (item.ownerKind) {
      MissionOwnerKind.together => l10n.careTogether,
      MissionOwnerKind.partner => l10n.carePartnerTab(
        controller.partnerCallName,
      ),
      _ => l10n.commonMine,
    };
    Widget row(PrepItem item) => Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: AppColors.resolve(context, kColorBorderEADFD6),
              width: 2,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: Text(
            item.title,
            style: AppTypography.adapt(context, AppTypography.text14),
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s2,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            owner(item),
            style: AppTypography.adapt(
              context,
              AppTypography.micro.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppProgressBar(
            value: prep.total == 0 ? 0 : prep.done / prep.total,
            trackColor: kColorSurfaceVariantF7F1EC,
          ),
          for (final item in controller.prepPreview) ...[
            const SizedBox(height: AppSpacing.itemGap),
            row(item),
          ],
        ],
      ),
    );
  }
}
