import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/bridge_value_table.dart';
import 'package:flutter/material.dart';

/// Thẻ “những gì đã chọn chia sẻ” của Cầu nối (Pencil US-10 `SI3Hy`; US-08
/// bước 5 dùng làm bản xem trước chính xác): nền `surface` viền `us-100` bo
/// 20, đệm 16, cách 12; đầu thẻ avatar 32 + tiêu đề 14/700 + dòng phụ 11
/// `text-tertiary`; mỗi hàng nhãn 12 `text-secondary` + các viên giá trị
/// (nhãn thẳng cột); lời nhắn trong ô `us-50` bo 14 (14, dòng 1.4).
class BridgeShareCard extends StatelessWidget {
  const BridgeShareCard({
    required this.avatar,
    required this.title,
    required this.subtitle,
    required this.rows,
    this.message,
    super.key,
  });

  final Widget avatar;
  final String title;
  final String subtitle;

  /// (nhãn, các viên giá trị) — hàng không có giá trị bị ẩn.
  final List<(String, List<Widget>)> rows;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final visible = rows.where((row) => row.$2.isNotEmpty).toList();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.resolve(context, kColorUs100EAE2F8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              avatar,
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: AppTypography.adapt(context, AppTypography.tiny),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (visible.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s3),
            BridgeValueTable(rows: visible),
          ],
          if (message != null && message!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s3),
            Container(
              padding: const EdgeInsets.all(AppSpacing.s3),
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorUs50F6F2FC),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                context.l10n.commonQuoted(message!.trim()),
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(height: 1.4),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
