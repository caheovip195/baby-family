import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/account_remote.dart';
import 'package:baby_family/data/repository/settings.dart';
import 'package:baby_family/data/repository_imp/account_remote.dart';
import 'package:baby_family/data/repository_imp/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/data/service_imp/settings.dart';
import 'package:baby_family/data/service_imp/settings_remote.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingsRepositoryProvider = Provider<ISettingsRepository>(
  (ref) => SettingsRepositoryImp(ref.watch(mockStoreProvider)),
);

/// SET-02/03/04/07/08/09/11 (batch 2).
final accountRemoteRepositoryProvider = Provider<IAccountRemoteRepository>(
  (ref) => AccountRemoteRepositoryImp(),
);

/// Bản thật (`BABY_FAMILY_API_URL`): xuất dữ liệu và xoá tài khoản qua server.
final settingsServiceProvider = Provider<ISettingsService>(
  (ref) => kValueUseRemoteSession
      ? SettingsRemoteServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(settingsRepositoryProvider),
          ref.watch(familyRepositoryProvider),
          ref.watch(childRepositoryProvider),
          ref.watch(accountRemoteRepositoryProvider),
          ref.watch(sessionServiceProvider),
          ref.watch(mediaRepositoryProvider),
        )
      : SettingsServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(settingsRepositoryProvider),
          ref.watch(familyRepositoryProvider),
          ref.watch(childRepositoryProvider),
        ),
);
