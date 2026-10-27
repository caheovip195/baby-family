part of '../mobile/home_tab_mobile_view.dart';

/// HOME-03 “Trang chủ thai kỳ” (Pencil l2ePul): hero tuần thai, 4 thao tác
/// nhanh, bụng bầu theo tuần, lần đầu của bé, cả hai cùng kể, chuẩn bị đón
/// bé, đặt tên.
class _PregnancyHome extends StatelessWidget {
  const _PregnancyHome({
    required this.controller,
    required this.pregnancy,
    required this.offline,
  });

  final HomeTabController controller;
  final Child pregnancy;
  final bool offline;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final router = context.router;
    void journey(PregnancyTab tab) => router.push(
      PregnancyJourneyRoute(pregnancyId: pregnancy.id, tab: tab.name),
    );
    void compose(MemoryKind kind) => router.push(
      MemoryComposerRoute(kind: kind.name, childId: pregnancy.id),
    );
    final told = controller.bothTellMemory;
    final prep = controller.prep;
    final blocks = <Widget>[
      _PregnancyHero(
        controller: controller,
        pregnancy: pregnancy,
        onTap: () => journey(PregnancyTab.timeline),
      ),
      _quickActions([
        _QuickActionTile(
          icon: LucideIcons.camera,
          label: l10n.pregnancyBumpPhoto,
          pregnancy: true,
          onTap: () => journey(PregnancyTab.bump),
        ),
        _QuickActionTile(
          icon: LucideIcons.scanHeart,
          label: l10n.pregnancyUltrasound,
          pregnancy: true,
          onTap: () => journey(PregnancyTab.ultrasound),
        ),
        _QuickActionTile(
          icon: LucideIcons.mail,
          label: l10n.pregnancyBabyLetter,
          pregnancy: true,
          onTap: () => compose(MemoryKind.letter),
        ),
        _QuickActionTile(
          icon: LucideIcons.star,
          label: l10n.commonMilestone,
          pregnancy: true,
          onTap: () => compose(MemoryKind.milestone),
        ),
      ]),
      SectionHeader.medium(
        title: l10n.pregnancyBumpWeeks,
        actionLabel: l10n.homeCompare,
        onAction: () => journey(PregnancyTab.bump),
      ),
      _BumpRow(controller: controller, onTap: () => journey(PregnancyTab.bump)),
      if (controller.pregnancyFirsts.isNotEmpty) ...[
        SectionHeader.medium(
          title: l10n.pregnancyFirstsFor(pregnancy.name),
          actionLabel: l10n.commonAll,
          onAction: () => router.push(FirstsRoute(childId: pregnancy.id)),
        ),
        _PregnancyFirsts(controller: controller),
      ],
      if (told != null) _BothTellCard(controller: controller, memory: told),
      if (prep != null && prep.total > 0) ...[
        SectionHeader.medium(
          title: l10n.pregnancyPrepareBaby,
          actionLabel: l10n.homeProgressCount(prep.done, prep.total),
          onAction: () => journey(PregnancyTab.prep),
        ),
        _PrepCard(
          controller: controller,
          onTap: () => journey(PregnancyTab.prep),
        ),
      ],
      _NamesCard(
        controller: controller,
        pregnancy: pregnancy,
        onTap: () => router.push(BabyNamesRoute(pregnancyId: pregnancy.id)),
      ),
    ];
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _HomeAppBar(controller: controller),
          if (offline)
            OfflineBanner(
              pendingUploads: controller.pendingSync,
              onRetry: controller.load,
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.load,
              child: ListView(
                padding: _contentPadding(context),
                children: _spaced(blocks, _blockGap),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
