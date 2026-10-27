part of '../mobile/mission_history_mobile_view.dart';

/// Dòng việc CARE-08 (đệm 12/14, cách 12): trạng thái 22 (của tôi
/// `circle-check`; không kịp làm vòng `text-tertiary` + `minus`; của bạn đời
/// avatar chữ; cùng nhau 2 avatar chồng), tiêu đề 14/600 + dòng phụ 12
/// `text-tertiary`, bên phải “+5 💗” (chỉ việc của tôi/cùng nhau) hoặc ✓
/// `secondary-700` (bạn đời), avatar bé 24.
class _HistoryEntryRow extends StatelessWidget {
  const _HistoryEntryRow({
    required this.entry,
    required this.controller,
    required this.divider,
  });

  final MissionHistoryEntry entry;
  final MissionHistoryController controller;
  final bool divider;

  Widget _avatar(Member? member, {bool ring = false}) => Container(
    decoration: ring
        ? BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kColorSurfaceFFFFFF, width: 1.5),
          )
        : null,
    child: AppInitialAvatar(
      name: member?.callName ?? '',
      size: 22,
      color: parentAvatarColor(member?.role),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final partner = entry.ownerKind == MissionOwnerKind.partner;
    final together = entry.ownerKind == MissionOwnerKind.together;
    final missed = !entry.done;
    final category = entry.categoryCode == null
        ? null
        : l10n.careCategoryName(entry.categoryCode!);
    final String meta;
    if (partner) {
      meta = l10n.careHistoryPartnerDone(controller.partnerCallName);
    } else if (together) {
      // Việc cùng nhau chưa làm không ghi “đã xong” (BF-20261026-003).
      meta = missed
          ? l10n.careHistoryTogetherMissed(entry.couple ? 'yes' : 'no')
          : l10n.careHistoryTogetherDone(
              entry.couple ? 'yes' : 'no',
              entry.completedTime ?? '',
            );
    } else {
      final head = missed
          ? l10n.careHistoryMissed
          : l10n.careMetaDoneAt(entry.completedTime ?? '');
      meta = category == null ? head : l10n.commonDotJoin(head, category);
    }
    final Widget status;
    if (partner) {
      status = _avatar(controller.partner);
    } else if (together) {
      status = SizedBox(
        width: 35,
        height: 25,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _avatar(controller.me, ring: true),
            Positioned(
              left: 10,
              child: _avatar(controller.partner, ring: true),
            ),
          ],
        ),
      );
    } else if (missed) {
      status = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.resolve(context, kColorTextTertiary9C928A),
            width: 1.5,
          ),
        ),
        child: Icon(
          LucideIcons.minus,
          size: 12,
          color: AppColors.resolve(context, kColorTextTertiary9C928A),
        ),
      );
    } else {
      status = Icon(
        LucideIcons.circleCheck,
        size: 22,
        color: AppColors.resolve(context, kColorTextSecondary6B625B),
      );
    }
    final kid = together || entry.childIds.isEmpty
        ? null
        : controller.child(entry.childIds.first);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: divider
            ? Border(
                bottom: BorderSide(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardInset,
          vertical: AppSpacing.s3,
        ),
        child: Row(
          children: [
            status,
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: missed
                            ? kColorTextSecondary6B625B
                            : kColorTextPrimary2E2A27,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meta,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        color: kColorTextTertiary9C928A,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (partner) ...[
              const SizedBox(width: AppSpacing.s3),
              Icon(
                LucideIcons.check,
                size: 16,
                color: AppColors.resolve(context, kColorSecondary7003F7A5C),
              ),
            ] else if (entry.hearts != null) ...[
              const SizedBox(width: AppSpacing.s3),
              Text(
                l10n.commonHeartsPlus(entry.hearts!),
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
            if (kid != null) ...[
              const SizedBox(width: AppSpacing.s3),
              ChildAvatar(child: kid, size: 24),
            ],
          ],
        ),
      ),
    );
  }
}
