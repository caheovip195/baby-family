part of '../mobile/care_tab_mobile_view.dart';

/// Ghi chú tab Của bạn đời (Pencil `tPoMX`): nền `surface-variant` bo 12, đệm
/// 10/12, `lock` 14 + chữ 12 `text-secondary`.
class _CarePartnerNote extends StatelessWidget {
  const _CarePartnerNote({required this.callName});

  final String callName;

  @override
  Widget build(BuildContext context) {
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.itemGap,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.lock, size: 14, color: secondary),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Text(
              context.l10n.carePartnerNote(callName),
              style: AppTypography.small.copyWith(color: secondary),
            ),
          ),
        ],
      ),
    );
  }
}
