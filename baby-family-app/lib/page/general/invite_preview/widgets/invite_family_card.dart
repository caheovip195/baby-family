part of '../mobile/invite_preview_mobile_view.dart';

/// Thẻ gia đình INV-01: nền `surface`, viền `border`, bo 20; bìa 120 (tên gia
/// đình); phần thông tin đệm 16 cách 14: người mời (avatar 44 chữ cái + 2
/// dòng) và ô vai trò (bạn đời: nền `primary-50`; người thân: `secondary-100`).
class _InviteFamilyCard extends StatelessWidget {
  const _InviteFamilyCard({
    required this.invite,
    required this.inviterLine,
    required this.roleLine,
    required this.partner,
  });

  final InviteInfo invite;
  final String inviterLine;
  final String roleLine;
  final bool partner;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final inviterName = invite.inviterName ?? '';
    final message = invite.message;
    final avatarColor = partner && invite.role == FamilyRole.mother
        ? kColorChildPeachFFB59E
        : kColorChildMint9EDCC4;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppFamilyCover(
            name: invite.familyName ?? '',
            height: 120,
            roundBottom: false,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: avatarColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.resolve(
                            context,
                            kColorSurfaceFFFFFF,
                          ),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        inviterName.isEmpty
                            ? ''
                            : inviterName.characters.first.toUpperCase(),
                        style: AppTypography.h3.copyWith(
                          fontWeight: FontWeight.w800,
                          color: kColorTextPrimary2E2A27,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inviterLine,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.label.copyWith(
                                color: kColorTextPrimary2E2A27,
                              ),
                            ),
                          ),
                          if (message != null && message.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              l10n.invQuotedMessage(message),
                              style: AppTypography.adapt(
                                context,
                                AppTypography.caption.copyWith(height: 16 / 13),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.cardInset),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s3,
                    vertical: AppSpacing.itemGap,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.resolve(
                      context,
                      partner
                          ? kColorPrimary50FFF4F1
                          : kColorSecondary100E4F2EA,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        partner ? LucideIcons.userRound : LucideIcons.users,
                        size: 18,
                        color: AppColors.resolve(
                          context,
                          partner
                              ? kColorPrimary600C2513F
                              : kColorSecondary7003F7A5C,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.itemGap),
                      Expanded(
                        child: Text(
                          roleLine,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.text14.copyWith(
                              fontWeight: FontWeight.w600,
                              color: kColorPrimary700A2402F,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
