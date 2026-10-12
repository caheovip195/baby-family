part of '../mobile/diary_editor_mobile_view.dart';

/// Một khối thân nhật ký: đoạn 15 (1.6), chữ đậm 15/700, tiêu đề 18/800
/// Nunito, danh sách “•” 15/700 `primary-600` (đánh số “1.”) cách 10 + chữ 15
/// (1.5) — Pencil `jKglw`, `bu0Te`, `ySlFY`.
class _DiaryBlockField extends StatelessWidget {
  const _DiaryBlockField({
    required this.block,
    required this.number,
    this.hint,
  });

  final DiaryBlock block;
  final int number;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final list =
        block.kind == DiaryBlockKind.bullet ||
        block.kind == DiaryBlockKind.numbered;
    var style = switch (block.kind) {
      DiaryBlockKind.heading => AppTypography.h3.copyWith(
        fontWeight: FontWeight.w800,
        height: 1.4,
      ),
      DiaryBlockKind.bullet ||
      DiaryBlockKind.numbered => AppTypography.body.copyWith(height: 1.5),
      DiaryBlockKind.paragraph => AppTypography.body.copyWith(height: 1.6),
    };
    style = style.copyWith(letterSpacing: 0);
    if (block.bold) {
      style = style.copyWith(fontWeight: FontWeight.w700);
    }
    if (block.italic) {
      style = style.copyWith(fontStyle: FontStyle.italic);
    }
    final field = TextField(
      controller: block.controller,
      focusNode: block.focusNode,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: AppTypography.adapt(context, style),
      cursorColor: AppColors.resolve(context, kColorPrimary600C2513F),
      decoration: InputDecoration.collapsed(
        hintText: hint,
        hintStyle: style.copyWith(
          color: AppColors.resolve(context, kColorTextTertiary9C928A),
        ),
      ),
    );
    if (!list) {
      return field;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          block.kind == DiaryBlockKind.numbered ? '$number.' : '•',
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.5,
            color: AppColors.resolve(context, kColorPrimary600C2513F),
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(child: field),
      ],
    );
  }
}
