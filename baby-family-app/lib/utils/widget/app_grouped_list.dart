import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Nhóm dòng cài đặt (Pencil SET-01 “General”, SET-06 “Language”): nền
/// `surface`, viền `border` 1, bo 16, các dòng cách nhau bằng đường kẻ
/// `border` 1 ở đáy (dòng cuối không kẻ).
class AppGroupedList extends StatelessWidget {
  const AppGroupedList({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final divider = AppColors.resolve(context, kColorBorderEADFD6);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: divider),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            for (var index = 0; index < children.length; index++)
              DecoratedBox(
                decoration: BoxDecoration(
                  border: index == children.length - 1
                      ? null
                      : Border(bottom: BorderSide(color: divider)),
                ),
                child: children[index],
              ),
          ],
        ),
      ),
    );
  }
}
