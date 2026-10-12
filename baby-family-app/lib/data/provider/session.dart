import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/repository_imp/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/data/service_imp/session.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sessionRepositoryProvider = Provider<ISessionRepository>(
  (ref) => SessionRepositoryImp(ref.watch(mockStoreProvider)),
);

final sessionServiceProvider = Provider<ISessionService>(
  (ref) => SessionServiceImp(
    ref.watch(sessionRepositoryProvider),
    ref.watch(appClockProvider),
    ref.watch(familyRepositoryProvider),
    ref.watch(childRepositoryProvider),
  ),
);

/// Phiên hiện tại, cập nhật sau mỗi thay đổi dữ liệu (đồng bộ, sau Splash).
final sessionProvider = Provider<AppSession>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(sessionServiceProvider).current;
});
