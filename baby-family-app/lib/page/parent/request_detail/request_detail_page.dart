import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/request_detail/mobile/request_detail_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-04
@RoutePage()
class RequestDetailPage extends BaseHookWidget {
  const RequestDetailPage({
    @PathParam('requestId') required this.requestId,
    super.key,
  });

  final String requestId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return RequestDetailMobileView(requestId: requestId);
  }
}
