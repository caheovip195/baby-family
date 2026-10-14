part of '../mobile/invite_preview_mobile_view.dart';

/// INV-04 — Đã gửi yêu cầu, chờ người mời xác nhận (Pencil `W8mKF`, góc nhìn
/// Papa): khối 220×150 `primary-50` với hai avatar 72 nối bằng đồng hồ cát,
/// tiêu đề 26/800, mô tả 15, 3 bước, ghi chú thông báo; nút “Đóng”.
class _WaitingConfirm extends StatelessWidget {
  const _WaitingConfirm({required this.invite, required this.onClose});

  final InviteInfo invite;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final inviter = invite.inviterName ?? '';
    final myCallName = invite.callName ?? '';
    final ring = AppColors.resolve(context, kColorBgFFFBF7);
    Widget avatar(String name, Color color) => Container(
      width: 72,
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.resolve(context, color),
        shape: BoxShape.circle,
        border: Border.all(color: ring, width: 3),
      ),
      child: Text(
        name.isEmpty ? '' : name.characters.first.toUpperCase(),
        style: AppTypography.h1.copyWith(color: kColorWhite),
      ),
    );
    return AppStepScaffold(
      topPadding: AppSpacing.s6,
      gap: AppSpacing.s4,
      actions: [AppButton(label: l10n.commonClose, onPressed: onClose)],
      children: [
        const Spacer(),
        Center(
          child: Container(
            width: 220,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorPrimary50FFF4F1),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            alignment: Alignment.center,
            child: SizedBox(
              width: 160,
              height: 72,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: avatar(
                      invite.inviterCallName ?? inviter,
                      parentAvatarColor(invite.role.partnerRole),
                    ),
                  ),
                  Positioned(
                    left: 62,
                    top: 18,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.resolve(
                            context,
                            kColorPrimary100FFE3DC,
                          ),
                        ),
                      ),
                      child: Icon(
                        LucideIcons.hourglass,
                        size: 16,
                        color: AppColors.resolve(
                          context,
                          kColorPrimary600C2513F,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 88,
                    child: avatar(myCallName, parentAvatarColor(invite.role)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Text(
          l10n.invWaitingTitle,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(context, AppTypography.h1),
        ),
        Text(
          l10n.invWaitingBody(inviter),
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.body.copyWith(
              height: 1.45,
              color: kColorTextSecondary6B625B,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.s4),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.resolve(context, kColorBorderEADFD6),
            ),
          ),
          child: Column(
            children: [
              _StepMark(
                title: l10n.invWaitingStepJoined(invite.familyName ?? ''),
                subtitle: l10n.invWaitingStepRole(myCallName),
                state: 0,
              ),
              const SizedBox(height: AppSpacing.cardInset),
              _StepMark(
                title: l10n.invWaitingStepConfirm(inviter),
                subtitle: l10n.invWaitingStepConfirmHint(inviter),
                state: 1,
              ),
              const SizedBox(height: AppSpacing.cardInset),
              _StepMark(title: l10n.invWaitingStepTrial, state: 2),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.bell,
              size: 14,
              color: AppColors.resolve(context, kColorTextTertiary9C928A),
            ),
            const SizedBox(width: AppSpacing.s2),
            Flexible(
              child: Text(
                l10n.invWaitingNotice,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
