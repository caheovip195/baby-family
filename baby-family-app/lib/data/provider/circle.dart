import 'package:baby_family/data/dto/circle_view.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
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
  ),
);

/// CIR-01 — những gì người thân đang đăng nhập được thấy.
final circleViewProvider = FutureProvider<CircleView?>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(circleServiceProvider).view();
});
