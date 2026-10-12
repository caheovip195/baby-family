part of '../mobile/home_tab_mobile_view.dart';

/// Cây gia đình thu nhỏ (Pencil `ahws4`): nền `secondary-100`, bo 16, đệm 14;
/// icon `tree-deciduous` 24 trên nền tròn 44 `surface`; “Cây xanh · 97% tới
/// Cây trổ hoa 🌸” 13/700 `secondary-700`; thanh 8 nền `surface`.
class _TreeMiniCard extends StatelessWidget {
  const _TreeMiniCard({required this.tree});

  final FamilyTree tree;

  @override
  Widget build(BuildContext context) {
    final strong = AppColors.resolve(context, kColorSecondary7003F7A5C);
    final next = tree.nextName;
    return AppCard(
      color: kColorSecondary100E4F2EA,
      borderColor: null,
      onTap: () => context.router.push(const FamilyTreeRoute()),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.treeDeciduous, size: 24, color: strong),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  next == null
                      ? tree.name
                      : context.l10n.homeTreeProgress(
                          tree.name,
                          tree.progressPercent,
                          next,
                        ),
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: strong,
                  ),
                ),
                const SizedBox(height: AppSpacing.compact),
                AppProgressBar(
                  value: tree.progressPercent / 100,
                  trackColor: kColorSurfaceFFFFFF,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
