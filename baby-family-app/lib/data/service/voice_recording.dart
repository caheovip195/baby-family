/// Ghi âm cho ký ức VOICE (MEM-04 “Ghi âm”).
abstract class IVoiceRecordingService {
  /// Bắt đầu ghi; false khi không có quyền micro.
  Future<bool> start();

  /// Dừng; trả tệp + thời lượng (giây, ≥ 1), null khi không ghi được.
  Future<({String path, int durationSec})?> stop();

  /// Bỏ bản đang ghi.
  Future<void> cancel();
}
