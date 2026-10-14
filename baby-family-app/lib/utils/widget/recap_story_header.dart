import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Đầu trang tổng kết dạng story (REC-02 `z2YZ8A`, REC-03 `OtCDE`): thanh
/// tiến độ story (đoạn cao 3 bo 2, cách 4, đệm 4/16 — đoạn đầu `primary-600`,
/// còn lại `#2E2A271F`); [title] 24/800 + [subtitle] 13/500
/// `text-secondary`; nút đóng 40 tròn `#FFFFFFB3` (`x` 20).
class RecapStoryHeader extends StatelessWidget {
  const RecapStoryHeader({
    required this.title,
    required this.pages,
    this.subtitle,
    super.key,
  });

  final String title;
  final int pages;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s4,
            AppSpacing.s1,
            AppSpacing.s4,
            0,
          ),
          child: Row(
            children: [
              for (var index = 0; index < pages; index++) ...[
                if (index > 0) const SizedBox(width: AppSpacing.s1),
                Expanded(
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? AppColors.resolve(context, kColorPrimary600C2513F)
                          : kColorShadow2E2A27Alpha12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.itemGap,
            AppSpacing.s4,
            0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.h1.copyWith(
                          fontSize: 24,
                          height: 33 / 24,
                        ),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 16 / 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Semantics(
                button: true,
                label: l10n.commonClose,
                excludeSemantics: true,
                child: InkResponse(
                  onTap: () => context.router.maybePop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.isDark(context)
                          ? AppColors.resolve(context, kColorSurfaceFFFFFF)
                          : kColorWhiteAlpha70,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.x,
                      size: 20,
                      color: AppColors.resolve(
                        context,
                        kColorTextPrimary2E2A27,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
