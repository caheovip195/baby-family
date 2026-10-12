import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Thanh trên có tiêu đề lớn (Pencil MEM-20 “Top” `ZvtHC`): cao 52, đệm
/// ngang 16, cách 8; nút back 40×40 bo 12 (`chevron-left` 22); tiêu đề
/// 20/800 Nunito; bên phải [trailing] (thường là `ChildSwitcher`).
/// Dùng ở MEM-20, MEM-12, chi tiết bộ sưu tập.
class AppBackTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBackTitleBar({
    required this.title,
    this.trailing,
    this.onBack,
    super.key,
  });

  final String title;
  final Widget? trailing;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.resolve(context, kColorBgFFFBF7),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
            child: Row(
              children: [
                Semantics(
                  button: true,
                  label: context.l10n.commonBack,
                  excludeSemantics: true,
                  child: InkResponse(
                    onTap: onBack ?? () => context.router.maybePop(),
                    radius: 24,
                    child: SizedBox.square(
                      dimension: 40,
                      child: Icon(
                        LucideIcons.chevronLeft,
                        size: 22,
                        color: AppColors.resolve(
                          context,
                          kColorTextPrimary2E2A27,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(context, AppTypography.title20),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.s2),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
