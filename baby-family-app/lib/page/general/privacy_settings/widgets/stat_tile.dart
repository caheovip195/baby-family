part of '../mobile/privacy_settings_mobile_view.dart';

/// Lưới số liệu 2 cột (Pencil `A6bXP`): cách 10; ô lẻ cuối giữ nửa chiều rộng.
class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.tiles});

  final List<_StatTile> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < tiles.length; index += 2) ...[
          if (index > 0) const SizedBox(height: AppSpacing.itemGap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: tiles[index]),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: index + 1 < tiles.length
                      ? tiles[index + 1]
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Ô số liệu (Pencil `ieMUP`): nền `surface-variant` bo 12, đệm [10,12] —
/// nhãn 12, số 20/800 Nunito + đơn vị 12 (cách 5, canh đáy).
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.unit,
    this.onTap,
  });

  final String label;
  final int value;
  final String unit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
      borderRadius: BorderRadius.circular(AppRadius.tile),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.itemGap,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.adapt(context, AppTypography.small),
              ),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$value',
                    style: AppTypography.adapt(
                      context,
                      AppTypography.title20.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      unit,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.adapt(context, AppTypography.small),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
