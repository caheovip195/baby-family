part of '../mobile/bridge_start_mobile_view.dart';

/// Tóm tắt các bước trước (`eNo4n`): thẻ `surface` viền bo 16, đệm 14, cách
/// 10; “Mình cảm thấy” / “Về chuyện” / “Cần” + viên `us-100`; bút chì 14
/// `text-tertiary` quay lại bước đó.
class _BridgeSoFarCard extends StatelessWidget {
  const _BridgeSoFarCard({required this.controller});

  final BridgeStartController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = controller;
    final rows = <(String, List<Widget>, int)>[
      (
        l10n.usBridgeFeltLabel,
        [
          for (final option in c.selected(c.feelingOptions, c.feelings))
            AppValuePill(label: option.title),
        ],
        1,
      ),
      if (c.topic != null && c.step > 2)
        (l10n.usBridgeAboutLabel, [AppValuePill(label: c.topic!)], 2),
      if (c.step > 3)
        (
          l10n.usBridgeNeedShort,
          [
            for (final option in c.selected(c.needOptions, c.needs))
              AppValuePill(label: option.title),
          ],
          3,
        ),
    ];
    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: BridgeValueTable(
        rowGap: AppSpacing.itemGap,
        rows: [for (final row in rows) (row.$1, row.$2)],
        trailing: (index) => InkResponse(
          onTap: () => c.goTo(rows[index].$3),
          radius: AppSpacing.s4,
          child: Icon(LucideIcons.pencil, size: 14, color: tertiary),
        ),
      ),
    );
  }
}
