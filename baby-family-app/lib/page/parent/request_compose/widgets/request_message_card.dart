part of '../mobile/request_compose_mobile_view.dart';

/// Câu mẫu (Pencil `Pd5UD`): nền `surface` bo 14 đệm 14, chữ 14/1.45 trong
/// ngoặc kép. Chạm để sửa (mục 9.8 “câu mẫu (sửa được)”).
class _RequestMessageCard extends HookWidget {
  const _RequestMessageCard({
    required this.message,
    required this.hint,
    required this.onChanged,
  });

  final String message;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final editing = useState(false);
    final text = useTextEditingController();
    final focus = useFocusNode();
    useEffect(() {
      void listener() {
        if (!focus.hasFocus) {
          editing.value = false;
        }
      }

      focus.addListener(listener);
      return () => focus.removeListener(listener);
    }, [focus]);
    final style = AppTypography.adapt(
      context,
      AppTypography.text14.copyWith(height: 1.45),
    );
    final Widget child;
    if (editing.value) {
      child = TextField(
        controller: text,
        focusNode: focus,
        autofocus: true,
        maxLines: null,
        style: style,
        onChanged: onChanged,
        decoration: InputDecoration.collapsed(hintText: hint),
      );
    } else if (message.isEmpty) {
      child = Text(
        hint,
        style: style.copyWith(
          color: AppColors.resolve(context, kColorTextTertiary9C928A),
        ),
      );
    } else {
      child = Text(context.l10n.commonQuoted(message), style: style);
    }
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: editing.value
            ? null
            : () {
                text.text = message;
                editing.value = true;
              },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}
