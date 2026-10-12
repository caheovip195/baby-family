import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Thanh trên của màn soạn (Pencil MEM-05 `WXefe`, MEM-24 `uiSg3`): nút
/// đóng `x` bên trái, tiêu đề giữa (Nunito), nút chữ “Lưu” bên phải.
/// MEM-05: cao 56, tiêu đề 18/700, “Lưu” 16/700 `primary-600`;
/// MEM-24: cao 52, tiêu đề 17/800, “Lưu” 15/700 `primary-700`.
class AppActionTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppActionTopBar({
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.onClose,
    this.height = AppSpacing.topBarHeight,
    this.titleStyle = AppTypography.h3,
    this.actionStyle = const TextStyle(
      fontFamily: AppTypography.bodyFamily,
      fontSize: 16,
      height: 20 / 16,
      fontWeight: FontWeight.w700,
      color: kColorPrimary600C2513F,
    ),
    this.closeIconSize = 24,
    super.key,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onClose;
  final double height;
  final TextStyle titleStyle;
  final TextStyle actionStyle;
  final double closeIconSize;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.resolve(context, kColorBgFFFBF7),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
            child: Row(
              children: [
                SizedBox(
                  width: 72,
                  height: AppSpacing.iconButton,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Semantics(
                      button: true,
                      label: context.l10n.commonClose,
                      excludeSemantics: true,
                      child: InkResponse(
                        onTap: onClose ?? () => context.router.maybePop(),
                        radius: 24,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.s1),
                          child: Icon(
                            LucideIcons.x,
                            size: closeIconSize,
                            color: AppColors.resolve(
                              context,
                              kColorTextPrimary2E2A27,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(context, titleStyle),
                  ),
                ),
                SizedBox(
                  width: 72,
                  height: AppSpacing.iconButton,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onAction,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s1,
                        ),
                        minimumSize: const Size(44, 44),
                      ),
                      child: Text(
                        actionLabel,
                        maxLines: 1,
                        style: AppTypography.adapt(context, actionStyle),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
