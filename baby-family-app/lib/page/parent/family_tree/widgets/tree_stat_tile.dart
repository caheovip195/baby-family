part of '../mobile/family_tree_mobile_view.dart';

/// Ô số liệu (Pencil “This Week” `a5eA7p`: nền `surface` bo 16, đệm 14, số
/// 24/800 `secondary-700`; “My Summary” `R21mBE`: nền `primary-50` bo 14,
/// đệm 12, số 18/800 `primary-700`), nhãn 12 `text-secondary`.
class _TreeStatTile extends StatelessWidget {
  const _TreeStatTile({required this.value, required this.label})
    : _hearts = false;

  const _TreeStatTile.hearts({required this.value, required this.label})
    : _hearts = true;

  final String value;
  final String label;
  final bool _hearts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_hearts ? AppSpacing.s3 : AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(
          context,
          _hearts ? kColorPrimary50FFF4F1 : kColorSurfaceFFFFFF,
        ),
        borderRadius: BorderRadius.circular(
          _hearts ? AppRadius.md : AppRadius.lg,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTypography.adapt(
              context,
              _hearts
                  ? AppTypography.h3.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 25 / 18,
                      color: kColorPrimary700A2402F,
                    )
                  : AppTypography.display.copyWith(
                      fontSize: 24,
                      height: 33 / 24,
                      color: kColorSecondary7003F7A5C,
                    ),
            ),
          ),
          SizedBox(height: _hearts ? 2 : AppSpacing.s1),
          Text(label, style: AppTypography.adapt(context, AppTypography.small)),
        ],
      ),
    );
  }
}
