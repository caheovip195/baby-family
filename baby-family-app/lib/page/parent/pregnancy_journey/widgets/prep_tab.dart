part of '../mobile/pregnancy_journey_mobile_view.dart';

/// PREG-04 Chuẩn bị (Pencil `oQDli`): đệm 16/20/24/20, cách 14 — tiến độ,
/// nhóm (nhãn 12/800 + thẻ), nút “Thêm mục”.
class _PrepTab extends StatelessWidget {
  const _PrepTab({required this.controller});

  final PregnancyJourneyController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final prep = controller.prep;
    final items = prep?.items ?? const <PrepItem>[];
    final children = <Widget>[
      _PrepProgressCard(
        done: prep?.done ?? 0,
        total: prep?.total ?? 0,
        daysLeft: controller.daysLeft,
      ),
      for (final group in PrepGroup.values)
        if (items.any((item) => item.group == group)) ...[
          Text(
            _prepGroupLabel(context, group).toUpperCase(),
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
          ),
          _PrepGroupCard(
            items: items.where((item) => item.group == group).toList(),
            partnerCallName: controller.partnerCallName,
            onToggle: (item) => controller.togglePrep(item.id),
            onOwner: (item) => _openOwnerSheet(context, item),
          ),
        ],
      _addButton(context, l10n.pregnancyAddPreparation),
    ];
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s4,
        AppSpacing.screen,
        AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
      ),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.cardInset),
      itemBuilder: (_, index) => children[index],
    );
  }

  Future<void> _openOwnerSheet(BuildContext context, PrepItem item) {
    return showAppBottomSheet<void>(
      context,
      builder: (_) => _PrepOwnerSheet(
        partnerCallName: controller.partnerCallName,
        onSelected: (owner) => controller.setPrepOwner(item.id, owner),
      ),
    );
  }

  Widget _addButton(BuildContext context, String label) {
    return Material(
      color: kColorTransparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: AppColors.resolve(context, kColorBorderEADFD6),
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => showAppBottomSheet<void>(
          context,
          builder: (_) => _AddPrepSheet(controller: controller),
        ),
        child: SizedBox(
          height: AppSpacing.s12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.plus,
                size: 16,
                color: AppColors.resolve(context, kColorPrimary600C2513F),
              ),
              const SizedBox(width: AppSpacing.s2),
              Text(
                label,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: kColorPrimary700A2402F,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _prepGroupLabel(BuildContext context, PrepGroup group) =>
    switch (group) {
      PrepGroup.bag => context.l10n.pregGroupBag,
      PrepGroup.papers => context.l10n.pregGroupPapers,
      PrepGroup.nursery => context.l10n.pregGroupNursery,
      PrepGroup.health => context.l10n.pregGroupHealth,
    };
