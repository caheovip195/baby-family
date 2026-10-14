import 'package:baby_family/data/dto/circle_view.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/notification.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/circle.dart';
import 'package:baby_family/data/service_imp/circle.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final circleServiceProvider = Provider<ICircleService>(
  (ref) => CircleServiceImp(
    ref.watch(sessionRepositoryProvider),
    ref.watch(appClockProvider),
    ref.watch(familyRepositoryProvider),
    ref.watch(childRepositoryProvider),
    ref.watch(memoryRepositoryProvider),
    ref.watch(notificationRepositoryProvider),
  ),
);

/// CIR-01 — những gì người thân đang đăng nhập được thấy.
final circleViewProvider = FutureProvider<CircleView?>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(circleServiceProvider).view();
});

/// Cháu đang xem trong Circle — CIR-01 (chip cháu) và CIR-02 (Trang của
/// cháu) dùng chung. `null` = mặc định (cháu nhỏ nhất đã chào đời).
final circleSelectedChildProvider =
    NotifierProvider<CircleSelectedChildNotifier, String?>(
      CircleSelectedChildNotifier.new,
    );

class CircleSelectedChildNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? childId) => state = childId;
}
