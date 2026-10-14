part of '../mobile/bridge_rewrite_mobile_view.dart';

/// Một phiên bản viết lại (`BLeml`): `surface` bo 16, đệm 14, cách 12, viền
/// `us-500` khi chọn / `us-100`; nhãn giọng 11/700 `us-700`; câu 14 (dòng
/// 1.4); radio 22 (chọn: `us-700` + `check` 13 trắng).
class _RewriteVersionCard extends StatelessWidget {
  const _RewriteVersionCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final RewriteOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: BorderSide(
        color: AppColors.resolve(
          context,
          selected ? kColorUs5009B85D1 : kColorUs100EAE2F8,
        ),
      ),
    );
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardInset),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.usBridgeRewriteTone(option.tone.name),
                        style: AppTypography.tiny.copyWith(
                          fontWeight: FontWeight.w700,
                          color: usDark,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.compact),
                      Text(
                        option.text,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.text14.copyWith(height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: selected
                        ? usDark
                        : AppColors.resolve(context, kColorSurfaceFFFFFF),
                    shape: BoxShape.circle,
                    border: selected
                        ? null
                        : Border.all(
                            color: AppColors.resolve(
                              context,
                              kColorUs100EAE2F8,
                            ),
                          ),
                  ),
                  child: selected
                      ? Icon(
                          LucideIcons.check,
                          size: 13,
                          color: AppColors.onPrimary(context),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
