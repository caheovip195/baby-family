part of '../mobile/memory_composer_mobile_view.dart';

/// Chip bé (`Kh7Mn`): cao 40, đệm 4/12/4/4, cách 8, bo tròn; avatar 32 viền
/// `surface`; tên 14/600. Chọn: nền `primary-50` + viền `primary-500`; chưa
/// chọn: nền `surface-variant`. [child] = null → “Cả nhà” (ô `primary-100`
/// + `house` 16 `primary-600`).
class _ComposerKidChip extends StatelessWidget {
  const _ComposerKidChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.child,
  });

  final Child? child;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final value = child;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorPrimary50FFF4F1 : kColorSurfaceVariantF7F1EC,
        ),
        shape: StadiumBorder(
          side: selected
              ? BorderSide(
                  color: AppColors.resolve(context, kColorPrimary500EE7B67),
                )
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s1,
              AppSpacing.s1,
              AppSpacing.s3,
              AppSpacing.s1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value != null)
                  ChildAvatar(
                    child: value,
                    size: 32,
                    borderColor: AppColors.resolve(
                      context,
                      kColorSurfaceFFFFFF,
                    ),
                  )
                else
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.resolve(context, kColorPrimary100FFE3DC),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.house,
                      size: 16,
                      color: AppColors.resolve(context, kColorPrimary600C2513F),
                    ),
                  ),
                const SizedBox(width: AppSpacing.s2),
                Text(
                  label,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
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
