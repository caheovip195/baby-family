part of '../mobile/circle_home_mobile_view.dart';

/// Sheet “Gửi lời chúc”: ô nhập + nút Gửi (lời chúc lưu như bình luận).
/// Trả `true` khi đã gửi.
class _WishSheet extends HookWidget {
  const _WishSheet({required this.childName, required this.onSend});

  final String childName;
  final Future<bool> Function(String body) onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = useTextEditingController();
    final sending = useState(false);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AppBottomSheet(
        title: l10n.circleSendWish,
        children: [
          AppTextField(
            controller: text,
            hint: l10n.cirWishHint(childName),
            maxLines: 3,
            autofocus: true,
          ),
          AppButton(
            label: l10n.cirWishSend,
            isLoading: sending.value,
            onPressed: () async {
              sending.value = true;
              final sent = await onSend(text.text);
              if (context.mounted) {
                Navigator.of(context).pop(sent);
              }
            },
          ),
        ],
      ),
    );
  }
}
