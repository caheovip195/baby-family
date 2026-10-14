part of '../mobile/pending_review_mobile_view.dart';

/// Từ chối (Pencil “Reject panel”): nền `primary-50` bo 14 đệm 12 cách 10;
/// “Lý do từ chối (không bắt buộc)” 13/600, lý do mẫu (ô `surface` viền
/// `primary-300` bo 12, `circle-check` khi chọn), lời nhắn cho người đăng
/// 12, nút Huỷ / “Từ chối ảnh” (nền `error`) cao 44.
class _RejectPanel extends StatelessWidget {
  const _RejectPanel({
    required this.authorName,
    required this.controller,
    required this.onReject,
  });

  final String authorName;
  final PendingReviewController controller;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorPrimary50FFF4F1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.memPendingRejectReason,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          for (final reason in controller.rejectReasons) ...[
            const SizedBox(height: AppSpacing.itemGap),
            _ReasonOption(
              label: reason,
              selected: controller.rejectReason == reason,
              onTap: () => controller.selectReason(reason),
            ),
          ],
          const SizedBox(height: AppSpacing.itemGap),
          Text(
            l10n.memPendingRejectHint(authorName),
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(
                height: 17 / 12,
                color: kColorTextSecondary6B625B,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  label: l10n.commonCancel,
                  height: 44,
                  fontSize: 14,
                  color: kColorTextSecondary6B625B,
                  borderColor: kColorBorderEADFD6,
                  onPressed: controller.cancelReject,
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: AppButton(
                  label: l10n.memPendingRejectSend,
                  height: 44,
                  fontSize: 14,
                  color: kColorErrorD14B4B,
                  onPressed: onReject,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Lý do mẫu: ô `surface` bo 12 đệm 12, chữ 14, viền `primary-300` +
/// `circle-check` 18 `primary-600` khi chọn.
class _ReasonOption extends StatelessWidget {
  const _ReasonOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.tile);
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(
          color: AppColors.resolve(
            context,
            selected ? kColorPrimary300F7A796 : kColorBorderEADFD6,
          ),
        ),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s3),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.adapt(context, AppTypography.text14),
                ),
              ),
              if (selected) ...[
                const SizedBox(width: AppSpacing.s2),
                Icon(
                  LucideIcons.circleCheck,
                  size: 18,
                  color: AppColors.resolve(context, kColorPrimary600C2513F),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
