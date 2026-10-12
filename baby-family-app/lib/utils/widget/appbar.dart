import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// App bar chuẩn: nền theo màn, tiêu đề Nunito 18, nút back `chevronLeft`.
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.showBack = true,
    this.onBack,
    this.leadingIcon = LucideIcons.chevronLeft,
    this.backgroundColor,
    this.centerTitle,
    this.titleStyle,
    this.titleSpacing,
    this.toolbarHeight = kToolbarHeight,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final IconData leadingIcon;
  final Color? backgroundColor;
  final bool? centerTitle;
  final TextStyle? titleStyle;
  final double? titleSpacing;
  final double toolbarHeight;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = context.router.canPop();
    return AppBar(
      toolbarHeight: toolbarHeight,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      backgroundColor: AppColors.resolve(
        context,
        backgroundColor ?? kColorBgFFFBF7,
      ),
      automaticallyImplyLeading: false,
      leading: showBack && (canPop || onBack != null)
          ? IconButton(
              icon: Icon(
                leadingIcon,
                color: AppColors.resolve(context, kColorTextPrimary2E2A27),
                size: 24,
              ),
              onPressed: onBack ?? () => context.router.maybePop(),
            )
          : null,
      title:
          titleWidget ??
          (title == null
              ? null
              : Text(
                  title!,
                  style: AppTypography.adapt(
                    context,
                    titleStyle ?? AppTypography.h3,
                  ),
                )),
      actions: actions,
    );
  }
}
