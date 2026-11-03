import 'package:baby_family/data/repository/base.dart';

/// Một sự kiện server phát qua kênh realtime (`chat.message`, `chat.read`,
/// `chat.typing`, `ready`…, BF-20261101-001). Server chỉ phát tín hiệu nhỏ;
/// nội dung đọc qua REST.
class RealtimeEvent {
  const RealtimeEvent(this.name, [this.data = const {}]);

  final String name;
  final JsonMap data;

  String? text(String key) {
    final value = data[key];
    return value is String && value.isNotEmpty ? value : null;
  }

  int? number(String key) {
    final value = data[key];
    return value is num ? value.toInt() : null;
  }
}
