part of '../mobile/firsts_mobile_view.dart';

/// Thẻ cột mốc: bo 14, viền. Đã có → ảnh vuông + tên 13/700 + “03/09 ·
/// 4 tháng 2 ngày” 11; chưa có → nền `surface-variant`, sao 22
/// `text-tertiary`, tên + “Chạm để ghi lại”.
class _FirstCard extends StatelessWidget {
  const _FirstCard({
    required this.item,
    required this.controller,
    required this.onTap,
  });

  final MilestoneItem item;
  final FirstsController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final at = item.achievedAt;
    final asset = item.asset;
    final birth = controller.child?.birthDate;
    final achieved = at != null;
    final meta = at == null
        ? l10n.memFirstsAdd
        : birth == null
        ? at.toDayMonth(context.localeName)
        : l10n.memFirstMeta(
            at.toDayMonth(context.localeName),
            childAgeText(l10n, birth, at),
          );
    return Material(
      color: AppColors.resolve(
        context,
        achieved ? kColorSurfaceFFFFFF : kColorSurfaceVariantF7F1EC,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: AppColors.resolve(
            context,
            achieved ? kColorAccent500F4BF5C : kColorBorderEADFD6,
          ),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: asset != null
                  ? Image.asset(asset, fit: BoxFit.cover)
                  : Center(
                      child: Icon(
                        LucideIcons.star,
                        size: 22,
                        color: AppColors.resolve(
                          context,
                          achieved
                              ? kColorAccent500F4BF5C
                              : kColorTextTertiary9C928A,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.itemGap,
                AppSpacing.s2,
                AppSpacing.itemGap,
                AppSpacing.itemGap,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 16 / 13,
                        color: achieved
                            ? kColorTextPrimary2E2A27
                            : kColorTextSecondary6B625B,
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    meta,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.tiny.copyWith(
                        color: kColorTextSecondary6B625B,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
