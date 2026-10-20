import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/support_request/mobile/support_request_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-11 — gửi yêu cầu hỗ trợ và xem yêu cầu đã gửi.
@RoutePage()
class SupportRequestPage extends BaseHookWidget {
  const SupportRequestPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const SupportRequestMobileView();
  }
}
