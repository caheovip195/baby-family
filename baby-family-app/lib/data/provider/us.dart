import 'package:baby_family/data/dto/couple_today.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/couple_remote.dart';
import 'package:baby_family/data/repository/us.dart';
import 'package:baby_family/data/repository_imp/couple_remote.dart';
import 'package:baby_family/data/repository_imp/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/data/service_imp/us.dart';
import 'package:baby_family/data/service_imp/us_remote.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final usRepositoryProvider = Provider<IUsRepository>(
  (ref) => UsRepositoryImp(ref.watch(mockStoreProvider)),
);

final coupleRemoteRepositoryProvider = Provider<ICoupleRemoteRepository>(
  (ref) => CoupleRemoteRepositoryImp(),
);

/// Bản mock, hoặc bản gọi server khi chạy với `BABY_FAMILY_API_URL` (check-in,
/// lời nhờ — phần còn lại của Papa & Mama vẫn trên máy).
final usServiceProvider = Provider<IUsService>(
  (ref) => kValueUseRemoteSession
      ? UsRemoteServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(usRepositoryProvider),
          ref.watch(familyRepositoryProvider),
          ref.watch(careRepositoryProvider),
          ref.watch(coupleRemoteRepositoryProvider),
          uploader: MediaUploader(ref.watch(mediaRepositoryProvider)),
        )
      : UsServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(usRepositoryProvider),
          ref.watch(familyRepositoryProvider),
          ref.watch(careRepositoryProvider),
        ),
);

final coupleTodayProvider = FutureProvider<CoupleToday>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(usServiceProvider).coupleToday();
});
