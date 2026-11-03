import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository_imp/local_db.dart';
import 'package:baby_family/data/repository_imp/outbox.dart';
import 'package:baby_family/data/repository_imp/year_book_remote.dart';
import 'package:baby_family/data/service/year_book.dart';
import 'package:baby_family/data/service_imp/year_book.dart';
import 'package:baby_family/data/service_imp/year_book_remote.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// REC-04 Sách của con: bản mock, hoặc bản server khi chạy với
/// `BABY_FAMILY_API_URL` (offline-first qua outbox + local DB).
final yearBookServiceProvider = Provider<IYearBookService>(
  (ref) => kValueUseRemoteSession
      ? (YearBookRemoteServiceImp(
            ref.watch(sessionRepositoryProvider),
            ref.watch(appClockProvider),
            YearBookRemoteRepositoryImp(),
          )
          ..outbox = OutboxRepositoryImp('yearbook')
          ..localDb = LocalDbImp())
      : YearBookServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
        ),
);
