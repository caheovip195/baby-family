import 'package:logger/logger.dart';

/// Đọc danh sách JSON từ server / máy mà một phần tử hỏng (server đổi kiểu
/// field, bản lưu cũ khác định dạng) không làm hỏng cả danh sách: phần tử
/// không đọc được bị bỏ qua và ghi log (BF-20261022-003). Field mới thêm vốn
/// đã được bỏ qua khi đọc.
List<T> lenientList<T>(
  Object? json,
  T Function(Map<String, dynamic> json) parse, {
  String label = 'item',
}) {
  if (json is! List) {
    return <T>[];
  }
  final items = <T>[];
  for (final row in json) {
    if (row is! Map) {
      continue;
    }
    try {
      items.add(parse(Map<String, dynamic>.from(row)));
    } on Object catch (error) {
      Logger().w('Bỏ qua $label không đọc được: $error');
    }
  }
  return items;
}
