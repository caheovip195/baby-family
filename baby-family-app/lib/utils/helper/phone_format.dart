import 'package:flutter/services.dart';

/// Định dạng số điện thoại Việt Nam (bỏ mã quốc gia, bỏ số 0 đầu) thành nhóm
/// 3-3-3: `912345678` → `912 345 678` (AUTH-02, AUTH-03).
String formatLocalPhone(String digits) {
  final clean = digits.replaceAll(RegExp(r'\D'), '');
  final buffer = StringBuffer();
  for (var i = 0; i < clean.length; i++) {
    if (i > 0 && i % 3 == 0) {
      buffer.write(' ');
    }
    buffer.write(clean[i]);
  }
  return buffer.toString();
}

/// Chỉ giữ chữ số và chuẩn hoá: bỏ số 0 đầu (BR AUTH-02 “bỏ 0 đầu”).
String normalizeLocalPhone(String input) =>
    input.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp('^0+'), '');

/// Bộ định dạng ô nhập: giữ tối đa [maxDigits] chữ số, nhóm 3-3-3.
class PhoneGroupFormatter extends TextInputFormatter {
  const PhoneGroupFormatter({this.maxDigits = 10});

  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }
    final text = formatLocalPhone(digits);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
