part of '../mobile/circle_paused_mobile_view.dart';

/// Thẻ tạm dừng (Pencil “Paused card”): nền `surface` viền bo 28 đệm
/// [32,24,24,24] cách 16; vòng 104 `us-50` / 72 `us-100` `pause` 32
/// `us-700`; tiêu đề 22/800 giữa; viên `secondary-100` `shield-check`
/// 16/600; nút “Đóng” (60) và “Rời gia đình” chữ 17/600 `text-secondary`.
class _PausedCard extends StatelessWidget {
  const _PausedCard({
    required this.family,
    required this.onClose,
    required this.onLeave,
  });

  static const _inset = EdgeInsets.symmetric(horizontal: AppSpacing.s4);

  final String family;
  final VoidCallback onClose;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final safe = AppColors.resolve(context, kColorSecondary7003F7A5C);
    return Container(
      // Viên “an toàn” rộng hơn phần đệm 24 của thẻ (Pencil 335 trong thẻ
      // 350): thẻ chỉ đệm 8, các phần khác tự đệm thêm 16.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s2,
        AppSpacing.s8,
        AppSpacing.s2,
        AppSpacing.s6,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.sheet),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 104,
            height: 104,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorUs50F6F2FC),
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorUs100EAE2F8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.pause,
                size: 32,
                color: AppColors.resolve(context, kColorUs7006A549F),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Padding(
            padding: _inset,
            child: Text(
              l10n.cirPausedMessage(family),
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.h2.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 29 / 22,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardInset,
              vertical: AppSpacing.s2,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSecondary100E4F2EA),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.shieldCheck, size: 20, color: safe),
                const SizedBox(width: AppSpacing.s2),
                Flexible(
                  child: Text(
                    l10n.cirPausedSafe,
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.title16.copyWith(
                        fontFamily: AppTypography.bodyFamily,
                        fontWeight: FontWeight.w600,
                        color: safe,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s4 + AppSpacing.itemGap),
          Padding(
            padding: _inset,
            child: Column(
              children: [
                AppButton(
                  label: l10n.commonClose,
                  height: 60,
                  fontSize: 18,
                  onPressed: onClose,
                ),
                const SizedBox(height: AppSpacing.compact),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onLeave,
                    child: Text(
                      l10n.circleLeaveTitle,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
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
