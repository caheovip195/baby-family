import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:flutter/material.dart';

/// TẠM THỜI (foundation batch 3): khung của các màn chưa được dựng — hiển thị
/// tiêu đề + mã màn. Agent khu vực thay bằng UI theo Pencil rồi xoá widget này
/// khi không còn màn nào dùng.
class AppSkeletonScreen extends StatelessWidget {
  const AppSkeletonScreen({
    required this.code,
    required this.title,
    this.showBack = true,
    super.key,
  });

  /// Mã màn (US-08, CIR-02…).
  final String code;
  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppTopBar(title: title, showBack: showBack),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s6,
          AppSpacing.screen,
          AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            code,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            context.l10n.commonScreenInProgress,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(context, AppTypography.caption),
          ),
        ],
      ),
    );
  }
}
