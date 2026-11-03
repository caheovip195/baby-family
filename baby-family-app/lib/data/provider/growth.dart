import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository_imp/growth_remote.dart';
import 'package:baby_family/data/repository_imp/local_db.dart';
import 'package:baby_family/data/repository_imp/outbox.dart';
import 'package:baby_family/data/service/growth.dart';
import 'package:baby_family/data/service_imp/growth.dart';
import 'package:baby_family/data/service_imp/growth_remote.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CHD-06 Tăng trưởng: bản mock, hoặc bản server khi chạy với
/// `BABY_FAMILY_API_URL` (offline-first qua outbox + local DB).
final growthServiceProvider = Provider<IGrowthService>(
  (ref) => kValueUseRemoteSession
      ? (GrowthRemoteServiceImp(
            ref.watch(sessionRepositoryProvider),
            ref.watch(appClockProvider),
            GrowthRemoteRepositoryImp(),
          )
          ..outbox = OutboxRepositoryImp('growth')
          ..localDb = LocalDbImp())
      : GrowthServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
        ),
);
