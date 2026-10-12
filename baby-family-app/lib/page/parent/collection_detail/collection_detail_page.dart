import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/collection_detail/mobile/collection_detail_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-22
@RoutePage()
class CollectionDetailPage extends BaseHookWidget {
  const CollectionDetailPage({
    @PathParam('code') required this.code,
    super.key,
  });

  final String code;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return CollectionDetailMobileView(code: code);
  }
}
