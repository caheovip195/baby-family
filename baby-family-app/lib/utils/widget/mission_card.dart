import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Thẻ nhiệm vụ (Pencil MissionCard `z1ARj`): nền `surface`, viền `border`,
/// bo 16, đệm 12/14, cách 12. Ô tròn 28 viền 2 `secondary-500` (xong: nền
/// `secondary-500` + `check` 16 trắng); tiêu đề 15/600 (xong: `text-secondary`),
/// dòng phụ 12 `text-secondary`; avatar bé 30 viền `surface` 2 ở bên phải.
/// Dùng ở CARE-01 (Của tôi/Của bạn đời/Cùng nhau), HOME-01/02.
class MissionCard extends StatelessWidget {
  const MissionCard({
    required this.title,
    required this.meta,
    this.done = false,
    this.dimDone = true,
    this.child,
    this.onToggle,
    this.onTap,
    this.onLongPress,
    this.trailing,
    super.key,
  });

  final String title;

  /// “Gợi ý hôm nay · Gắn kết · +5 💗”, “Đã xong 08:40 · +5 💗”…
  final String meta;
  final bool done;

  /// Tiêu đề chuyển `text-secondary` khi xong (tab Của tôi). Tab Của bạn đời
  /// giữ `text-primary` (Pencil CARE-01b `qkr1a`).
  final bool dimDone;

  /// Bé gắn với nhiệm vụ (null → không hiện avatar).
  final Child? child;

  /// Chạm ô tròn — null khi chỉ xem (tab Của bạn đời).
  final VoidCallback? onToggle;
  final VoidCallback? onTap;

  /// Nhấn giữ — mở CARE-05 “Đổi nhiệm vụ” với nhiệm vụ hệ thống của tôi.
  final VoidCallback? onLongPress;

  /// Thay avatar bé (ví dụ nút 💛 Cảm ơn ở CARE-01b).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final success = AppColors.resolve(context, kColorSecondary5006FAE8E);
    final check = Semantics(
      checked: done,
      button: onToggle != null,
      label: context.l10n.commonMarkDone,
      child: InkResponse(
        onTap: onToggle,
        radius: AppSpacing.s6,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? success : null,
            border: Border.all(color: success, width: 2),
          ),
          child: done
              ? const Icon(LucideIcons.check, size: 16, color: kColorWhite)
              : null,
        ),
      ),
    );
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardInset,
            vertical: AppSpacing.s3,
          ),
          child: Row(
            children: [
              check,
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.bodyStrong.copyWith(
                          height: 19 / 15,
                          color: done && dimDone
                              ? kColorTextSecondary6B625B
                              : kColorTextPrimary2E2A27,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      meta,
                      style: AppTypography.adapt(context, AppTypography.small),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.s3),
                trailing!,
              ] else if (child != null) ...[
                const SizedBox(width: AppSpacing.s3),
                ChildAvatar(
                  child: child,
                  size: 30,
                  iconSize: 14,
                  borderColor: kColorSurfaceFFFFFF,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
