import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/data/service/voice_recording.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/helper/video_screening.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/legacy.dart';

/// MEM-24 Thêm góc nhìn của bạn (mỗi Parent 1 góc nhìn/ký ức — BR-071;
/// mở lại sẽ sửa góc nhìn đã có).
final memoryPerspectiveControllerProvider =
    ChangeNotifierProvider.autoDispose<MemoryPerspectiveController>(
      MemoryPerspectiveController.new,
    );

class MemoryPerspectiveController extends BaseNotifier {
  MemoryPerspectiveController(super.ref);

  IMemoryService get memoryService => ref.read(memoryServiceProvider);
  IFamilyService get familyService => ref.read(familyServiceProvider);
  IChildService get childService => ref.read(childServiceProvider);
  IVoiceRecordingService get voiceRecording =>
      ref.read(voiceRecordingServiceProvider);

  final body = TextEditingController();
  bool loaded = false;
  Memory? memory;
  Member? author;
  int people = 0;
  List<String> mediaAssets = [];

  /// MEM-24 ghi âm (BF-20261030-004): bản đã lưu ([voiceUrl]) hoặc bản vừa
  /// thu trên máy ([voicePath]); [voiceRemoved] = bỏ bản đã lưu khi lưu.
  String? voiceUrl;
  String? voicePath;
  int? voiceDurationSec;
  bool voiceRemoved = false;
  bool recording = false;
  bool micDenied = false;

  /// Ảnh tối đa của một góc nhìn (server cũng chặn).
  static const maxMedia = 6;

  /// Thêm ảnh/video vừa chọn (giữ tối đa [maxMedia]); video dài hơn giới
  /// hạn của gói bị bỏ — trả số phút để báo SUB-05 (BF-20261030-007).
  Future<int?> addPicked(List<String> paths) async {
    if (paths.isEmpty) {
      return null;
    }
    final (:accepted, :tooLongMinutes) = await screenPickedMedia(
      familyService,
      memoryService,
      paths,
    );
    if (!isDisposed) {
      addMedia(accepted);
    }
    return tooLongMinutes;
  }

  /// Thêm ảnh vừa chọn (giữ tối đa [maxMedia]).
  void addMedia(List<String> paths) {
    mediaAssets = [
      ...mediaAssets,
      ...paths.where((path) => !mediaAssets.contains(path)),
    ].take(maxMedia).toList();
    notifyListeners();
  }

  void removeMedia(String source) {
    mediaAssets = [...mediaAssets]..remove(source);
    notifyListeners();
  }

  bool get hasVoice => voicePath != null || (voiceUrl != null && !voiceRemoved);

  DateTime get today => childService.today;

  Future<void> init(String memoryId) async {
    final (value, views, members, me) = await (
      memoryService.memory(memoryId),
      memoryService.perspectives(memoryId),
      familyService.members(),
      familyService.me(),
    ).wait;
    if (isDisposed) {
      return;
    }
    memory = value;
    author = members
        .where((member) => member.userId == value?.authorId)
        .firstOrNull;
    people = members.length;
    final mine = views.where((view) => view.authorId == me?.userId).firstOrNull;
    if (mine != null) {
      body.text = mine.body;
      mediaAssets = [...mine.mediaAssets];
      voiceUrl = mine.voiceUrl;
      voiceDurationSec = mine.voiceDurationSec;
    }
    loaded = true;
    notifyListeners();
  }

  /// Bấm mic: bắt đầu → dừng (giữ bản ghi) → bấm lại để bỏ bản ghi.
  Future<void> toggleVoice() async {
    if (recording) {
      final result = await voiceRecording.stop();
      recording = false;
      if (result != null) {
        voicePath = result.path;
        voiceDurationSec = result.durationSec;
      }
    } else if (hasVoice) {
      voicePath = null;
      voiceRemoved = voiceUrl != null;
      voiceDurationSec = null;
    } else {
      micDenied = !await voiceRecording.start();
      recording = !micDenied;
    }
    if (!isDisposed) {
      notifyListeners();
    }
  }

  Future<bool> save() async {
    final value = memory;
    if (value == null) {
      return false;
    }
    if (recording) {
      await toggleVoice();
    }
    final result = await callFuture(
      memoryService.savePerspective(
        value.id,
        body: body.text,
        mediaAssets: mediaAssets,
        voicePath: voicePath,
        voiceDurationSec: voiceDurationSec,
        removeVoice: voiceRemoved && voicePath == null,
      ),
    );
    return !isDisposed && result.isSuccess;
  }

  @override
  void dispose() {
    if (recording) {
      voiceRecording.cancel();
    }
    body.dispose();
    super.dispose();
  }
}
