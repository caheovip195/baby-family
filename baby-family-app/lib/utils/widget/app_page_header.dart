import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_square_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Đầu trang lớn không có TopBar (Pencil FAM-01 “Header”, SET-01 “Title”):
/// tiêu đề 26/800 + [trailing] bên phải. Khi màn được mở chồng lên màn khác
/// thì thêm nút quay lại vuông 40 ở trái (thiết kế không vẽ nhưng cần để lùi).
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({required this.title, this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final canPop = context.router.canPop();
    return Row(
      children: [
        if (canPop) ...[
          AppSquareIconButton(
            icon: LucideIcons.chevronLeft,
            tooltip: context.l10n.commonBack,
            onPressed: () => context.router.maybePop(),
          ),
          const SizedBox(width: AppSpacing.s2),
        ],
        Expanded(
          child: Text(
            title,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
        ),
        ?trailing,
      ],
    );
  }
}
