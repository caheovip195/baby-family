part of '../mobile/child_archive_mobile_view.dart';

/// Xác nhận 2/2 (Pencil CHD-05b “Name field”): ô `surface` cao 52 bo 14 viền
/// `primary-500`, chữ 16/500; gõ đúng tên → `circle-check` `success`; gợi ý
/// “Gõ đúng “Khang” để mở nút xoá.” 12 `text-tertiary`.
class _DeleteNameField extends HookWidget {
  const _DeleteNameField({required this.controller});

  final ChildArchiveController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = useTextEditingController(text: controller.typedName);
    final name = controller.child?.name ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.fieldHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardInset),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: AppColors.resolve(context, kColorPrimary500EE7B67),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: text,
                  onChanged: controller.typeName,
                  textInputAction: TextInputAction.done,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.bodyLarge.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  decoration: bareInputDecoration(),
                ),
              ),
              if (controller.nameMatches) ...[
                const SizedBox(width: AppSpacing.s2),
                Icon(
                  LucideIcons.circleCheck,
                  size: 20,
                  color: AppColors.resolve(context, kColorSuccess3E9B6E),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        Text(
          l10n.chdDeleteHint(name),
          style: AppTypography.adapt(
            context,
            AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
          ),
        ),
      ],
    );
  }
}
