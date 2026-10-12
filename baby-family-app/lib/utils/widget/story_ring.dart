import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Vòng story “Hôm nay của các con” (Pencil HOME-01 `iZiXA`): cột rộng 68,
/// vòng 66 viền 3 màu bé (thai kỳ `us-500`) đệm 3, ảnh 56; huy hiệu số mới
/// (cao 20, `primary-600`, viền `bg` 2) góc phải trên; tên 12/700, phụ 10.
/// [StoryRing.add] — vòng `surface` viền 2 `border` + `plus` 24 `primary-600`,
/// nhãn 12/700 `primary-700` (“Ghi lại”).
class StoryRing extends StatelessWidget {
  const StoryRing({
    required Child this.child,
    required this.label,
    this.subtitle,
    this.badgeCount = 0,
    this.onTap,
    super.key,
  }) : _isAdd = false;

  const StoryRing.add({required this.label, this.onTap, super.key})
    : child = null,
      subtitle = null,
      badgeCount = 0,
      _isAdd = true;

  final Child? child;
  final String label;

  /// “5 ảnh”, “Tuần 24”.
  final String? subtitle;

  /// Số ảnh chưa xem; 0 → ẩn huy hiệu.
  final int badgeCount;
  final VoidCallback? onTap;
  final bool _isAdd;

  @override
  Widget build(BuildContext context) {
    final value = child;
    final ring = _isAdd
        ? Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.resolve(context, kColorBorderEADFD6),
                width: 2,
              ),
            ),
            child: Icon(
              LucideIcons.plus,
              size: 24,
              color: AppColors.resolve(context, kColorPrimary600C2513F),
            ),
          )
        : Container(
            width: 66,
            height: 66,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
                color: value!.isPregnancy
                    ? AppColors.resolve(context, kColorUs5009B85D1)
                    : ChildAvatar.colorOf(value),
              ),
            ),
            child: ChildAvatar(child: value, size: 56, iconSize: 24),
          );
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: 68,
          child: Column(
            children: [
              SizedBox(
                width: 68,
                height: 66,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(child: ring),
                    if (badgeCount > 0)
                      Positioned(
                        left: 44,
                        top: 0,
                        child: _Badge(count: badgeCount),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.compact),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _isAdd
                        ? kColorPrimary700A2402F
                        : kColorTextPrimary2E2A27,
                  ),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.compact),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.adapt(context, AppTypography.micro),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) => Container(
    height: 20,
    constraints: const BoxConstraints(minWidth: 20),
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.compact),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.resolve(context, kColorPrimary600C2513F),
      borderRadius: BorderRadius.circular(AppRadius.full),
      border: Border.all(
        color: AppColors.resolve(context, kColorBgFFFBF7),
        width: 2,
      ),
    ),
    child: Text(
      '$count',
      style: AppTypography.micro.copyWith(
        fontWeight: FontWeight.w800,
        height: 1,
        color: AppColors.onPrimary(context),
      ),
    ),
  );
}
