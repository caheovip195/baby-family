part of '../mobile/child_archive_mobile_view.dart';

/// Xoá vĩnh viễn đang khoá (Pencil CHD-05 “Delete locked”): nền
/// `surface-variant` bo 16 đệm 14; `lock` + “Cần lưu trữ ít nhất 7 ngày”
/// 14/600 + giải thích 12; nút viền mờ “Xoá vĩnh viễn” (không bấm được).
class _DeleteLockedBox extends StatelessWidget {
  const _DeleteLockedBox({required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                LucideIcons.lock,
                size: 18,
                color: AppColors.resolve(context, kColorTextSecondary6B625B),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.chdArchiveLockedTitle(
                        kValueChildDeleteAfterArchiveDays,
                      ),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      body,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          height: 17 / 12,
                          color: kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Semantics(
            button: true,
            enabled: false,
            child: Container(
              height: AppSpacing.s12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: AppColors.resolve(context, kColorBorderEADFD6),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.trash2, size: 16, color: tertiary),
                  const SizedBox(width: AppSpacing.compact),
                  Text(
                    l10n.commonDeleteForever,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.label.copyWith(color: tertiary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
