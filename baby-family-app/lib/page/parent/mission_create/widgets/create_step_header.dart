part of '../mobile/mission_create_mobile_view.dart';

/// Tiêu đề bước (Pencil `ahzyg`): số trong vòng 22 `primary-100` (12/700
/// `primary-700`) + nhãn 14/700.
class _CreateStepHeader extends StatelessWidget {
  const _CreateStepHeader({required this.number, required this.label});

  final int number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorPrimary100FFE3DC),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: AppTypography.small.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.resolve(context, kColorPrimary700A2402F),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s2),
        Flexible(
          child: Text(
            label,
            style: AppTypography.adapt(
              context,
              AppTypography.text14.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
