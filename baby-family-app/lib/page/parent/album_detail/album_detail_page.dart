import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/album_detail/mobile/album_detail_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-03a
@RoutePage()
class AlbumDetailPage extends BaseHookWidget {
  const AlbumDetailPage({
    @PathParam('albumId') required this.albumId,
    super.key,
  });

  final String albumId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return AlbumDetailMobileView(albumId: albumId);
  }
}
