part of '../mobile/delete_account_mobile_view.dart';

/// SET-09b bước 2 — Gia đình. Còn bạn đời (Pencil `mCafo`): bạn đời giữ gia
/// đình, phần Papa & Mama, gợi ý xuất dữ liệu → SET-08. Parent duy nhất
/// (`sA3Ch`): chọn “Mời Parent khác trước” hoặc “Xoá cả gia đình”.
class _FamilyStep extends StatelessWidget {
  /// Tiêu đề thẻ lựa chọn của `sA3Ch` (16 thay vì 18 của component).
  static const _choiceTitleSize = 16.0;

  const _FamilyStep({
    required this.controller,
    required this.info,
    required this.onBack,
  });

  final DeleteAccountController controller;
  final DeleteAccountInfo info;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final partner = info.partnerName;
    const gap = SizedBox(height: AppSpacing.cardInset);
    final children = joinNames(l10n, info.childNames);
    if (info.onlyParent || partner == null) {
      final invite = controller.inviteParentFirst;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepHeading(
            step: l10n.setDelStep(2),
            title: l10n.setDelOnlyTitle,
            subtitle: l10n.setDelOnlySubtitle(info.familyName),
          ),
          gap,
          AppChoiceCard(
            title: l10n.setDelInviteParent,
            description: l10n.setDelInviteParentHint,
            icon: LucideIcons.userPlus,
            iconBackground: kColorSurfaceFFFFFF,
            titleFontSize: _choiceTitleSize,
            selectedBorderColor: kColorPrimary300F7A796,
            selectedBorderWidth: 1,
            selected: invite,
            onTap: () => controller.setInviteParentFirst(true),
          ),
          gap,
          AppChoiceCard(
            title: l10n.setDelDeleteFamily,
            description: l10n.setDelDeleteFamilyHint(
              info.childNames.join(', '),
            ),
            icon: LucideIcons.trash2,
            color: kColorErrorD14B4B,
            iconBackground: kColorSurfaceVariantF7F1EC,
            titleFontSize: _choiceTitleSize,
            selectedBorderColor: kColorPrimary300F7A796,
            selectedBorderWidth: 1,
            selected: !invite,
            onTap: () => controller.setInviteParentFirst(false),
          ),
          gap,
          AppInfoNote(
            icon: LucideIcons.download,
            text: l10n.setDelOnlyExportTip,
            background: kColorSurfaceVariantF7F1EC,
            iconColor: kColorTextSecondary6B625B,
          ),
          gap,
          _StepFooter(
            primaryLabel: invite
                ? l10n.setDelInviteNewParent
                : l10n.commonContinue,
            onPrimary: invite
                ? () => showComingSoonSnackBar(context)
                : controller.next,
            secondaryLabel: l10n.commonBack,
            onSecondary: onBack,
          ),
        ],
      );
    }
    final partnerCallName = info.partnerCallName ?? partner;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepHeading(
          step: l10n.setDelStep(2),
          title: l10n.setDelTitle2(info.familyName),
          subtitle: l10n.setDelSubtitle2(partner),
        ),
        gap,
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  AppInitialAvatar(name: partnerCallName),
                  const SizedBox(width: AppSpacing.s3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.setDelPartnerKeeps(partner, info.familyName),
                          style: AppTypography.adapt(
                            context,
                            AppTypography.title17,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.setDelPartnerRole(partnerCallName),
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.cardInset),
              _BulletList(
                dotColor: kColorSecondary5006FAE8E,
                items: [
                  l10n.setDelPartnerItem1(partner, children),
                  l10n.setDelPartnerItem2,
                  l10n.setDelPartnerItem3(partner),
                ],
              ),
            ],
          ),
        ),
        gap,
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.s4),
          color: kColorUs50F6F2FC,
          borderColor: kColorUs100EAE2F8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.heart,
                    size: 18,
                    color: AppColors.resolve(context, kColorUs7006A549F),
                  ),
                  const SizedBox(width: AppSpacing.itemGap),
                  Expanded(
                    child: Text(
                      l10n.setVisParents,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.body.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.itemGap),
              Text(
                l10n.setDelCoupleData(partner),
                style: AppTypography.adapt(
                  context,
                  AppTypography.caption.copyWith(height: 1.45),
                ),
              ),
            ],
          ),
        ),
        gap,
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          radius: AppRadius.md,
          onTap: () => context.router.push(const MyDataRoute()),
          child: Row(
            children: [
              Icon(
                LucideIcons.download,
                size: 18,
                color: AppColors.resolve(context, kColorPrimary600C2513F),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.setDelExportTip,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.setDelExportTipHint,
                      style: AppTypography.adapt(context, AppTypography.small),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
            ],
          ),
        ),
        gap,
        _StepFooter(
          primaryLabel: l10n.commonContinue,
          onPrimary: controller.next,
          secondaryLabel: l10n.commonBack,
          onSecondary: onBack,
        ),
      ],
    );
  }
}
