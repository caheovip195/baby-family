import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/notification.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/data/service_imp/circle_remote.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

class _FakeMemories extends Fake implements IMemoryService {
  final refreshed = <String>[];

  @override
  Future<Memory?> refreshMemory(String id) async {
    refreshed.add(id);
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakeMemories memories;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    memories = _FakeMemories();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({kValueSessionKeyServerFamilyId: 'srv-family'});
  });

  CircleRemoteServiceImp service() => CircleRemoteServiceImp(
    container.read(sessionRepositoryProvider),
    container.read(appClockProvider),
    container.read(familyRepositoryProvider),
    container.read(childRepositoryProvider),
    container.read(memoryRepositoryProvider),
    container.read(notificationRepositoryProvider),
    memories,
    container.read(onboardingRepositoryProvider),
    container.read(sessionServiceProvider),
  );

  test(
    'BF-20261023-001: circle detail uses server lookup for a fixture id',
    () async {
      final repository = container.read(memoryRepositoryProvider);
      final familyId =
          container.read(sessionRepositoryProvider).session()['familyId']
              as String;
      final id = repository.memories(familyId).first['id'] as String;
      expect(repository.memory(id), isNotNull);
      expect(await service().memory(id), isNull);
      expect(memories.refreshed, [id]);
    },
  );
}
