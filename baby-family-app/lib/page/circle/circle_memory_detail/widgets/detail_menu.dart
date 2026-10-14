part of '../mobile/circle_memory_detail_mobile_view.dart';

/// Menu ⋯ của CIR-03 (Pencil “Menu”): thẻ rộng 228 nền `surface` bo 16 đệm
/// 6, ngay dưới nút ⋯; “Báo cáo” (`flag` 20 + 17/600 `error`); tải ảnh: nút
/// “Tải về” khi được phép, không thì ghi chú mờ “Tải ảnh về: bố mẹ chưa bật
/// cho bà”.
Future<void> _showDetailMenu(
  BuildContext context, {
  required bool canDownload,
  required String who,
  required VoidCallback onReport,
  required VoidCallback onDownload,
}) async {
  final l10n = context.l10n;
  final top = MediaQuery.paddingOf(context).top + AppSpacing.s12 + 10;
  VoidCallback? chosen;
  await showDialog<void>(
    context: context,
    barrierColor: kColorTransparent,
    builder: (dialogContext) {
      void pick(VoidCallback action) {
        chosen = action;
        Navigator.of(dialogContext).pop();
      }

      final tertiary = AppColors.resolve(
        dialogContext,
        kColorTextTertiary9C928A,
      );
      final error = AppColors.resolve(dialogContext, kColorErrorD14B4B);
      return Stack(
        children: [
          Positioned(
            top: top,
            right: AppSpacing.s4,
            width: 228,
            child: Material(
              color: AppColors.resolve(dialogContext, kColorSurfaceFFFFFF),
              elevation: 8,
              shadowColor: kColorShadow2E2A27Alpha12,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.compact),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.tile),
                      onTap: () => pick(onReport),
                      child: SizedBox(
                        height: 52,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s3,
                          ),
                          child: Row(
                            children: [
                              Icon(LucideIcons.flag, size: 20, color: error),
                              const SizedBox(width: AppSpacing.s3),
                              Text(
                                l10n.famReport,
                                style: AppTypography.adapt(
                                  dialogContext,
                                  AppTypography.bodyLarge.copyWith(
                                    height: 22 / 17,
                                    fontWeight: FontWeight.w600,
                                    color: error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppColors.resolve(
                              dialogContext,
                              kColorBorderEADFD6,
                            ),
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: canDownload ? () => pick(onDownload) : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s3,
                            vertical: AppSpacing.itemGap,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.download,
                                size: 18,
                                color: canDownload
                                    ? AppColors.resolve(
                                        dialogContext,
                                        kColorTextPrimary2E2A27,
                                      )
                                    : tertiary,
                              ),
                              const SizedBox(width: AppSpacing.itemGap),
                              Expanded(
                                child: Text(
                                  canDownload
                                      ? l10n.memViewerDownload
                                      : l10n.cirDetailDownloadOff(who),
                                  style: AppTypography.adapt(
                                    dialogContext,
                                    canDownload
                                        ? AppTypography.bodyLarge.copyWith(
                                            height: 22 / 17,
                                            fontWeight: FontWeight.w600,
                                          )
                                        : AppTypography.caption.copyWith(
                                            color: kColorTextTertiary9C928A,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
  chosen?.call();
}
