part of '../mobile/bridge_start_mobile_view.dart';

/// Nháp riêng (`hjuBd`): “Viết nháp riêng (tuỳ chọn)” 13/700 + đếm 11; ô cao
/// tối thiểu 116, nền `surface` viền `us-100` bo 16, đệm 14, chữ 14 (dòng
/// 1.4); ghi chú `shield-check` 14 + 12 `us-700` (BR-030).
class _BridgeDraftBox extends HookWidget {
  const _BridgeDraftBox({required this.initialValue, required this.onChanged});

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = useTextEditingController(text: initialValue);
    useListenable(text);
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.usBridgeDraftLabel,
                style: AppTypography.adapt(
                  context,
                  AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: kColorTextPrimary2E2A27,
                  ),
                ),
              ),
            ),
            Text(
              l10n.usBridgeDraftCount(
                text.text.characters.length,
                kValueBridgeDraftMaxLength,
              ),
              style: AppTypography.adapt(context, AppTypography.tiny),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s2),
        Container(
          constraints: const BoxConstraints(minHeight: 116),
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.resolve(context, kColorUs100EAE2F8),
            ),
          ),
          child: TextField(
            controller: text,
            maxLines: null,
            maxLength: kValueBridgeDraftMaxLength,
            onChanged: onChanged,
            style: AppTypography.adapt(
              context,
              AppTypography.text14.copyWith(height: 1.4),
            ),
            decoration: InputDecoration.collapsed(
              hintText: l10n.usBridgeDraftHint,
              hintStyle: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(
                  height: 1.4,
                  color: kColorTextTertiary9C928A,
                ),
              ),
            ).copyWith(counterText: ''),
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(LucideIcons.shieldCheck, size: 14, color: usDark),
            ),
            const SizedBox(width: AppSpacing.compact),
            Expanded(
              child: Text(
                l10n.usBridgeDraftNote,
                style: AppTypography.small.copyWith(height: 1.4, color: usDark),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
