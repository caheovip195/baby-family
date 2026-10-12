part of '../mobile/couple_tab_mobile_view.dart';

/// “Lời cảm ơn gần đây” (Pencil `eeTHR`): tiêu đề 17/700 + “Xem tất cả”
/// (US-06 — chưa có màn); giấy note `accent-100` bo 18/18/18/4, chữ 14/1.45.
class _ThanksNote extends StatelessWidget {
  const _ThanksNote({
    required this.thanks,
    required this.controller,
    required this.onSeeAll,
  });

  final Thanks thanks;
  final CoupleTabController controller;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final author = thanks.fromUserId == controller.myUserId
        ? l10n.usYou
        : controller.partner?.callName ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.usThanksRecent,
                style: AppTypography.adapt(
                  context,
                  AppTypography.title17.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            InkWell(
              onTap: onSeeAll,
              borderRadius: BorderRadius.circular(AppRadius.xs),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
                child: Text(
                  l10n.commonSeeAll,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.resolve(context, kColorUs7006A549F),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorAccent100FDF1D6),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
              bottomLeft: Radius.circular(4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.commonQuoted(thanks.body),
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(height: 1.45),
                ),
              ),
              const SizedBox(height: AppSpacing.compact),
              Text(
                l10n.usThanksByLine(
                  author,
                  relativeTimeText(l10n, thanks.createdAt, controller.now),
                ),
                style: AppTypography.adapt(context, AppTypography.small),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
