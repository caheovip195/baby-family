import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/settings.dart';
import 'package:baby_family/data/repository_imp/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/data/service_imp/settings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingsRepositoryProvider = Provider<ISettingsRepository>(
  (ref) => SettingsRepositoryImp(ref.watch(mockStoreProvider)),
);

/// SET-02/03/04/07/08/09/11 (batch 2).
final settingsServiceProvider = Provider<ISettingsService>(
  (ref) => SettingsServiceImp(
    ref.watch(sessionRepositoryProvider),
    ref.watch(appClockProvider),
    ref.watch(settingsRepositoryProvider),
    ref.watch(familyRepositoryProvider),
    ref.watch(childRepositoryProvider),
  ),
);
