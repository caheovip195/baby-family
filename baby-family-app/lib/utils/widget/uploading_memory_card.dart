import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// MEM-06 — ký ức đang tải nền trên dòng thời gian: ảnh nhỏ + chú thích,
/// thanh tiến độ “Đang tải 3/8 ảnh…”; lỗi → “Tải lên chưa xong” + Thử lại /
/// Huỷ (nội dung vẫn giữ trên máy).
class UploadingMemoryCard extends StatelessWidget {
  const UploadingMemoryCard({
    required this.caption,
    required this.done,
    required this.total,
    required this.failed,
    required this.onRetry,
    required this.onCancel,
    this.photo,
    super.key,
  });

  final String caption;
  final String? photo;
  final int done;
  final int total;
  final bool failed;
  final VoidCallback onRetry;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: SizedBox.square(
                  dimension: 48,
                  child: photo == null || isLocalVideo(photo!)
                      ? ColoredBox(
                          color: AppColors.resolve(context, kColorBorderEADFD6),
                          child: Icon(
                            LucideIcons.image,
                            size: 20,
                            color: secondary,
                          ),
                        )
                      : Image(
                          image: mediaImageProvider(photo!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (caption.isNotEmpty)
                      Text(
                        caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.bodyStrong,
                        ),
                      ),
                    Text(
                      failed
                          ? l10n.memUploadFailed
                          : l10n.memUploadProgress(done, total),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          color: failed
                              ? AppColors.resolve(context, kColorErrorD14B4B)
                              : secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!failed) ...[
            const SizedBox(height: AppSpacing.s3),
            AppProgressBar(value: total == 0 ? 0 : done / total, height: 6),
          ] else ...[
            const SizedBox(height: AppSpacing.s2),
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    label: l10n.memUploadCancel,
                    height: 36,
                    fontSize: 13,
                    onPressed: onCancel,
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: AppButton(
                    label: l10n.memUploadRetry,
                    height: 36,
                    fontSize: 13,
                    onPressed: onRetry,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
