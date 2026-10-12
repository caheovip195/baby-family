import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/invite_preview/mobile/invite_preview_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// INV-01
@RoutePage()
class InvitePreviewPage extends BaseHookWidget {
  const InvitePreviewPage({@QueryParam('code') this.code, super.key});

  final String? code;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return InvitePreviewMobileView(code: code);
  }
}
