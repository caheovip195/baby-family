import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Sheet nhập một dòng chữ (đặt tên): tiêu đề + ô nhập + nút chính.
/// Trả về chữ đã nhập (đã trim) hoặc null khi đóng / để trống.
/// Dùng ở MEM-03 “Album mới”, MEM-03a “Đổi tên”, MEM-11 “Cột mốc riêng”.
Future<String?> showAppTextInputSheet(
  BuildContext context, {
  required String title,
  required String actionLabel,
  String? hint,
  String? initialValue,
}) => showAppBottomSheet<String>(
  context,
  builder: (_) => AppTextInputSheet(
    title: title,
    actionLabel: actionLabel,
    hint: hint,
    initialValue: initialValue,
  ),
);

/// Nội dung của [showAppTextInputSheet].
class AppTextInputSheet extends HookWidget {
  const AppTextInputSheet({
    required this.title,
    required this.actionLabel,
    this.hint,
    this.initialValue,
    super.key,
  });

  final String title;
  final String actionLabel;
  final String? hint;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialValue);
    void submit() {
      final value = controller.text.trim();
      Navigator.of(context).pop(value.isEmpty ? null : value);
    }

    return AppBottomSheet(
      title: title,
      children: [
        AppTextField(
          controller: controller,
          hint: hint,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => submit(),
        ),
        AppButton(label: actionLabel, onPressed: submit),
      ],
    );
  }
}
