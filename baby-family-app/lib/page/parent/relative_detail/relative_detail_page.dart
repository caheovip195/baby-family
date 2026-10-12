import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/relative_detail/mobile/relative_detail_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FAM-04
@RoutePage()
class RelativeDetailPage extends BaseHookWidget {
  const RelativeDetailPage({
    @PathParam('memberId') required this.memberId,
    super.key,
  });

  final String memberId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return RelativeDetailMobileView(memberId: memberId);
  }
}
