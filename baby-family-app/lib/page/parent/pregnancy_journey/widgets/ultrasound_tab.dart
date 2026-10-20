part of '../mobile/pregnancy_journey_mobile_view.dart';

/// PREG-03 Siêu âm (không có trong Pencil — mục 9.5): lưới 2 cột ảnh siêu âm
/// theo tuần + ô “Thêm ảnh siêu âm”, cùng ngôn ngữ ô ảnh của PREG-02.
class _UltrasoundTab extends StatelessWidget {
  const _UltrasoundTab({required this.controller});

  final PregnancyJourneyController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pregnancyId = controller.child!.id;
    void add() => _openComposer(context, pregnancyId, MemoryKind.ultrasound);
    final items = controller.ultrasounds;
    if (items.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: EmptyState(
            title: l10n.pregUltrasoundEmpty,
            description: l10n.pregUltrasoundEmptyHint,
            illustration: Assets.images.zn57N.path,
            actionLabel: l10n.pregUltrasoundAdd,
            actionIcon: LucideIcons.plus,
            onAction: add,
          ),
        ),
      );
    }
    final tiles = <Widget>[
      _addTile(context, add),
      for (final memory in items) _photoTile(context, memory),
    ];
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.s2,
      crossAxisSpacing: AppSpacing.s2,
      childAspectRatio: 159 / 170,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s4,
        AppSpacing.screen,
        AppSpacing.s5 + MediaQuery.paddingOf(context).bottom,
      ),
      children: tiles,
    );
  }

  Widget _photoTile(BuildContext context, Memory memory) {
    final asset = memory.mediaAssets.firstOrNull;
    return GestureDetector(
      onTap: () => context.router.push(MemoryDetailRoute(memoryId: memory.id)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.tile),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (asset != null)
              Image(
                image: mediaImageProvider(asset),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            Positioned(
              left: AppSpacing.compact,
              bottom: AppSpacing.compact,
              child: _PhotoWeekLabel(
                text: context.l10n.commonPregnancyWeekOnly(
                  memory.pregnancyWeek ?? 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addTile(BuildContext context, VoidCallback onTap) {
    return Material(
      color: AppColors.resolve(context, kColorUs50F6F2FC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.tile),
        side: BorderSide(color: AppColors.resolve(context, kColorUs5009B85D1)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.tile),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.camera,
                size: 22,
                color: AppColors.resolve(context, kColorUs7006A549F),
              ),
              const SizedBox(height: AppSpacing.s1),
              Text(
                context.l10n.pregUltrasoundAdd,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(
                    fontWeight: FontWeight.w600,
                    color: kColorUs7006A549F,
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
