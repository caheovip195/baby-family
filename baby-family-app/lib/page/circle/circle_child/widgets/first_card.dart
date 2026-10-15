part of '../mobile/circle_child_mobile_view.dart';

/// Một lần đầu (Pencil “Bước đi đầu tiên”): rộng 110, đệm 12, bo 16, nền
/// xoay vòng `accent-100` / `primary-50` / `secondary-100`; vòng trắng 40 với
/// icon 22, tên 16/700, tuổi lúc đó 14 `text-secondary`.
class _CircleFirstCard extends StatelessWidget {
  const _CircleFirstCard({
    required this.memory,
    required this.age,
    required this.index,
    required this.onTap,
  });

  final Memory memory;
  final String age;
  final int index;
  final VoidCallback onTap;

  static const _tones = [
    (kColorAccent100FDF1D6, kColorAccent7009A6A12),
    (kColorPrimary50FFF4F1, kColorPrimary700A2402F),
    (kColorSecondary100E4F2EA, kColorSecondary7003F7A5C),
  ];

  static IconData _iconOf(String? code) => switch (code) {
    'first_step' || 'walk' => LucideIcons.footprints,
    'call_mama' ||
    'call_papa' ||
    'first_word' => LucideIcons.messageCircleHeart,
    'roll_over' || 'sit' || 'crawl' => LucideIcons.baby,
    _ => LucideIcons.star,
  };

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = _tones[index % _tones.length];
    return SizedBox(
      width: 110,
      child: Material(
        color: AppColors.resolve(context, background),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSpacing.s10,
                  height: AppSpacing.s10,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _iconOf(memory.milestoneCode),
                    size: 22,
                    color: AppColors.resolve(context, foreground),
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  memory.milestoneTitle ?? memory.title ?? '',
                  style: AppTypography.adapt(context, AppTypography.title16),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  age,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(
                      color: kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
