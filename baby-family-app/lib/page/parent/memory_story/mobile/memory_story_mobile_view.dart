import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/memory_story/memory_story_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/story_bottom_bar.dart';
part '../widgets/story_header.dart';

/// MEM-25 Hôm nay của bé (Pencil `YTCkf`): ảnh toàn màn, thanh tiến độ,
/// chạm trái/phải để lùi/tới, thả cảm xúc, trả lời, “Góc nhìn”.
class MemoryStoryMobileView extends HookConsumerWidget {
  const MemoryStoryMobileView({required this.childId, super.key});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(memoryStoryControllerProvider);
    useEffect(() {
      Future.microtask(() => controller.init(childId));
      return null;
    }, const []);
    void next() {
      if (!controller.next()) {
        context.router.maybePop();
      }
    }

    final still = MediaQuery.disableAnimationsOf(context);
    useEffect(() {
      if (still || !controller.loaded) {
        return null;
      }
      final timer = Timer(MemoryStoryController.photoDuration, next);
      return timer.cancel;
    }, [controller.index, controller.loaded, still]);
    final story = controller.current;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: kColorBlack,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (story != null)
              GestureDetector(
                onTapUp: (details) {
                  final width = MediaQuery.sizeOf(context).width;
                  if (details.localPosition.dx < width / 3) {
                    controller.previous();
                  } else {
                    next();
                  }
                },
                child: Image.asset(story.asset, fit: BoxFit.cover),
              ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 200,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        kColorDarkOverlayBlackAlpha60,
                        kColorTransparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 260,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [kColorTransparent, kColorBlackAlpha70],
                    ),
                  ),
                ),
              ),
            ),
            if (controller.loaded)
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StoryHeader(controller: controller),
                    const Spacer(),
                    _StoryBottomBar(controller: controller),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
