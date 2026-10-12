import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/repository/pregnancy.dart';
import 'package:baby_family/data/repository_imp/pregnancy.dart';
import 'package:baby_family/data/service/pregnancy.dart';
import 'package:baby_family/data/service_imp/pregnancy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final pregnancyRepositoryProvider = Provider<IPregnancyRepository>(
  (ref) => PregnancyRepositoryImp(ref.watch(mockStoreProvider)),
);

final pregnancyServiceProvider = Provider<IPregnancyService>(
  (ref) => PregnancyServiceImp(
    ref.watch(sessionRepositoryProvider),
    ref.watch(appClockProvider),
    ref.watch(pregnancyRepositoryProvider),
    ref.watch(childRepositoryProvider),
    ref.watch(familyRepositoryProvider),
    ref.watch(memoryRepositoryProvider),
    ref.watch(usRepositoryProvider),
  ),
);
