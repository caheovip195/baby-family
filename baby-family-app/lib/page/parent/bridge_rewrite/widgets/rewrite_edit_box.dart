part of '../mobile/bridge_rewrite_mobile_view.dart';

/// “Sửa trước khi dùng” (`cq9il`): nhãn 13/700; ô `surface` viền `us-500` bo
/// 16, đệm 14, chữ 14 (dòng 1.4).
class _RewriteEditBox extends HookWidget {
  const _RewriteEditBox({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = useTextEditingController(text: initialValue);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.usBridgeRewriteEdit,
          style: AppTypography.adapt(
            context,
            AppTypography.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: kColorTextPrimary2E2A27,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.resolve(context, kColorUs5009B85D1),
            ),
          ),
          child: TextField(
            controller: text,
            maxLines: null,
            onChanged: onChanged,
            style: AppTypography.adapt(
              context,
              AppTypography.text14.copyWith(height: 1.4),
            ),
            decoration: const InputDecoration.collapsed(hintText: null),
          ),
        ),
      ],
    );
  }
}
