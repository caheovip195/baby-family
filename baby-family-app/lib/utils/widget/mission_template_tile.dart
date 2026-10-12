import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_icon_badge.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Dòng mẫu nhiệm vụ (Pencil CARE-05 `ImxhM`, STATE-03 `TN4Qd`): cao ≥ 68,
/// đệm 14, cách 12, bo 16; ô icon 40 bo 12 ([iconBackground], mặc định
/// `primary-100`) + icon 20 `primary-600`; tiêu đề 15/600, dòng phụ 12
/// `text-secondary`. [selected] → nền `primary-50` viền `primary-500`.
/// Bên phải: [hearts] (“♥ +5”) hoặc [trailing] (nút thêm).
/// Dùng ở CARE-05 (sheet đổi), CARE-04 (thư viện), STATE-03 (gợi ý).
class MissionTemplateTile extends StatelessWidget {
  const MissionTemplateTile({
    required this.icon,
    required this.title,
    required this.meta,
    this.hearts,
    this.trailing,
    this.selected = false,
    this.iconBackground = kColorPrimary100FFE3DC,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String meta;
  final int? hearts;
  final Widget? trailing;
  final bool selected;
  final Color iconBackground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final heartsValue = hearts;
    return Semantics(
      selected: selected,
      button: onTap != null,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorPrimary50FFF4F1 : kColorSurfaceFFFFFF,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(
            color: AppColors.resolve(
              context,
              selected ? kColorPrimary500EE7B67 : kColorBorderEADFD6,
            ),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardInset),
            child: Row(
              children: [
                AppIconBadge(
                  icon: icon,
                  radius: AppRadius.tile,
                  color: iconBackground,
                  foreground: kColorPrimary600C2513F,
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.bodyStrong.copyWith(height: 19 / 15),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        meta,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small,
                        ),
                      ),
                    ],
                  ),
                ),
                if (heartsValue != null) ...[
                  const SizedBox(width: AppSpacing.s3),
                  Icon(
                    LucideIcons.heart,
                    size: 14,
                    color: AppColors.resolve(context, kColorPrimary500EE7B67),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    context.l10n.careHeartsPlus(heartsValue),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 16 / 13,
                        color: kColorPrimary600C2513F,
                      ),
                    ),
                  ),
                ],
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.s3),
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
