import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Tiêu đề khối + liên kết bên phải (Pencil HOME-01):
/// - [SectionHeader] — 18/700 Nunito, link 14/600 `primary-600`
///   (“Nhiệm vụ hôm nay · Xem tất cả”).
/// - [SectionHeader.large] — 20/800, link 13/600 `primary-700`
///   (“Mới trong nhà · Ký ức”).
/// - [SectionHeader.compact] — 17/800 + chú thích 12 `text-secondary`
///   (“Hôm nay của các con · 9 khoảnh khắc”).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : _titleStyle = AppTypography.h3,
       _actionStyle = const TextStyle(
         fontSize: 14,
         fontWeight: FontWeight.w600,
         color: kColorPrimary600C2513F,
       );

  const SectionHeader.large({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : _titleStyle = AppTypography.title20,
       _actionStyle = const TextStyle(
         fontSize: 13,
         fontWeight: FontWeight.w600,
         color: kColorPrimary700A2402F,
       );

  /// 18/800 + link 13/600 `primary-700` (HOME-02/03 “Hôm nay của Haru ·
  /// Xem dạng story”, “Bụng bầu theo tuần · So sánh”).
  const SectionHeader.medium({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : _titleStyle = const TextStyle(
         fontFamily: AppTypography.headingFamily,
         fontSize: 18,
         height: 24 / 18,
         fontWeight: FontWeight.w800,
         color: kColorTextPrimary2E2A27,
       ),
       _actionStyle = const TextStyle(
         fontSize: 13,
         fontWeight: FontWeight.w600,
         color: kColorPrimary700A2402F,
       );

  const SectionHeader.compact({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : _titleStyle = AppTypography.title17,
       _actionStyle = const TextStyle(
         fontSize: 12,
         fontWeight: FontWeight.w400,
         color: kColorTextSecondary6B625B,
       );

  final String title;

  /// Link/chú thích bên phải; null → ẩn.
  final String? actionLabel;
  final VoidCallback? onAction;
  final TextStyle _titleStyle;
  final TextStyle _actionStyle;

  @override
  Widget build(BuildContext context) {
    final action = actionLabel == null
        ? null
        : Text(
            actionLabel!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.adapt(
              context,
              AppTypography.text14.merge(_actionStyle),
            ),
          );
    // Tiêu đề chiếm phần còn lại; link bên phải chỉ rộng theo nội dung (tối đa
    // nửa hàng) để luôn sát lề phải như Pencil.
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: AppTypography.adapt(context, _titleStyle),
              ),
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: AppSpacing.s2),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth / 2),
              child: onAction == null
                  ? action
                  : InkWell(
                      onTap: onAction,
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.s1,
                        ),
                        child: action,
                      ),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
