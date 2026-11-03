import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository_imp/ai_remote.dart';
import 'package:baby_family/data/service/ai.dart';
import 'package:baby_family/data/service_imp/ai.dart';
import 'package:baby_family/data/service_imp/ai_remote.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AI 1.2: bản mock, hoặc bản server khi chạy với `BABY_FAMILY_API_URL`.
final aiServiceProvider = Provider<IAiService>(
  (ref) => kValueUseRemoteSession
      ? AiRemoteServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          AiRemoteRepositoryImp(),
        )
      : AiServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
        ),
);
