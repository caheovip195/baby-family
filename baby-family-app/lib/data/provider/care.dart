import 'package:baby_family/data/dto/care_board.dart';
import 'package:baby_family/data/model/care/family_tree.dart';
import 'package:baby_family/data/model/care/hearts_summary.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/repository/care.dart';
import 'package:baby_family/data/repository/care_remote.dart';
import 'package:baby_family/data/repository_imp/care.dart';
import 'package:baby_family/data/repository_imp/care_remote.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/data/service_imp/care.dart';
import 'package:baby_family/data/service_imp/care_remote.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final careRepositoryProvider = Provider<ICareRepository>(
  (ref) => CareRepositoryImp(ref.watch(mockStoreProvider)),
);

final careRemoteRepositoryProvider = Provider<ICareRemoteRepository>(
  (ref) => CareRemoteRepositoryImp(),
);

/// Bản mock, hoặc bản gọi server khi chạy với `BABY_FAMILY_API_URL` (bảng
/// nhiệm vụ, thư viện, tự thêm, hoàn thành/hoàn tác, đổi, bỏ khỏi hôm nay).
final careServiceProvider = Provider<ICareService>(
  (ref) => kValueUseRemoteSession
      ? CareRemoteServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(careRepositoryProvider),
          ref.watch(childRepositoryProvider),
          ref.watch(familyRepositoryProvider),
          ref.watch(memoryRepositoryProvider),
          ref.watch(usRepositoryProvider),
          ref.watch(careRemoteRepositoryProvider),
          ref.watch(coupleRemoteRepositoryProvider),
          uploader: MediaUploader(ref.watch(mediaRepositoryProvider)),
        )
      : CareServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(careRepositoryProvider),
          ref.watch(childRepositoryProvider),
          ref.watch(familyRepositoryProvider),
          ref.watch(memoryRepositoryProvider),
          ref.watch(usRepositoryProvider),
        ),
);

/// Bảng nhiệm vụ hôm nay theo chủ thể đang chọn (SW-01).
final todayBoardProvider = FutureProvider<CareBoard>((ref) {
  ref.watch(mockRevisionProvider);
  return ref
      .watch(careServiceProvider)
      .board(childId: ref.watch(selectedSubjectProvider));
});

/// Hearts của tôi (BR-018).
final myHeartsProvider = FutureProvider<HeartsSummary>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(careServiceProvider).myHearts();
});

final familyTreeProvider = FutureProvider<FamilyTree>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(careServiceProvider).tree();
});
