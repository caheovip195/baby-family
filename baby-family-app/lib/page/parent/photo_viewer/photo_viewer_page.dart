import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/photo_viewer/mobile/photo_viewer_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-08
@RoutePage()
class PhotoViewerPage extends BaseHookWidget {
  const PhotoViewerPage({
    @PathParam('memoryId') required this.memoryId,
    @QueryParam('index') this.index,
    super.key,
  });

  final String memoryId;
  final int? index;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return PhotoViewerMobileView(memoryId: memoryId, index: index);
  }
}
