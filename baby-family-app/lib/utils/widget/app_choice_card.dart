import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Thẻ lựa chọn (Pencil ChoiceCard `sOx1x`): nền `surface`, bo 20, viền 1
/// `border`, đệm 16, cách 14; ô icon 52 tròn ([iconBackground], icon 26
/// [color]); tiêu đề 18/700 Nunito, mô tả 13 (line-height 1.4); radio 24
/// viền 2. Khi chọn: nền `primary-50`, viền 2 `primary-500`, radio
/// `primary-600` + chấm 12. Dùng ở ONB-03, ONB-04, PREG-06…
class AppChoiceCard extends StatelessWidget {
  const AppChoiceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.color = kColorPrimary600C2513F,
    this.iconBackground = kColorPrimary100FFE3DC,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  /// Màu icon (ví dụ `secondary-700` cho “Người thân”).
  final Color color;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    final radioColor = AppColors.resolve(
      context,
      selected ? kColorPrimary600C2513F : kColorBorderEADFD6,
    );
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: AppColors.resolve(
          context,
          selected ? kColorPrimary50FFF4F1 : kColorSurfaceFFFFFF,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: BorderSide(
            color: AppColors.resolve(
              context,
              selected ? kColorPrimary500EE7B67 : kColorBorderEADFD6,
            ),
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(selected ? 15 : AppSpacing.s4),
            child: Row(
              children: [
                Container(
                  width: AppSpacing.buttonHeight,
                  height: AppSpacing.buttonHeight,
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, iconBackground),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.resolve(context, color),
                    size: 26,
                  ),
                ),
                const SizedBox(width: AppSpacing.cardInset),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.h3.copyWith(height: 25 / 18),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption.copyWith(height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.cardInset),
                Container(
                  width: AppSpacing.s6,
                  height: AppSpacing.s6,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: radioColor),
                  ),
                  child: selected
                      ? Container(
                          width: AppSpacing.s3,
                          height: AppSpacing.s3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: radioColor,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
