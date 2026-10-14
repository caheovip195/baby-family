part of '../mobile/bridge_start_mobile_view.dart';

/// Lưới lựa chọn 2 cột (Pencil “Needs” `xDTjI`): hàng cách 8, cột cách 8, mỗi
/// chip giãn đều (cao 36, `surface` viền `us-100`; đã chọn nền `us-700`).
class _BridgeChipGrid extends StatelessWidget {
  const _BridgeChipGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 0; row < children.length; row += 2) ...[
          if (row > 0) const SizedBox(height: AppSpacing.s2),
          Row(
            children: [
              Expanded(child: children[row]),
              const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: row + 1 < children.length
                    ? children[row + 1]
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
