import 'package:baby_family/data/repository/voice_recorder.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:record/record.dart';

class VoiceRecorderRepositoryImp extends BaseRepositoryImp
    implements IVoiceRecorderRepository {
  final _recorder = AudioRecorder();

  @override
  Future<bool> hasPermission() => _recorder.hasPermission();

  @override
  Future<void> start(String path) => _recorder.start(
    const RecordConfig(numChannels: 1, sampleRate: 44100),
    path: path,
  );

  @override
  Future<String?> stop() => _recorder.stop();

  @override
  Future<void> cancel() => _recorder.cancel();

  @override
  Future<void> dispose() => _recorder.dispose();
}
