import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Bảng nhãn + viên giá trị của Cầu nối (US-08 “So far” `eNo4n`, US-10):
/// nhãn 12 `text-secondary` thẳng cột, giá trị xuống dòng cách 6, hàng cách
/// [rowGap]; [trailing] (bút chì sửa ở US-08) bên phải mỗi hàng.
class BridgeValueTable extends StatelessWidget {
  const BridgeValueTable({
    required this.rows,
    this.rowGap = AppSpacing.s3,
    this.trailing,
    super.key,
  });

  final List<(String, List<Widget>)> rows;
  final double rowGap;
  final Widget Function(int index)? trailing;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        0: const IntrinsicColumnWidth(),
        1: const FlexColumnWidth(),
        if (trailing != null) 2: const IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        for (final (index, (label, values)) in rows.indexed)
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: AppSpacing.s2,
                  top: index == 0 ? 0 : rowGap,
                ),
                child: Text(
                  label,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(height: 1.3),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : rowGap),
                child: Wrap(
                  spacing: AppSpacing.compact,
                  runSpacing: AppSpacing.compact,
                  children: values,
                ),
              ),
              if (trailing != null)
                Padding(
                  padding: EdgeInsets.only(
                    left: AppSpacing.s2,
                    top: index == 0 ? 0 : rowGap,
                  ),
                  child: trailing!(index),
                ),
            ],
          ),
      ],
    );
  }
}
