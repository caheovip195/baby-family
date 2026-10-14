import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/child_switcher.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Thanh trên có nút back, tiêu đề lớn và bộ chuyển bé bên phải (Pencil
/// CARE-07 `tMGvY`: đệm 4/12/8/8, back 44 `chevron-left` 24, “Lịch” 26/800;
/// CARE-11 `ll0hI`: “Thống kê” [titleSize] 24).
class AppSwitcherTitleBar extends StatelessWidget {
  const AppSwitcherTitleBar({
    required this.title,
    required this.children,
    required this.today,
    required this.onChanged,
    this.selectedId,
    this.onManage,
    this.titleSize = 26,
    super.key,
  });

  final String title;
  final List<Child> children;
  final String? selectedId;
  final DateTime today;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onManage;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s2,
        AppSpacing.s1,
        AppSpacing.s3,
        AppSpacing.s2,
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSpacing.iconButton,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => context.router.maybePop(),
              icon: Icon(
                LucideIcons.chevronLeft,
                size: 24,
                color: AppColors.resolve(context, kColorTextPrimary2E2A27),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s1),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.adapt(
                context,
                AppTypography.h1.copyWith(
                  fontSize: titleSize,
                  height: (titleSize + 8) / titleSize,
                ),
              ),
            ),
          ),
          Flexible(
            child: ChildSwitcher(
              children: children,
              selectedId: selectedId,
              today: today,
              onChanged: onChanged,
              onManage: onManage,
            ),
          ),
        ],
      ),
    );
  }
}
