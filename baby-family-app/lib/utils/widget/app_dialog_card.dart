import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Khung dialog xác nhận có nội dung tuỳ biến (Pencil MEM-17b `BB8YZ`,
/// RPT-02 `E6bZLd`): rộng 340, nền `surface`, bo 24, đệm 24/22/20/22, các
/// khối cách 14, căn giữa. Mở bằng [showAppDialogCard] (nền mờ `#2E2A2799`).
class AppDialogCard extends StatelessWidget {
  const AppDialogCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.resolve(context, kColorSurfaceFFFFFF),
      surfaceTintColor: kColorTransparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.dialog),
      ),
      // (390 − 340) / 2 = 25 ở màn 390 của Pencil.
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: AppSpacing.s6,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, AppSpacing.s6, 22, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < children.length; index++) ...[
                if (index > 0) const SizedBox(height: AppSpacing.cardInset),
                children[index],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Mở [AppDialogCard] với nền mờ đậm như các frame Pencil.
Future<T?> showAppDialogCard<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) => showDialog<T>(
  context: context,
  barrierColor: AppColors.resolve(context, kColorSheetScrim2E2A27Alpha60),
  builder: builder,
);

/// Vòng icon 56 đầu dialog (MEM-17b `trash-2` trên `#FBE4E4`).
class AppDialogIcon extends StatelessWidget {
  const AppDialogIcon({
    required this.icon,
    this.color = kColorError50FBE4E4,
    this.foreground = kColorErrorD14B4B,
    super.key,
  });

  final IconData icon;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
    width: 56,
    height: 56,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.resolve(context, color),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, size: 26, color: AppColors.resolve(context, foreground)),
  );
}
