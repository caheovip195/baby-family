import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/repository_imp/memory.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/data/service_imp/memory.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final memoryRepositoryProvider = Provider<IMemoryRepository>(
  (ref) => MemoryRepositoryImp(ref.watch(mockStoreProvider)),
);

final memoryServiceProvider = Provider<IMemoryService>(
  (ref) => MemoryServiceImp(
    ref.watch(sessionRepositoryProvider),
    ref.watch(appClockProvider),
    ref.watch(memoryRepositoryProvider),
    ref.watch(childRepositoryProvider),
    ref.watch(familyRepositoryProvider),
  ),
);

/// Ký ức của bé (null = cả nhà), mới nhất trước.
final memoriesProvider = FutureProvider.family<List<Memory>, String?>((
  ref,
  childId,
) {
  ref.watch(mockRevisionProvider);
  return ref.watch(memoryServiceProvider).memories(childId: childId);
});
