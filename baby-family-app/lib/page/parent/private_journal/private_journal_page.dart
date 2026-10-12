import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/private_journal/mobile/private_journal_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-07
@RoutePage()
class PrivateJournalPage extends BaseHookWidget {
  const PrivateJournalPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const PrivateJournalMobileView();
  }
}
