import 'dart:io';

import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/repository/voice_recorder.dart';
import 'package:baby_family/data/service/voice_recording.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Ghi bằng micro thật; thời lượng đọc lại từ tệp (server tính lại khi xử lý).
class VoiceRecordingServiceImp implements IVoiceRecordingService {
  VoiceRecordingServiceImp(this._recorder, this._media);

  final IVoiceRecorderRepository _recorder;
  final IMediaRepository _media;

  DateTime? _startedAt;

  @override
  Future<bool> start() async {
    if (!await _recorder.hasPermission()) {
      return false;
    }
    final dir = await getTemporaryDirectory();
    final path = p.join(
      dir.path,
      'voice_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
    await _recorder.start(path);
    _startedAt = DateTime.now();
    return true;
  }

  @override
  Future<({String path, int durationSec})?> stop() async {
    final startedAt = _startedAt;
    _startedAt = null;
    final path = await _recorder.stop();
    if (path == null || !File(path).existsSync()) {
      return null;
    }
    final ms =
        await _media.mediaDurationMs(path) ??
        (startedAt == null
            ? null
            : DateTime.now().difference(startedAt).inMilliseconds);
    final seconds = ((ms ?? 0) / 1000).round();
    return (path: path, durationSec: seconds < 1 ? 1 : seconds);
  }

  @override
  Future<void> cancel() async {
    _startedAt = null;
    await _recorder.cancel();
  }
}

/// Bản mẫu (không có server): “ghi” một đoạn 12 giây, không có tệp.
class MockVoiceRecordingService implements IVoiceRecordingService {
  static const sampleSeconds = 12;

  @override
  Future<bool> start() async => true;

  @override
  Future<({String path, int durationSec})?> stop() async =>
      (path: '', durationSec: sampleSeconds);

  @override
  Future<void> cancel() async {}
}
