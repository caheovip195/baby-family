import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/auth.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/repository/onboarding.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/repository_imp/auth.dart';
import 'package:baby_family/data/repository_imp/offline_snapshot.dart';
import 'package:baby_family/data/repository_imp/onboarding.dart';
import 'package:baby_family/data/repository_imp/session.dart';
import 'package:baby_family/data/repository_imp/social_credential.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/data/service_imp/session.dart';
import 'package:baby_family/data/service_imp/session_remote.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sessionRepositoryProvider = Provider<ISessionRepository>(
  (ref) => SessionRepositoryImp(ref.watch(mockStoreProvider)),
);

final onboardingRepositoryProvider = Provider<IOnboardingRepository>(
  (ref) => OnboardingRepositoryImp(),
);

/// Bản mock, hoặc bản gọi server khi chạy với `BABY_FAMILY_API_URL`
/// (`make local-run`) — bản server phản chiếu trạng thái vào bản mock.
final sessionServiceProvider = Provider<ISessionService>((ref) {
  final local = SessionServiceImp(
    ref.watch(sessionRepositoryProvider),
    ref.watch(appClockProvider),
    ref.watch(familyRepositoryProvider),
    ref.watch(childRepositoryProvider),
  );
  if (!kValueUseRemoteSession) {
    return local;
  }
  return SessionRemoteServiceImp(
    local,
    ref.watch(authProvider),
    AuthRepositoryImp(),
    ref.watch(onboardingRepositoryProvider),
    ref.watch(childRepositoryProvider),
    OfflineSnapshotRepositoryImp(),
    SocialCredentialRepositoryImp(),
  );
});

/// Phiên hiện tại, cập nhật sau mỗi thay đổi dữ liệu (đồng bộ, sau Splash).
final sessionProvider = Provider<AppSession>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(sessionServiceProvider).current;
});
