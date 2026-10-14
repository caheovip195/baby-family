part of '../mobile/invite_preview_mobile_view.dart';

/// INV-02 — Lời mời không còn hiệu lực (Pencil `YqUOv`): vòng 140
/// `primary-50` + vòng trong 88 (icon `link-2-off` 38), tiêu đề 24/800, mô tả
/// 15, thẻ gợi ý (nhắn người mời / nhập mã mới); “Nhập mã mời khác” → INV-05,
/// “Đóng”.
class _InvalidInvite extends StatelessWidget {
  const _InvalidInvite({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppStepScaffold(
      topBar: const AppTopBar(),
      gap: AppSpacing.s4,
      actionGap: AppSpacing.itemGap,
      actions: [
        AppButton(
          label: l10n.invEnterOtherCode,
          onPressed: () => context.router.push(const InviteCodeRoute()),
        ),
        AppButton.secondary(label: l10n.commonClose, onPressed: onClose),
      ],
      children: [
        const Spacer(),
        Center(
          child: Container(
            width: 140,
            height: 140,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorPrimary50FFF4F1),
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.resolve(context, kColorPrimary100FFE3DC),
                ),
              ),
              child: Icon(
                LucideIcons.link2Off,
                size: 38,
                color: AppColors.resolve(context, kColorPrimary600C2513F),
              ),
            ),
          ),
        ),
        Text(
          l10n.inviteInvalidTitle,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.h1.copyWith(fontSize: 24, height: 33 / 24),
          ),
        ),
        Text(
          l10n.inviteInvalidDescription,
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
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.resolve(context, kColorBorderEADFD6),
            ),
          ),
          child: Column(
            children: [
              AppIconTextRow(
                icon: LucideIcons.messageCircleHeart,
                text: l10n.invInvalidTipMessage,
                iconSize: 18,
                iconColor: kColorPrimary600C2513F,
                textColor: kColorTextSecondary6B625B,
                lineHeight: 1.45,
                gap: AppSpacing.itemGap,
              ),
              const SizedBox(height: AppSpacing.s3),
              AppIconTextRow(
                icon: LucideIcons.keyboard,
                text: l10n.invInvalidTipCode,
                iconSize: 18,
                iconColor: kColorPrimary600C2513F,
                textColor: kColorTextSecondary6B625B,
                lineHeight: 1.45,
                gap: AppSpacing.itemGap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
