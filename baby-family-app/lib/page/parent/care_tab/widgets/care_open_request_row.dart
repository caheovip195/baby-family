part of '../mobile/care_tab_mobile_view.dart';

/// Dòng nhắc lời nhờ đang mở (Pencil `HLVND`): nền `us-50` viền `us-100` bo
/// 14, đệm 10/12, cách 10; `hand-heart` 18 + chữ 12/600 `us-700` +
/// `chevron-right` 16. Chạm → US-04. Lời nhờ không nằm trong tab nhiệm vụ.
class _CareOpenRequestRow extends StatelessWidget {
  const _CareOpenRequestRow({
    required this.request,
    required this.count,
    required this.fromPartner,
    required this.partnerCallName,
    required this.onTap,
  });

  final CoupleRequest request;
  final int count;
  final bool fromPartner;
  final String partnerCallName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = AppColors.resolve(context, kColorUs7006A549F);
    final text = fromPartner
        ? l10n.careOpenRequestFromPartner(count, partnerCallName, request.title)
        : l10n.careOpenRequestToPartner(count, partnerCallName, request.title);
    return Material(
      color: AppColors.resolve(context, kColorUs50F6F2FC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: AppColors.resolve(context, kColorUs100EAE2F8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.itemGap,
          ),
          child: Row(
            children: [
              Icon(LucideIcons.handHeart, size: 18, color: color),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Text(
                  text,
                  style: AppTypography.small.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Icon(LucideIcons.chevronRight, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
