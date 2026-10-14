part of '../mobile/pending_invites_mobile_view.dart';

/// Thẻ lời mời (Pencil “Ông nội” đang chờ / “Dì Mai” hết hạn): bo 16, đệm
/// 14, cách 12; avatar chữ 44, tên 15/600 + nhãn trạng thái, mô tả 12;
/// ô ngày (icon `calendar-clock` 14) và các viên hành động 32.
/// Hết hạn: nền `surface-variant`, ô ngày trắng chữ `error`.
class _InviteCard extends StatelessWidget {
  const _InviteCard({
    required this.invite,
    required this.expired,
    required this.description,
    required this.dates,
    required this.onResend,
    required this.onRevoke,
    required this.onRenew,
  });

  final InviteInfo invite;
  final bool expired;
  final String description;
  final String dates;
  final VoidCallback onResend;
  final VoidCallback onRevoke;
  final VoidCallback onRenew;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = invite.callName ?? '';
    final (statusLabel, statusColor, statusForeground) = expired
        ? (
            l10n.famInviteExpiredTag,
            kColorBorderEADFD6,
            kColorTextSecondary6B625B,
          )
        : invite.openedAt == null
        ? (
            l10n.famInviteNotOpened,
            kColorAccent100FDF1D6,
            kColorTextPrimary2E2A27,
          )
        : (
            l10n.famInviteOpened,
            kColorSecondary100E4F2EA,
            kColorSecondary7003F7A5C,
          );
    final dateColor = expired ? kColorErrorD14B4B : kColorTextSecondary6B625B;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(
          context,
          expired ? kColorSurfaceVariantF7F1EC : kColorSurfaceFFFFFF,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppRelativeAvatar(name: name, relation: invite.relation),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.s2,
                      runSpacing: AppSpacing.s1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          name,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.bodyStrong.copyWith(height: 19 / 15),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.resolve(context, statusColor),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            statusLabel,
                            style: AppTypography.adapt(
                              context,
                              AppTypography.tiny.copyWith(
                                fontWeight: FontWeight.w600,
                                color: statusForeground,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
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
          if (dates.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s3),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.itemGap,
                vertical: AppSpacing.s2,
              ),
              decoration: BoxDecoration(
                color: AppColors.resolve(
                  context,
                  expired ? kColorSurfaceFFFFFF : kColorSurfaceVariantF7F1EC,
                ),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.calendarClock,
                    size: 14,
                    color: AppColors.resolve(context, dateColor),
                  ),
                  const SizedBox(width: AppSpacing.s2),
                  Expanded(
                    child: Text(
                      dates,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(color: dateColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s3),
          Wrap(
            spacing: AppSpacing.s2,
            runSpacing: AppSpacing.s2,
            children: expired
                ? [
                    AppPillButton(
                      label: l10n.famInviteRenew,
                      icon: LucideIcons.refreshCw,
                      iconSize: 14,
                      height: 32,
                      outlined: true,
                      color: kColorTransparent,
                      borderColor: kColorPrimary600C2513F,
                      foreground: kColorPrimary600C2513F,
                      onPressed: onRenew,
                    ),
                  ]
                : [
                    AppPillButton(
                      label: l10n.famInviteResend,
                      icon: LucideIcons.send,
                      iconSize: 14,
                      height: 32,
                      outlined: true,
                      color: kColorTransparent,
                      borderColor: kColorPrimary600C2513F,
                      foreground: kColorPrimary600C2513F,
                      onPressed: onResend,
                    ),
                    AppPillButton(
                      label: l10n.famInviteRevoke,
                      icon: LucideIcons.x,
                      iconSize: 14,
                      height: 32,
                      outlined: true,
                      color: kColorTransparent,
                      foreground: kColorErrorD14B4B,
                      onPressed: onRevoke,
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}
