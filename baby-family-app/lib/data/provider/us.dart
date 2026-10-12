import 'package:baby_family/data/dto/couple_today.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/us.dart';
import 'package:baby_family/data/repository_imp/us.dart';
import 'package:baby_family/data/service/us.dart';
import 'package:baby_family/data/service_imp/us.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final usRepositoryProvider = Provider<IUsRepository>(
  (ref) => UsRepositoryImp(ref.watch(mockStoreProvider)),
);

final usServiceProvider = Provider<IUsService>(
  (ref) => UsServiceImp(
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
