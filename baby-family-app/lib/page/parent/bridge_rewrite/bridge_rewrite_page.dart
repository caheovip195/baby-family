import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/bridge_rewrite/mobile/bridge_rewrite_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-09
@RoutePage()
class BridgeRewritePage extends BaseHookWidget {
  const BridgeRewritePage({@QueryParam('text') this.original, super.key});

  /// Câu người dùng muốn viết lại (bản server gửi cho AI).
  final String? original;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return BridgeRewriteMobileView(original: original);
  }
}
