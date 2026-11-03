import 'package:baby_family/data/dto/realtime_event.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Kênh realtime (Socket.IO, BF-20261101-001): giữ một kết nối tới server
/// trong lúc [connect], tự kết nối lại (lùi dần) với access token mới nhất,
/// làm mới token trước khi hết hạn và phát các sự kiện của server.
abstract class IRealtimeRepository extends IBaseRepository {
  Stream<RealtimeEvent> get events;

  Stream<RealtimeStatus> get statusChanges;

  RealtimeStatus get status;

  /// Bắt đầu / giữ kết nối; đang mất kết nối thì thử lại ngay.
  void connect();

  /// Ngắt hẳn (đăng xuất, app vào nền — để server gửi push).
  void disconnect();

  /// Gửi sự kiện (bỏ qua khi chưa kết nối).
  void emit(String event, JsonMap data);
}
