import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Băng ngoại tuyến (Pencil STATE-05 `E07Rt`): nền `text-primary`, đệm
/// 10/20, icon `wifi-off` 16 `bg`, tiêu đề 13/700 `bg`, dòng phụ 12 `border`,
/// “Thử lại” 13/700 `primary-300`. Đặt ngay dưới app bar.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({this.pendingUploads = 0, this.onRetry, super.key});

  /// Số ký ức chờ tải lên.
  final int pendingUploads;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onDark = AppColors.resolve(context, kColorBgFFFBF7);
    return Semantics(
      liveRegion: true,
      child: ColoredBox(
        color: AppColors.resolve(context, kColorTextPrimary2E2A27),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screen,
            vertical: AppSpacing.itemGap,
          ),
          child: Row(
            children: [
              Icon(LucideIcons.wifiOff, size: 16, color: onDark),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.stateOfflineTitle,
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: onDark,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      l10n.stateOfflineSubtitle(pendingUploads),
                      style: AppTypography.small.copyWith(
                        color: AppColors.resolve(context, kColorBorderEADFD6),
                      ),
                    ),
                  ],
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(width: AppSpacing.itemGap),
                InkWell(
                  onTap: onRetry,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s1),
                    child: Text(
                      l10n.commonRetry,
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.resolve(
                          context,
                          kColorPrimary300F7A796,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
