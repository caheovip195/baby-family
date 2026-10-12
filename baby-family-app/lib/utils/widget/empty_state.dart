import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:flutter/material.dart';

/// Trạng thái rỗng (Pencil STATE-02 `fXNoV`): minh hoạ 180, tiêu đề 20/800
/// Nunito căn giữa, mô tả 14 (line-height 1.5) `text-secondary`, cách 12; nút
/// chính rộng 220 cách thêm 8. Đệm ngang 32. Minh hoạ mặc định của ký ức là
/// `assets/images/Zn57N.png`, chăm con `J0ynDJ.png` (150).
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    this.description,
    this.illustration,
    this.illustrationSize = 180,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.spacing = AppSpacing.s3,
    super.key,
  });

  final String title;
  final String? description;

  /// Đường dẫn asset minh hoạ (`Assets.images.zn57N.path`…).
  final String? illustration;
  final double illustrationSize;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  /// Khoảng cách minh hoạ/tiêu đề/mô tả: 12 (STATE-02 `fXNoV`), 8 cho thẻ
  /// rỗng chăm con (STATE-03 `ghZZx`, minh hoạ 150).
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (illustration != null) ...[
            Image.asset(
              illustration!,
              width: illustrationSize,
              height: illustrationSize,
              excludeFromSemantics: true,
            ),
            SizedBox(height: spacing),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(context, AppTypography.title20),
          ),
          if (description != null) ...[
            SizedBox(height: spacing),
            Text(
              description!,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(fontSize: 14, height: 1.5),
              ),
            ),
          ],
          if (actionLabel != null) ...[
            const SizedBox(height: AppSpacing.s8),
            SizedBox(
              width: 220,
              child: AppButton(
                label: actionLabel!,
                icon: actionIcon,
                onPressed: onAction,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
