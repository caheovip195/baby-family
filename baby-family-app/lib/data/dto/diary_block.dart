import 'package:baby_family/utils/constants/enum.dart';
import 'package:flutter/widgets.dart';

/// MEM-13: một khối của trang nhật ký — ô nhập riêng ([controller],
/// [focusNode]) kèm định dạng nhẹ (kiểu khối, đậm, nghiêng).
class DiaryBlock {
  const DiaryBlock({
    required this.controller,
    required this.focusNode,
    this.kind = DiaryBlockKind.paragraph,
    this.bold = false,
    this.italic = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final DiaryBlockKind kind;
  final bool bold;
  final bool italic;

  DiaryBlock copyWith({DiaryBlockKind? kind, bool? bold, bool? italic}) =>
      DiaryBlock(
        controller: controller,
        focusNode: focusNode,
        kind: kind ?? this.kind,
        bold: bold ?? this.bold,
        italic: italic ?? this.italic,
      );

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}
