import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/repository_imp/mock_store.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Đồng hồ của tầng dữ liệu. Mock: bắt đầu 07/10/2026 20:25 (Pencil).
/// Test override bằng `AppClock.fixed(..., frozen: true)`.
final appClockProvider = Provider<AppClock>(
  (ref) => AppClock.fixed(kValueDemoStartTime),
);

/// Nguồn dữ liệu mock duy nhất (seed theo `BABY_FAMILY_DEMO`). Test override
/// để chọn seed: `mockStoreProvider.overrideWith((ref) => MockStore(...))`.
final mockStoreProvider = Provider<MockStore>((ref) {
  final store = MockStore(
    clock: ref.watch(appClockProvider),
    seed: DemoSeed.fromName(kValueDemoSeed),
    actor: kValueDemoActor,
  );
  ref.onDispose(store.dispose);
  return store;
});

/// Tăng mỗi khi dữ liệu mock đổi hoặc đổi ngôn ngữ (catalog đã dịch).
/// Provider dữ liệu / controller `ref.watch`/`ref.listen` để tải lại.
final mockRevisionProvider = Provider<int>((ref) {
  final store = ref.watch(mockStoreProvider);
  store.locale = ref.watch(appLanguageProvider).code;
  void listener() => ref.invalidateSelf();
  store.addListener(listener);
  ref.onDispose(() => store.removeListener(listener));
  return store.revision;
});
