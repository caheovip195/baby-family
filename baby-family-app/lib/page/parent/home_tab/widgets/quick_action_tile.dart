part of '../mobile/home_tab_mobile_view.dart';

/// Ô thao tác nhanh HOME-02/03 (Pencil `mGnRc`): nền `surface`, viền, bo 16,
/// đệm 12/4, cách 6; ô icon 40 bo 12 (`secondary-100` cho bé, `us-100` cho
/// thai kỳ) + icon 20; nhãn 12/600.
class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.pregnancy = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool pregnancy;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s3,
          horizontal: AppSpacing.s1,
        ),
        child: Column(
          children: [
            Container(
              width: AppSpacing.s10,
              height: AppSpacing.s10,
              decoration: BoxDecoration(
                color: AppColors.resolve(
                  context,
                  pregnancy ? kColorUs100EAE2F8 : kColorSecondary100E4F2EA,
                ),
                borderRadius: BorderRadius.circular(AppRadius.tile),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.resolve(
                  context,
                  pregnancy ? kColorUs7006A549F : kColorSecondary7003F7A5C,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.compact),
            // Nhãn một dòng như Pencil; thu nhỏ nhẹ khi chữ dài/cỡ chữ lớn.
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(
                    fontWeight: FontWeight.w600,
                    color: kColorTextPrimary2E2A27,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hàng 4 ô thao tác nhanh cách 10.
Widget _quickActions(List<_QuickActionTile> tiles) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    for (var index = 0; index < tiles.length; index++) ...[
      if (index > 0) const SizedBox(width: AppSpacing.itemGap),
      Expanded(child: tiles[index]),
    ],
  ],
);
