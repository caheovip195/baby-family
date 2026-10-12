part of '../mobile/family_tree_mobile_view.dart';

/// Cây lớn (Pencil `zPbhW`): ảnh 240, “CẤP 4” 12/700 `secondary-700`, tên
/// cấp 28/800, “Lớn lên từ Hearts của Papa & Mama” 15 `text-secondary`.
class _TreeHero extends StatelessWidget {
  const _TreeHero({required this.level, required this.name});

  final int level;
  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Image.asset(
          Assets.images.zajmr.path,
          width: 240,
          height: 240,
          excludeFromSemantics: true,
        ),
        const SizedBox(height: AppSpacing.compact),
        Text(
          l10n.careTreeLevel(level).toUpperCase(),
          style: AppTypography.adapt(
            context,
            AppTypography.small.copyWith(
              fontWeight: FontWeight.w700,
              color: kColorSecondary7003F7A5C,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.compact),
        Text(
          name,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.display.copyWith(fontSize: 28, height: 38 / 28),
          ),
        ),
        const SizedBox(height: AppSpacing.compact),
        Text(
          l10n.careTreeGrows,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.body.copyWith(
              height: 19 / 15,
              color: kColorTextSecondary6B625B,
            ),
          ),
        ),
      ],
    );
  }
}
