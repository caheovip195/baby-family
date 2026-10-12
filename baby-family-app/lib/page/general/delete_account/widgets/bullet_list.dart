part of '../mobile/delete_account_mobile_view.dart';

/// Danh sách gạch đầu dòng (Pencil “Bullets”): chấm 6 màu [dotColor] canh
/// giữa dòng đầu (cao 20), chữ 14 (dòng 1.45) `text-secondary`, cách 8.
class _BulletList extends StatelessWidget {
  const _BulletList({required this.items, required this.dotColor});

  final List<String> items;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, item) in items.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.s2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
                child: Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.resolve(context, dotColor),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Text(
                  item,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(
                      height: 1.45,
                      color: kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
