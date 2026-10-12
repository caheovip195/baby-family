import 'package:baby_family/gen/assets.gen.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:flutter/material.dart';

/// Trạng thái lỗi (Pencil STATE-04 `jlZ2q`): minh hoạ `H46gD6` 180, tiêu đề
/// 20/800, mô tả 14 (1.5), nút phụ “Thử lại” (ButtonSecondary `gRWxn`) rộng
/// 200, mã lỗi 12 `text-tertiary`.
/// Mặc định dùng chữ `stateErrorTitle`/`stateErrorDescription`.
class ErrorState extends StatelessWidget {
  const ErrorState({
    this.onRetry,
    this.title,
    this.description,
    this.code,
    super.key,
  });

  final VoidCallback? onRetry;
  final String? title;
  final String? description;

  /// Dòng mã lỗi (“Mã lỗi: MEM-500 · Báo cho hỗ trợ”); null → ẩn.
  final String? code;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.h46gD6.image(
            width: 180,
            height: 180,
            excludeFromSemantics: true,
          ),
          const SizedBox(height: AppSpacing.s3),
          Text(
            title ?? l10n.stateErrorTitle,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(context, AppTypography.title20),
          ),
          const SizedBox(height: AppSpacing.s3),
          Text(
            description ?? l10n.stateErrorDescription,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(fontSize: 14, height: 1.5),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.s8),
            SizedBox(
              width: 200,
              child: AppButton.secondary(
                label: l10n.commonRetry,
                onPressed: onRetry,
              ),
            ),
          ],
          if (code != null) ...[
            const SizedBox(height: AppSpacing.s3),
            Text(
              code!,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
