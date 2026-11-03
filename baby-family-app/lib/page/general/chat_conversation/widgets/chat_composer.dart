part of '../mobile/chat_conversation_mobile_view.dart';

/// Ô soạn CHAT-02: nền `surface`, viền trên `border`, đệm 10/16; ô nhập
/// nhiều dòng (tối đa 5) nền `surface-variant` bo 24; nút gửi tròn 44
/// `primary-600` (Papa & Mama `us-500`) icon `send-horizontal` trắng, mờ khi
/// ô trống.
class _ChatComposer extends HookWidget {
  const _ChatComposer({
    required this.controller,
    required this.hint,
    required this.couple,
    required this.onChanged,
    required this.onSend,
  });

  final TextEditingController controller;
  final String hint;
  final bool couple;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = useValueListenable(controller);
    final canSend = text.text.trim().isNotEmpty;
    final accent = AppColors.resolve(
      context,
      couple ? kColorUs5009B85D1 : kColorPrimary600C2513F,
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
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s4,
            AppSpacing.itemGap,
            AppSpacing.s2,
            AppSpacing.itemGap,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  minLines: 1,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(kValueChatBodyMaxLength),
                  ],
                  style: AppTypography.adapt(
                    context,
                    AppTypography.bodyLarge.copyWith(
                      color: AppColors.resolve(
                        context,
                        kColorTextPrimary2E2A27,
                      ),
                    ),
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppTypography.adapt(
                      context,
                      AppTypography.bodyLarge.copyWith(
                        color: AppColors.resolve(
                          context,
                          kColorTextTertiary9C928A,
                        ),
                      ),
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.resolve(
                      context,
                      kColorSurfaceVariantF7F1EC,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s4,
                      vertical: AppSpacing.s3,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.dialog),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox.square(
                dimension: AppSpacing.minTouchTarget,
                child: Center(
                  child: Semantics(
                    button: true,
                    enabled: canSend,
                    label: l10n.chatSend,
                    excludeSemantics: true,
                    child: Material(
                      color: canSend
                          ? accent
                          : AppColors.resolve(context, kColorBorderEADFD6),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: canSend ? onSend : null,
                        child: SizedBox.square(
                          dimension: AppSpacing.iconButton - 4,
                          child: Icon(
                            LucideIcons.sendHorizontal,
                            size: 20,
                            color: AppColors.onPrimary(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
