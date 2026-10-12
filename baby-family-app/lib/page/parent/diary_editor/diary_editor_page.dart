import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/diary_editor/mobile/diary_editor_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-13
@RoutePage()
class DiaryEditorPage extends BaseHookWidget {
  const DiaryEditorPage({@QueryParam('childId') this.childId, super.key});

  final String? childId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return DiaryEditorMobileView(childId: childId);
  }
}
