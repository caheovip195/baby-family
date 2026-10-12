part of '../mobile/pregnancy_journey_mobile_view.dart';

/// PREG-02 Bụng bầu (Pencil `O7BNq`): đệm 16/20/20/20, cách 12 — so sánh,
/// lưới 4 cột theo tuần (ô trống, ô “chụp” tuần này), lời nhắn, nhắc chụp.
class _BumpTab extends StatelessWidget {
  const _BumpTab({required this.controller});

  final PregnancyJourneyController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pregnancyId = controller.child!.id;
    final current = controller.week?.week;
    final weeks = controller.bumpGridWeeks;
    final compare = controller.bumpCompare;
    final rows = <Widget>[];
    for (var start = 0; start < weeks.length; start += 4) {
      rows.add(
        Row(
          children: [
            for (var column = 0; column < 4; column++) ...[
              if (column > 0) const SizedBox(width: AppSpacing.compact),
              Expanded(
                child: start + column < weeks.length
                    ? _BumpTile(
                        week: weeks[start + column],
                        photo: controller.bumpOf(weeks[start + column]),
                        isCurrent: weeks[start + column] == current,
                        onCapture: () => _openComposer(
                          context,
                          pregnancyId,
                          MemoryKind.bump,
                        ),
                        onOpen: (memoryId) => context.router.push(
                          MemoryDetailRoute(memoryId: memoryId),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s4,
        AppSpacing.screen,
        AppSpacing.s5 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        if (compare != null) ...[
          _BumpCompareCard(from: compare.$1, to: compare.$2),
          const SizedBox(height: AppSpacing.s3),
        ],
        for (var index = 0; index < rows.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.compact),
          rows[index],
        ],
        const SizedBox(height: AppSpacing.s3),
        Text(
          l10n.pregnancyBumpKindness,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
          ),
        ),
        const SizedBox(height: AppSpacing.s3),
        Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.cardInset, 1, 8, 1),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: AppColors.resolve(context, kColorBorderEADFD6),
            ),
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.bell,
                size: 16,
                color: AppColors.resolve(context, kColorTextSecondary6B625B),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Text(
                  l10n.pregnancyRemind,
                  style: AppTypography.adapt(context, AppTypography.text14),
                ),
              ),
              AppSwitch(
                value: controller.remindBump,
                onChanged: controller.toggleRemindBump,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
