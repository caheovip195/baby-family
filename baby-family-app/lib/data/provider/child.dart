import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/subject.dart';
import 'package:baby_family/data/repository_imp/child.dart';
import 'package:baby_family/data/repository_imp/pregnancy_remote.dart';
import 'package:baby_family/data/repository_imp/subject.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service_imp/child.dart';
import 'package:baby_family/data/service_imp/child_remote.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final childRepositoryProvider = Provider<IChildRepository>(
  (ref) => ChildRepositoryImp(ref.watch(mockStoreProvider)),
);

final subjectRepositoryProvider = Provider<ISubjectRepository>(
  (ref) => SubjectRepositoryImp(),
);

/// Bản mock, hoặc bản gọi server khi chạy với `BABY_FAMILY_API_URL` (tạo/sửa
/// bé, thai kỳ qua API rồi phản chiếu vào kho trên máy).
final childServiceProvider = Provider<IChildService>(
  (ref) => kValueUseRemoteSession
      ? ChildRemoteServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(childRepositoryProvider),
          ref.watch(memoryRepositoryProvider),
          ref.watch(subjectRepositoryProvider),
          PregnancyRemoteRepositoryImp(),
          MediaUploader(ref.watch(mediaRepositoryProvider)),
        )
      : ChildServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(childRepositoryProvider),
          ref.watch(memoryRepositoryProvider),
        ),
);

/// Các bé + thai kỳ đang theo dõi (không gồm thai kỳ đã lưu trữ).
final childrenProvider = FutureProvider<List<Child>>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(childServiceProvider).children();
});

/// Chủ thể đang xem dùng chung Home / Ký ức / Chăm con (SW-01).
/// `null` = Cả nhà.
final selectedSubjectProvider =
    NotifierProvider<SelectedSubjectNotifier, String?>(
      SelectedSubjectNotifier.new,
    );

class SelectedSubjectNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? childId) => state = childId;
}

/// “Hôm nay” của dữ liệu — truyền cho `child_age.dart`.
final todayProvider = Provider<DateTime>(
  (ref) => ref.watch(appClockProvider).today,
);
