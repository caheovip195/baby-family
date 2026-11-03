import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/page/parent/photo_viewer/photo_viewer_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

/// BF-20261030-008: MEM-08 mở ảnh/video của một góc nhìn MEM-24.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'the viewer shows the perspective media and story, not the memory',
    () async {
      final container = ProviderContainer(
        overrides: mockOverrides(actor: 'papa'),
      );
      addTearDown(container.dispose);
      final memories = container.read(memoryServiceProvider);
      const memoryId = 'm-keepsake-bracelet';
      final original = await memories.memory(memoryId);
      final saved = await memories.savePerspective(
        memoryId,
        body: 'Bố nhớ hôm đó',
        mediaAssets: const ['/tmp/a.jpg', '/tmp/clip.mp4'],
      );
      final key = (memoryId: memoryId, perspectiveId: saved.id);
      final controller = container.read(photoViewerControllerProvider(key));
      container.listen(photoViewerControllerProvider(key), (_, _) {});
      for (var i = 0; i < 20 && !controller.loaded; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(controller.assets, ['/tmp/a.jpg', '/tmp/clip.mp4']);
      expect(controller.memory?.body, 'Bố nhớ hôm đó');
      expect(controller.videoAt(1), '/tmp/clip.mp4');
      expect(controller.videoAt(0), isNull);
      controller.setPage(1);
      expect(await controller.originalUrl(), '/tmp/clip.mp4');
      expect(controller.assets, isNot(original?.mediaAssets));
    },
  );
}
