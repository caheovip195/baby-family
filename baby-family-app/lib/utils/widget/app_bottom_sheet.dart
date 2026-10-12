import 'dart:math' as math;

import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Bottom sheet chuẩn (Pencil SW-01 `PfRgF`, QC-01 `IWfKB`, CARE-05/06,
/// US-02): nền `surface`, bo trên 28, đệm 10/20/36/20, tay cầm 36×4 `border`,
/// tiêu đề 18/700 Nunito, các khối cách 16.
///
/// Mở bằng [showAppBottomSheet].
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.children,
    this.title,
    this.titleTrailing,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.screen,
      AppSpacing.itemGap,
      AppSpacing.screen,
      36,
    ),
    this.gap = AppSpacing.s4,
    this.scrollable = true,
    super.key,
  });

  final String? title;

  /// Thành phần bên phải tiêu đề (đóng, “Xem tất cả”…).
  final Widget? titleTrailing;
  final List<Widget> children;
  final EdgeInsets padding;
  final double gap;

  /// Cuộn khi nội dung cao hơn màn (chữ lớn, máy nhỏ).
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final items = <Widget>[
      const Center(child: AppSheetHandleBar()),
      if (title != null)
        Row(
          children: [
            Expanded(
              child: Text(
                title!,
                style: AppTypography.adapt(context, AppTypography.h3),
              ),
            ),
            ?titleTrailing,
          ],
        ),
      ...children,
    ];
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) SizedBox(height: gap),
          items[index],
        ],
      ],
    );
    final insetPadding = padding.copyWith(
      bottom: padding.bottom + mediaQuery.viewInsets.bottom,
    );
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: math.max(
            0,
            mediaQuery.size.height - mediaQuery.padding.top - AppSpacing.s6,
          ),
        ),
        child: scrollable
            ? SingleChildScrollView(padding: insetPadding, child: column)
            : Padding(padding: insetPadding, child: column),
      ),
    );
  }
}

/// Tay cầm 36×4 bo 2 màu `border`.
class AppSheetHandleBar extends StatelessWidget {
  const AppSheetHandleBar({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: AppSpacing.s1,
    decoration: BoxDecoration(
      color: AppColors.resolve(context, kColorBorderEADFD6),
      borderRadius: BorderRadius.circular(2),
    ),
  );
}

/// Mở bottom sheet theo Design System.
///
/// [strongScrim] = true → nền mờ `#2E2A2799` (CARE-05/06, US-02); mặc định
/// `#2E2A277A` (SW-01, QC-01) — đúng như các frame Pencil.
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool strongScrim = false,
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    isDismissible: isDismissible,
    backgroundColor: kColorTransparent,
    elevation: 0,
    barrierColor: AppColors.resolve(
      context,
      strongScrim ? kColorSheetScrim2E2A27Alpha60 : kColorOverlay2E2A27Alpha48,
    ),
    builder: builder,
  );
}
