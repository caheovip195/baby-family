part of '../mobile/couple_tab_mobile_view.dart';

/// Lối vào (Pencil `odqsn`): Nhật ký riêng • Cầu nối • Tuần của hai ta — ô
/// `surface` bo 16, đệm 14/6, icon 22 `us-700`, nhãn 12/600 giữa → US-07 /
/// US-08 / US-14.
class _CoupleToolTiles extends StatelessWidget {
  const _CoupleToolTiles({
    required this.onJournal,
    required this.onBridge,
    required this.onWeek,
  });

  final VoidCallback onJournal;
  final VoidCallback onBridge;
  final VoidCallback onWeek;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tiles = [
      (LucideIcons.notebookPen, l10n.usJournal, onJournal),
      (LucideIcons.waypoints, l10n.usBridgeShort, onBridge),
      (LucideIcons.chartNoAxesColumn, l10n.usWeekShort, onWeek),
    ];
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < tiles.length; index++) ...[
            if (index > 0) const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: Material(
                color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: tiles[index].$3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.cardInset,
                      horizontal: AppSpacing.compact,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          tiles[index].$1,
                          size: 22,
                          color: AppColors.resolve(context, kColorUs7006A549F),
                        ),
                        const SizedBox(height: AppSpacing.s2),
                        Text(
                          tiles[index].$2,
                          textAlign: TextAlign.center,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small.copyWith(
                              fontWeight: FontWeight.w600,
                              color: kColorTextPrimary2E2A27,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
