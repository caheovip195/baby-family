part of '../mobile/safety_support_mobile_view.dart';

/// Một đường dây (`oaJM6`): đệm dọc 12, cách 12; ô số 52×44 bo 12
/// `surface-variant` (18/800 Nunito); tên 14/700 + gợi ý 12; nút gọi 40 tròn
/// `success` (`phone` 18 trắng).
class _HotlineRow extends StatelessWidget {
  const _HotlineRow({required this.hotline, required this.onCall});

  final SafetyHotline hotline;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
              borderRadius: BorderRadius.circular(AppRadius.tile),
            ),
            child: Text(
              hotline.number,
              style: AppTypography.adapt(
                context,
                AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotline.title,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                ),
                if (hotline.hint != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    hotline.hint!,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(height: 1.4),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Semantics(
            button: true,
            label: l10n.usSafetyCall(hotline.number),
            excludeSemantics: true,
            child: Material(
              color: AppColors.resolve(context, kColorSuccess3E9B6E),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onCall,
                customBorder: const CircleBorder(),
                child: const SizedBox.square(
                  dimension: AppSpacing.s10,
                  child: Icon(LucideIcons.phone, size: 18, color: kColorWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
