import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/pending_review/mobile/pending_review_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-19
@RoutePage()
class PendingReviewPage extends BaseHookWidget {
  const PendingReviewPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const PendingReviewMobileView();
  }
}
