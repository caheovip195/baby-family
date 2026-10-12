part of '../mobile/milestone_picker_mobile_view.dart';

/// Dòng cột mốc (`xR6Kp`): cao 52, đệm ngang 14, cách 12; ô icon 36 bo 10
/// (màu theo icon), icon 18; tên 15/600 + “Đã ghi · 08/04/2025” 12
/// `text-tertiary`; đã ghi → vòng ✓ 24 `success` và cả dòng mờ 50%, chưa ghi
/// → `chevron-right` 18.
class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({
    required this.option,
    required this.index,
    required this.recordedLabel,
    required this.onTap,
  });

  final MilestoneOption option;
  final int index;
  final String? recordedLabel;
  final VoidCallback onTap;

  static const _tones = [
    (kColorPrimary50FFF4F1, kColorPrimary600C2513F),
    (kColorSecondary100E4F2EA, kColorSecondary7003F7A5C),
    (kColorAccent100FDF1D6, kColorAccent600B7862B),
    (kColorUs50F6F2FC, kColorUs7006A549F),
  ];

  /// Icon catalog (lucide kebab) → icon + tông màu như Pencil MEM-11.
  static (IconData, int) _icon(String? name, int index) => switch (name) {
    'baby' => (LucideIcons.baby, 0),
    'party-popper' => (LucideIcons.partyPopper, 1),
    'sparkles' => (LucideIcons.sparkles, 2),
    'cake' => (LucideIcons.cake, 3),
    'flower-2' => (LucideIcons.flower2, 2),
    'moon-star' => (LucideIcons.moonStar, 3),
    'scissors' => (LucideIcons.scissors, 0),
    'house' => (LucideIcons.house, 1),
    'trees' => (LucideIcons.trees, 0),
    'smile' => (LucideIcons.smile, 2),
    'rotate-ccw' => (LucideIcons.rotateCcw, 1),
    'armchair' => (LucideIcons.armchair, 3),
    'utensils' => (LucideIcons.utensils, 2),
    _ => (LucideIcons.star, index % _tones.length),
  };

  @override
  Widget build(BuildContext context) {
    final (icon, tone) = _icon(option.icon, index);
    final (background, foreground) = _tones[tone];
    final recorded = recordedLabel != null;
    final row = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardInset,
        vertical: AppSpacing.s2,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, background),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.resolve(context, foreground),
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.bodyStrong.copyWith(height: 19 / 15),
                  ),
                ),
                if (recorded) ...[
                  const SizedBox(height: 1),
                  Text(
                    recordedLabel!,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        color: kColorTextTertiary9C928A,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          if (recorded)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorSuccess3E9B6E),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.check,
                size: 14,
                color: kColorWhite,
              ),
            )
          else
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: AppColors.resolve(context, kColorTextTertiary9C928A),
            ),
        ],
      ),
    );
    return Semantics(
      button: true,
      selected: recorded,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: recorded ? Opacity(opacity: .5, child: row) : row,
        ),
      ),
    );
  }
}
