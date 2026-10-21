import 'dart:async';

import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/repository/memory_feed.dart';
import 'package:baby_family/data/repository/voice_recorder.dart';
import 'package:baby_family/data/repository_imp/gallery.dart';
import 'package:baby_family/data/repository_imp/local_media_index.dart';
import 'package:baby_family/data/repository_imp/media.dart';
import 'package:baby_family/data/repository_imp/memory.dart';
import 'package:baby_family/data/repository_imp/memory_feed.dart';
import 'package:baby_family/data/repository_imp/memory_library_remote.dart';
import 'package:baby_family/data/repository_imp/voice_recorder.dart';
import 'package:baby_family/data/service/local_media.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/data/service/voice_recording.dart';
import 'package:baby_family/data/service_imp/local_media.dart';
import 'package:baby_family/data/service_imp/memory.dart';
import 'package:baby_family/data/service_imp/memory_library_remote.dart';
import 'package:baby_family/data/service_imp/voice_recording.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final memoryRepositoryProvider = Provider<IMemoryRepository>(
  (ref) => MemoryRepositoryImp(ref.watch(mockStoreProvider)),
);

final voiceRecorderRepositoryProvider = Provider<IVoiceRecorderRepository>((
  ref,
) {
  final recorder = VoiceRecorderRepositoryImp();
  ref.onDispose(recorder.dispose);
  return recorder;
});

/// Ghi âm VOICE: micro thật khi chạy với server, đoạn mẫu ở bản mock.
final voiceRecordingServiceProvider = Provider<IVoiceRecordingService>(
  (ref) => kValueUseRemoteSession
      ? VoiceRecordingServiceImp(
          ref.watch(voiceRecorderRepositoryProvider),
          ref.watch(mediaRepositoryProvider),
        )
      : MockVoiceRecordingService(),
);

final memoryFeedRepositoryProvider = Provider<IMemoryFeedRepository>(
  (ref) => MemoryFeedRepositoryImp(),
);

final mediaRepositoryProvider = Provider<IMediaRepository>(
  (ref) => MediaRepositoryImp(),
);

/// Ưu tiên ảnh/video còn trong thư viện máy (chỉ bản chạy với server).
final localMediaServiceProvider = Provider<ILocalMediaService>(
  (ref) => kValueUseRemoteSession
      ? LocalMediaServiceImp(
          GalleryRepositoryImp(),
          LocalMediaIndexRepositoryImp(),
          ref.watch(appClockProvider),
        )
      : const NoLocalMediaService(),
);

/// Bản mock, hoặc bản gọi server khi chạy với `BABY_FAMILY_API_URL` (đăng ký
/// ức có ảnh, đồng bộ feed).
final memoryServiceProvider = Provider<IMemoryService>(
  (ref) => kValueUseRemoteSession
      ? (MemoryLibraryRemoteServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(memoryRepositoryProvider),
          ref.watch(childRepositoryProvider),
          ref.watch(familyRepositoryProvider),
          ref.watch(memoryFeedRepositoryProvider),
          ref.watch(mediaRepositoryProvider),
          MemoryLibraryRemoteRepositoryImp(),
        )..localMedia = ref.watch(localMediaServiceProvider))
      : MemoryServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(memoryRepositoryProvider),
          ref.watch(childRepositoryProvider),
          ref.watch(familyRepositoryProvider),
        ),
);

/// Ký ức của bé (null = cả nhà), mới nhất trước. Khi còn ký ức đang xử lý ảnh
/// hoặc URL ảnh ký sắp hết hạn, tự đọc lại sau [IMemoryService.refreshDelay]
/// dù màn đứng yên; hẹn giờ huỷ khi provider bị dispose/đọc lại, và provider
/// không còn ai xem thì không tính lại nên việc hỏi server cũng dừng.
final memoriesProvider = FutureProvider.family<List<Memory>, String?>((
  ref,
  childId,
) async {
  ref.watch(mockRevisionProvider);
  final service = ref.watch(memoryServiceProvider);
  final memories = await service.memories(childId: childId);
  final delay = service.refreshDelay();
  if (delay != null && ref.mounted) {
    final timer = Timer(delay, ref.invalidateSelf);
    ref.onDispose(timer.cancel);
  }
  return memories;
});
