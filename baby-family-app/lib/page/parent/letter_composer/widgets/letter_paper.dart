part of '../mobile/letter_composer_mobile_view.dart';

/// Giấy viết thư (`ZByEx`): nền `#FFFDF7`, viền `#EBDDC8`, bo 6, bóng
/// `#8A6A4020` (y 4, blur 14); đệm 18/20, cách 10; lời mở đầu chữ tay 24/700
/// `primary-700`; thân 15 (1.7) `#4A3F36`; ký tên căn phải (“Yêu con,” 20 +
/// tên 24/700 `primary-700`).
class _LetterPaper extends StatelessWidget {
  const _LetterPaper({
    required this.salutation,
    required this.signature,
    required this.body,
  });

  final String salutation;
  final List<String> signature;
  final TextEditingController body;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.resolve(context, kColorPrimary700A2402F);
    final bodyStyle = AppTypography.body.copyWith(
      height: 1.7,
      letterSpacing: 0,
      color: kColorLetterInk4A3F36,
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: kColorLetterPaperFFFDF7,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(color: kColorLetterBorderEBDDC8),
        boxShadow: const [
          BoxShadow(
            color: kColorLetterShadow8A6A40Alpha13,
            offset: Offset(0, 4),
            blurRadius: 14,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            salutation,
            style: _scriptStyle.copyWith(
              fontSize: 24,
              height: 29 / 24,
              color: kColorPrimary700A2402F,
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          TextField(
            controller: body,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: bodyStyle,
            cursorColor: accent,
            decoration: InputDecoration.collapsed(
              hintText: context.l10n.memLetterBodyHint,
              hintStyle: bodyStyle.copyWith(color: kColorTextTertiary9C928A),
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          for (var index = 0; index < signature.length; index++)
            Text(
              signature[index],
              textAlign: TextAlign.end,
              style: index == signature.length - 1
                  ? _scriptStyle.copyWith(
                      fontSize: 24,
                      height: 29 / 24,
                      color: kColorPrimary700A2402F,
                    )
                  : _scriptStyle.copyWith(
                      fontSize: 20,
                      height: 24 / 20,
                      fontWeight: FontWeight.w400,
                      color: kColorLetterInk4A3F36,
                    ),
            ),
        ],
      ),
    );
  }
}
