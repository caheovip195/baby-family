import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/utils/helper/video_screening.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

/// Thời lượng giả theo tên tệp (giây).
class _Durations extends Fake implements IMemoryService {
  @override
  Future<int?> videoDurationSec(String path) async => switch (path) {
    '/tmp/short.mp4' => 30,
    '/tmp/long.mp4' => 60 * 60,
    _ => null,
  };
}

/// BF-20261030-007: MEM-04 và MEM-24 dùng chung sàng video theo gói.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'videos longer than the plan limit are dropped with the longest minutes',
    () async {
      final container = ProviderContainer(overrides: mockOverrides());
      addTearDown(container.dispose);
      final family = container.read(familyServiceProvider);
      final limit = await planVideoLimit(family);
      expect(limit.maxMinutes, greaterThan(0));
      final memories = _Durations();
      final result = await screenPickedMedia(family, memories, const [
        '/tmp/a.jpg',
        '/tmp/short.mp4',
        '/tmp/long.mp4',
      ]);
      expect(result.accepted, ['/tmp/a.jpg', '/tmp/short.mp4']);
      expect(result.tooLongMinutes, 60);
    },
  );
}
