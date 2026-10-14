part of '../mobile/circle_me_mobile_view.dart';

/// Lựa chọn thông báo (Pencil “Báo ngay khi có ảnh mới” / “Bản tin mỗi
/// ngày”): thẻ bo 16 đệm 16 cách 14, vòng chọn 24, tiêu đề 17 (+ dòng phụ
/// 15); đang chọn nền `primary-50` viền `primary-500`, chữ 700, nút giờ
/// “⏰ 19:00” viền `primary-300`.
class _MeNotifyOption extends StatelessWidget {
  const _MeNotifyOption({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.time,
    this.onTime,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final String? time;
  final VoidCallback onTap;
  final VoidCallback? onTime;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    final accent = AppColors.resolve(context, kColorPrimary700A2402F);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorPrimary50FFF4F1 : kColorSurfaceFFFFFF,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: AppColors.resolve(
              context,
              selected ? kColorPrimary500EE7B67 : kColorBorderEADFD6,
            ),
          ),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: radius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Row(
              children: [
                AppRadioMark(selected: selected),
                const SizedBox(width: AppSpacing.cardInset),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.bodyLarge.copyWith(
                            height: 22 / 17,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (subtitle != null && selected) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle!,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.body.copyWith(
                              height: 19 / 15,
                              color: kColorTextSecondary6B625B,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (time != null && selected) ...[
                  const SizedBox(width: AppSpacing.cardInset),
                  Material(
                    color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: AppColors.resolve(
                          context,
                          kColorPrimary300F7A796,
                        ),
                      ),
                    ),
                    child: InkWell(
                      customBorder: const StadiumBorder(),
                      onTap: onTime,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s3,
                          vertical: AppSpacing.itemGap,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.alarmClock,
                              size: 16,
                              color: accent,
                            ),
                            const SizedBox(width: AppSpacing.compact),
                            Text(
                              time!,
                              style: AppTypography.adapt(
                                context,
                                AppTypography.title16.copyWith(
                                  fontFamily: AppTypography.bodyFamily,
                                  color: accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
