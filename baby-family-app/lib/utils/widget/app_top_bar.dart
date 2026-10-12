import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Thanh trên của luồng đăng nhập/onboarding (Pencil TopBar `qhcBT`): cao 56,
/// đệm ngang 12, nền `bg`; nút back 44×44 (`chevron-left` 24); giữa là chấm
/// tiến trình (bước đã qua 24×6 `primary-500`, bước sau 8×6 `border`, cách 6);
/// phải là ô 44×44 cho [trailing].
///
/// [step] bắt đầu từ 1; không truyền [stepCount] thì không vẽ chấm.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    this.step,
    this.stepCount,
    this.showBack = true,
    this.onBack,
    this.trailing,
    this.title,
    this.backgroundColor,
    super.key,
  });

  final int? step;
  final int? stepCount;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;

  /// Tiêu đề thay cho chấm tiến trình (màn chi tiết đơn giản).
  final String? title;
  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.topBarHeight);

  @override
  Widget build(BuildContext context) {
    final center = title != null
        ? Text(
            title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(context, AppTypography.h3),
          )
        : (stepCount == null
              ? const SizedBox.shrink()
              : _StepDots(step: step ?? 1, count: stepCount!));
    return Material(
      color: AppColors.resolve(context, backgroundColor ?? kColorBgFFFBF7),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppSpacing.topBarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: AppSpacing.iconButton,
                  child: showBack
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: context.l10n.commonBack,
                          onPressed: onBack ?? () => context.router.maybePop(),
                          icon: Icon(
                            LucideIcons.chevronLeft,
                            size: 24,
                            color: AppColors.resolve(
                              context,
                              kColorTextPrimary2E2A27,
                            ),
                          ),
                        )
                      : null,
                ),
                Expanded(child: Center(child: center)),
                SizedBox.square(
                  dimension: AppSpacing.iconButton,
                  child: trailing == null ? null : Center(child: trailing),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.step, required this.count});

  final int step;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 1; index <= count; index++) ...[
          if (index > 1) const SizedBox(width: AppSpacing.compact),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: index <= step ? AppSpacing.s6 : AppSpacing.s2,
            height: AppSpacing.compact,
            decoration: BoxDecoration(
              color: AppColors.resolve(
                context,
                index <= step ? kColorPrimary500EE7B67 : kColorBorderEADFD6,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ],
    );
  }
}
