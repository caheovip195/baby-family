part of '../mobile/delete_account_mobile_view.dart';

/// SET-09 bước 1 — Tác động (Pencil `fU1MN`): những gì bị xoá, ký ức đã
/// đăng (giữ cho gia đình / xoá), gói dịch vụ, ghi chú bình luận.
class _ImpactStep extends StatelessWidget {
  const _ImpactStep({required this.controller, required this.info});

  final DeleteAccountController controller;
  final DeleteAccountInfo info;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final partner = info.partnerName;
    const gap = SizedBox(height: AppSpacing.cardInset);
    const cardPadding = EdgeInsets.all(AppSpacing.s4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepHeading(
          step: l10n.setDelStep(1),
          title: l10n.setDelTitle1,
          subtitle: l10n.setDelSubtitle1(info.userName),
        ),
        gap,
        AppCard(
          padding: cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardHead(
                icon: LucideIcons.trash2,
                title: l10n.setDelWillDelete,
                background: kColorPrimary50FFF4F1,
                foreground: kColorErrorD14B4B,
              ),
              const SizedBox(height: AppSpacing.s3),
              _BulletList(
                dotColor: kColorTextTertiary9C928A,
                items: [
                  l10n.setDelItemPrivate,
                  if (partner == null)
                    l10n.setDelItemCoupleSolo
                  else
                    l10n.setDelItemCouple(partner),
                  l10n.setDelItemProfile,
                ],
              ),
            ],
          ),
        ),
        gap,
        AppCard(
          padding: cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardHead(
                icon: LucideIcons.images,
                title: l10n.setDelPosted(info.postedMemories),
                background: kColorSecondary100E4F2EA,
                foreground: kColorSecondary7003F7A5C,
              ),
              const SizedBox(height: AppSpacing.s3),
              _KeepOption(
                title: l10n.setDelKeepForFamily,
                hint: l10n.setDelKeepHint,
                selected: controller.keepMemories,
                onTap: () => controller.setKeepMemories(true),
              ),
              const SizedBox(height: AppSpacing.s3),
              _KeepOption(
                title: l10n.setDelDeleteMemories,
                selected: !controller.keepMemories,
                onTap: () => controller.setKeepMemories(false),
              ),
            ],
          ),
        ),
        gap,
        AppCard(
          padding: cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardHead(
                icon: LucideIcons.creditCard,
                title: l10n.setDelSubscription,
                background: kColorAccent100FDF1D6,
                foreground: kColorTextPrimary2E2A27,
              ),
              const SizedBox(height: AppSpacing.itemGap),
              Text(
                l10n.setDelSubscriptionBody,
                style: AppTypography.adapt(
                  context,
                  AppTypography.caption.copyWith(height: 1.45),
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => showComingSoonSnackBar(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          l10n.setDelHowToCancel,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: kColorPrimary600C2513F,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s1),
                      Icon(
                        LucideIcons.externalLink,
                        size: 14,
                        color: AppColors.resolve(
                          context,
                          kColorPrimary600C2513F,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        gap,
        AppInfoNote(
          icon: LucideIcons.messageCircleHeart,
          text: l10n.setDelOthersNote,
          background: kColorSurfaceVariantF7F1EC,
          iconColor: kColorTextSecondary6B625B,
        ),
        gap,
        _StepFooter(
          primaryLabel: l10n.commonContinue,
          onPrimary: controller.next,
          secondaryLabel: l10n.setDelKeepAccount,
          onSecondary: () => context.router.maybePop(),
        ),
      ],
    );
  }
}
