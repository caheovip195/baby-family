part of '../mobile/pregnancy_journey_mobile_view.dart';

/// Thẻ nhóm chuẩn bị (Pencil `NVwYU`): `surface`, viền `border`, bo 16; mỗi
/// dòng đệm 12/14, cách 10, viền dưới — ô tick 22 bo 7, tên 14, nhãn người
/// lo (“Cùng nhau” / “Của tôi” / “Đã nhờ Papa”) hoặc ⋯ khi đã xong.
class _PrepGroupCard extends StatelessWidget {
  const _PrepGroupCard({
    required this.items,
    required this.partnerCallName,
    required this.onToggle,
    required this.onOwner,
  });

  final List<PrepItem> items;
  final String partnerCallName;
  final ValueChanged<PrepItem> onToggle;
  final ValueChanged<PrepItem> onOwner;

  @override
  Widget build(BuildContext context) {
    final border = AppColors.resolve(context, kColorBorderEADFD6);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++)
            DecoratedBox(
              decoration: BoxDecoration(
                border: index < items.length - 1
                    ? Border(bottom: BorderSide(color: border))
                    : null,
              ),
              child: _row(context, items[index]),
            ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, PrepItem item) {
    return InkWell(
      onTap: () => onToggle(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardInset,
          vertical: AppSpacing.s3,
        ),
        child: Row(
          children: [
            Semantics(
              checked: item.done,
              child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: item.done
                      ? AppColors.resolve(context, kColorSecondary5006FAE8E)
                      : null,
                  borderRadius: BorderRadius.circular(7),
                  border: item.done
                      ? null
                      : Border.all(
                          color: AppColors.resolve(context, kColorBorderEADFD6),
                          width: 2,
                        ),
                ),
                child: item.done
                    ? Icon(
                        LucideIcons.check,
                        size: 14,
                        color: AppColors.onPrimary(context),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: Text(
                item.title,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(
                    color: item.done
                        ? kColorTextTertiary9C928A
                        : kColorTextPrimary2E2A27,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            if (item.done)
              InkResponse(
                onTap: () => onOwner(item),
                radius: 20,
                child: SizedBox.square(
                  dimension: 28,
                  child: Icon(
                    LucideIcons.ellipsis,
                    size: 16,
                    color: AppColors.resolve(context, kColorTextTertiary9C928A),
                  ),
                ),
              )
            else
              _tag(context, item),
          ],
        ),
      ),
    );
  }

  Widget _tag(BuildContext context, PrepItem item) {
    final l10n = context.l10n;
    final requested = item.requestedFromPartner;
    final label = requested
        ? l10n.pregOwnerRequested(partnerCallName)
        : switch (item.ownerKind) {
            MissionOwnerKind.together => l10n.careTogether,
            MissionOwnerKind.partner => l10n.carePartnerTab(partnerCallName),
            _ => l10n.commonMine,
          };
    final foreground = requested
        ? kColorUs7006A549F
        : kColorTextSecondary6B625B;
    return Material(
      color: AppColors.resolve(
        context,
        requested ? kColorUs100EAE2F8 : kColorSurfaceVariantF7F1EC,
      ),
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => onOwner(item),
        child: Container(
          constraints: const BoxConstraints(minHeight: 26),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.itemGap),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (requested) ...[
                Icon(
                  LucideIcons.handHeart,
                  size: 11,
                  color: AppColors.resolve(context, foreground),
                ),
                const SizedBox(width: AppSpacing.s1),
              ],
              Text(
                label,
                style: AppTypography.adapt(
                  context,
                  AppTypography.tiny.copyWith(
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
