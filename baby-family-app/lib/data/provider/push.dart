import 'package:baby_family/data/provider/auth.dart';
import 'package:baby_family/data/repository/push_token.dart';
import 'package:baby_family/data/repository_imp/auth.dart';
import 'package:baby_family/data/repository_imp/push_token.dart';
import 'package:baby_family/data/service/push.dart';
import 'package:baby_family/data/service_imp/push.dart';
import 'package:baby_family/data/service_imp/push_remote.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final pushTokenRepositoryProvider = Provider<IPushTokenRepository>(
  (ref) => PushTokenRepositoryImp(),
);

/// ONB-10: bản thật đăng ký push token với server (BF-20261018-014).
final pushServiceProvider = Provider<IPushService>((ref) {
  if (!kValueUseRemoteSession) {
    return PushServiceImp();
  }
  final service = PushRemoteServiceImp(
    ref.watch(authProvider),
    AuthRepositoryImp(),
    ref.watch(pushTokenRepositoryProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});
