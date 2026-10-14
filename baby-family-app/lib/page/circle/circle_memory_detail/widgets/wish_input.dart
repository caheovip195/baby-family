part of '../mobile/circle_memory_detail_mobile_view.dart';

/// Ô viết lời chúc (Pencil “Comment Input”): nền `surface` viền trên, đệm
/// [12,16,28,16]; ô viên 56 `surface-variant` chữ 17; nút ghi âm 56
/// (`secondary-100`, `mic`) và gửi 56 (`primary-600`, `send-horizontal`).
class _WishInput extends HookWidget {
  const _WishInput({required this.focusNode, required this.onSend});

  final FocusNode focusNode;
  final Future<bool> Function(String body) onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = useTextEditingController();
    final bottom = MediaQuery.paddingOf(context).bottom;
    Future<void> send() async {
      final sent = await onSend(text.text);
      if (sent) {
        text.clear();
        focusNode.unfocus();
      }
    }

    Widget round(
      IconData icon,
      String label,
      Color color,
      Color foreground,
      VoidCallback onTap,
    ) => Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: AppColors.resolve(context, color),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox.square(
            dimension: 56,
            child: Icon(
              icon,
              size: 24,
              color: AppColors.resolve(context, foreground),
            ),
          ),
        ),
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        border: Border(
          top: BorderSide(
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.s4,
          AppSpacing.s3,
          AppSpacing.s4,
          bottom > 28 ? bottom : 28,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 56),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: TextField(
                  controller: text,
                  focusNode: focusNode,
                  minLines: 1,
                  maxLines: 3,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => send(),
                  style: AppTypography.adapt(context, AppTypography.bodyLarge),
                  decoration: bareInputDecoration(
                    hint: l10n.cirDetailWishHint,
                    hintStyle: AppTypography.adapt(
                      context,
                      AppTypography.bodyLarge.copyWith(
                        color: kColorTextTertiary9C928A,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            round(
              LucideIcons.mic,
              l10n.cirDetailVoice,
              kColorSecondary100E4F2EA,
              kColorSecondary7003F7A5C,
              () => showComingSoonSnackBar(context),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            round(
              LucideIcons.sendHorizontal,
              l10n.cirDetailSend,
              kColorPrimary600C2513F,
              kColorWhite,
              send,
            ),
          ],
        ),
      ),
    );
  }
}
