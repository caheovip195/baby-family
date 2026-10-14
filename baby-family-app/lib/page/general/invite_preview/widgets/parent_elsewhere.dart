part of '../mobile/invite_preview_mobile_view.dart';

/// INV-03 — Đang là Bố/Mẹ ở gia đình khác (Pencil `H663k`): ô nhà 56 + chip
/// “Mama · Nhà Lan”, tiêu đề 24/800, thẻ lời mời (avatar người mời 40), lựa
/// chọn “Tham gia như người thân” (khoá, mờ 0.7) và “Tìm hiểu cách rời gia
/// đình hiện tại” → SET-11; nút “Huỷ”.
class _ParentElsewhere extends StatelessWidget {
  const _ParentElsewhere({
    required this.data,
    required this.onClose,
    this.myRole,
  });

  final InvitePreviewData data;
  final FamilyRole? myRole;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final invite = data.invite;
    final myCallName = data.currentCallName ?? '';
    final inviter = invite.inviterName ?? '';
    final secondary = AppTypography.small.copyWith(height: 1.4);
    Widget initial(String name, Color color, double size, double fontSize) =>
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.resolve(context, color),
            shape: BoxShape.circle,
          ),
          child: Text(
            name.isEmpty ? '' : name.characters.first.toUpperCase(),
            style: AppTypography.title16.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: kColorWhite,
            ),
          ),
        );
    return AppStepScaffold(
      topBar: const AppTopBar(),
      gap: AppSpacing.s4,
      actions: [
        AppButton.secondary(label: l10n.commonCancel, onPressed: onClose),
      ],
      children: [
        Row(
          children: [
            const AppIconBadge(
              icon: LucideIcons.house,
              size: 56,
              iconSize: 26,
              radius: AppRadius.lg,
              color: kColorPrimary50FFF4F1,
              foreground: kColorPrimary600C2513F,
            ),
            const SizedBox(width: AppSpacing.itemGap),
            Flexible(
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.compact,
                  AppSpacing.compact,
                  AppSpacing.s3,
                  AppSpacing.compact,
                ),
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                    color: AppColors.resolve(context, kColorBorderEADFD6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    initial(myCallName, parentAvatarColor(myRole), 28, 10),
                    const SizedBox(width: AppSpacing.s2),
                    Flexible(
                      child: Text(
                        l10n.commonDotJoin(
                          myCallName,
                          data.currentFamilyName ?? '',
                        ),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption.copyWith(
                            height: 16 / 13,
                            fontWeight: FontWeight.w600,
                            color: kColorTextPrimary2E2A27,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.invElsewhereTitle(myCallName),
              style: AppTypography.adapt(
                context,
                AppTypography.h1.copyWith(fontSize: 24, height: 1.2),
              ),
            ),
            const SizedBox(height: AppSpacing.s2),
            Text(
              l10n.invElsewhereBody,
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(
                  height: 1.45,
                  color: kColorTextSecondary6B625B,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              initial(
                inviter,
                parentAvatarColor(invite.role.partnerRole),
                AppSpacing.s10,
                14,
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.invElsewhereInvite(inviter, invite.familyName ?? ''),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.invElsewhereRole(invite.callName ?? ''),
                      style: AppTypography.adapt(context, AppTypography.small),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.resolve(context, kColorBorderEADFD6),
            ),
          ),
          child: Column(
            children: [
              Opacity(
                opacity: 0.7,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s4,
                    vertical: AppSpacing.cardInset,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.resolve(context, kColorBorderEADFD6),
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppIconBadge(
                        icon: LucideIcons.users,
                        size: 32,
                        iconSize: 16,
                        foreground: kColorTextTertiary9C928A,
                      ),
                      const SizedBox(width: AppSpacing.s3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.invElsewhereJoinRelative,
                              style: AppTypography.adapt(
                                context,
                                AppTypography.bodyStrong.copyWith(
                                  height: 19 / 15,
                                  color: kColorTextSecondary6B625B,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              l10n.invElsewhereJoinRelativeHint(inviter),
                              style: AppTypography.adapt(
                                context,
                                secondary.copyWith(
                                  color: kColorTextTertiary9C928A,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s3),
                      Icon(
                        LucideIcons.lock,
                        size: 16,
                        color: AppColors.resolve(
                          context,
                          kColorTextTertiary9C928A,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => context.router.push(const HelpRoute()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s4,
                    vertical: AppSpacing.cardInset,
                  ),
                  child: Row(
                    children: [
                      const AppIconBadge(
                        icon: LucideIcons.lifeBuoy,
                        size: 32,
                        iconSize: 16,
                        color: kColorPrimary50FFF4F1,
                        foreground: kColorPrimary600C2513F,
                      ),
                      const SizedBox(width: AppSpacing.s3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.invElsewhereLeave,
                              style: AppTypography.adapt(
                                context,
                                AppTypography.bodyStrong.copyWith(
                                  height: 19 / 15,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              l10n.invElsewhereLeaveHint,
                              style: AppTypography.adapt(context, secondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s3),
                      Icon(
                        LucideIcons.chevronRight,
                        size: 18,
                        color: AppColors.resolve(
                          context,
                          kColorTextTertiary9C928A,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
