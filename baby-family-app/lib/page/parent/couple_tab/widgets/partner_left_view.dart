part of '../mobile/couple_tab_mobile_view.dart';

/// US-00 — Papa & Mama khi bạn đời đã rời (`PARTNER_LEFT`, Pencil `c4QEM`):
/// minh hoạ 350×120 trên `us-100` bo 20, tiêu đề 20/800 + giải thích, thẻ
/// trạng thái “chỉ xem & tải về”, “Khi có đủ hai người” + 4 tính năng (lưới
/// 2×2), dòng riêng tư, nút “Mời bạn đời tham gia” (FAM-02) sát đáy.
class _PartnerLeftView extends StatelessWidget {
  const _PartnerLeftView({required this.controller});

  final CoupleTabController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final familyName = controller.family?.name ?? '';
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final features = [
      (LucideIcons.smile, l10n.quickCheckin, l10n.usPartnerLeftCheckinSub),
      (
        LucideIcons.handHelping,
        l10n.commonRequest,
        l10n.usPartnerLeftRequestSub,
      ),
      (LucideIcons.heart, l10n.commonThanks, l10n.usPartnerLeftThanksSub),
      (LucideIcons.notebookPen, l10n.usJournal, l10n.usPartnerLeftJournalSub),
    ];
    Widget featureRow(int start) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = start; index < start + 2; index++) ...[
            if (index > start) const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: _PartnerLeftFeature(
                icon: features[index].$1,
                title: features[index].$2,
                subtitle: features[index].$3,
              ),
            ),
          ],
        ],
      ),
    );
    final content = <Widget>[
      Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.resolve(context, kColorUs100EAE2F8),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Assets.images.nE2Yk.image(fit: BoxFit.contain),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.usPartnerLeftTitle,
            style: AppTypography.adapt(context, AppTypography.title20),
          ),
          const SizedBox(height: AppSpacing.compact),
          Text(
            l10n.usPartnerLeftBody(controller.leftPartnerCallName, familyName),
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardInset,
          vertical: AppSpacing.s3,
        ),
        decoration: BoxDecoration(
          color: AppColors.resolve(context, kColorSurfaceFFFFFF),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.resolve(context, kColorUs100EAE2F8),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorUs100EAE2F8),
                borderRadius: BorderRadius.circular(AppRadius.tile),
              ),
              child: Icon(LucideIcons.eye, size: 18, color: usDark),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.usPartnerLeftStateTitle(familyName),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: kColorTextPrimary2E2A27,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.usPartnerLeftStateSub,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Text(
        l10n.usPartnerLeftSection,
        style: AppTypography.overline.copyWith(
          fontWeight: FontWeight.w700,
          color: usDark,
        ),
      ),
      featureRow(0),
      featureRow(2),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(LucideIcons.shieldCheck, size: 16, color: usDark),
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: Text(
                l10n.usPartnerLeftPrivacy,
                style: AppTypography.small.copyWith(height: 1.4, color: usDark),
              ),
            ),
          ],
        ),
      ),
    ];
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _CoupleHeader(privacy: l10n.usOnlyParents)),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.s1,
              AppSpacing.screen,
              AppSpacing.screen + MediaQuery.paddingOf(context).bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 0; index < content.length; index++) ...[
                  if (index > 0) const SizedBox(height: AppSpacing.cardInset),
                  content[index],
                ],
                const Spacer(),
                const SizedBox(height: AppSpacing.cardInset),
                AppButton.us(
                  label: l10n.usPartnerLeftInvite,
                  onPressed: () =>
                      context.router.push(const PartnerInviteRoute()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
