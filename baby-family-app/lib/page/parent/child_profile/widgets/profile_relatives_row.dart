part of '../mobile/child_profile_mobile_view.dart';

/// Dòng người thân thấy bé (Pencil `fU6l8`): đệm 12/16 cách 10; avatar chữ 34
/// chồng -8 (viền `surface` 2), tên 13/600, `chevron-right` 18.
class _ProfileRelativesRow extends StatelessWidget {
  const _ProfileRelativesRow({required this.names, required this.onTap});

  final List<String> names;
  final VoidCallback onTap;

  static const _colors = [
    kColorAccent500F4BF5C,
    kColorPrimary300F7A796,
    kColorUs5009B85D1,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final shown = names.take(_colors.length).toList();
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      child: Row(
        children: [
          if (shown.isNotEmpty) ...[
            SizedBox(
              width: 34 + 26.0 * (shown.length - 1),
              height: 34,
              child: Stack(
                children: [
                  for (final (index, name) in shown.indexed)
                    Positioned(
                      left: 26.0 * index,
                      child: Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.resolve(context, _colors[index]),
                          border: Border.all(
                            color: AppColors.resolve(
                              context,
                              kColorSurfaceFFFFFF,
                            ),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          nameInitials(name),
                          style: AppTypography.title16.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: kColorWhite,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.itemGap),
          ],
          Expanded(
            child: Text(
              names.isEmpty ? l10n.childRelativesNone : names.join(', '),
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: kColorTextPrimary2E2A27,
                ),
              ),
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            size: 18,
            color: AppColors.resolve(context, kColorTextTertiary9C928A),
          ),
        ],
      ),
    );
  }
}
