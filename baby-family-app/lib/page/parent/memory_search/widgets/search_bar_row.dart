part of '../mobile/memory_search_mobile_view.dart';

/// Thanh tìm (`ExCzJ`): cao 56, đệm trái 20 phải 16, cách 10; ô 44 nền
/// `surface`, viền `primary-500`, bo 14, đệm 12 — `search` 18, chữ 15/500,
/// nút xoá 20 tròn `text-tertiary` (`x` 12 trắng); “Huỷ” 15/600 `primary-700`.
class _SearchBarRow extends StatelessWidget {
  const _SearchBarRow({required this.controller});

  final MemorySearchController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(
        color: AppColors.resolve(context, kColorPrimary500EE7B67),
      ),
    );
    final style = AppTypography.body.copyWith(
      fontWeight: FontWeight.w500,
      height: 19 / 15,
      letterSpacing: 0,
    );
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.s4,
          0,
        ),
        child: Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller.input,
                builder: (context, value, _) => TextField(
                  controller: controller.input,
                  focusNode: controller.focus,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => controller.search(),
                  style: AppTypography.adapt(context, style),
                  cursorColor: AppColors.resolve(
                    context,
                    kColorPrimary600C2513F,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.memSearchHint,
                    hintMaxLines: 1,
                    hintStyle: style.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.resolve(
                        context,
                        kColorTextTertiary9C928A,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.resolve(context, kColorSurfaceFFFFFF),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    prefixIcon: Icon(
                      LucideIcons.search,
                      size: 18,
                      color: AppColors.resolve(
                        context,
                        kColorTextSecondary6B625B,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 38),
                    suffixIcon: value.text.isEmpty
                        ? null
                        : Semantics(
                            button: true,
                            label: l10n.commonClose,
                            excludeSemantics: true,
                            child: GestureDetector(
                              onTap: controller.clear,
                              child: Center(
                                widthFactor: 1,
                                heightFactor: 1,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.resolve(
                                      context,
                                      kColorTextTertiary9C928A,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    LucideIcons.x,
                                    size: 12,
                                    color: kColorWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    suffixIconConstraints: const BoxConstraints(minWidth: 32),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.itemGap),
            TextButton(
              onPressed: () => context.router.maybePop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(AppSpacing.s10, AppSpacing.s10),
              ),
              child: Text(
                l10n.commonCancel,
                style: AppTypography.label.copyWith(
                  height: 19 / 15,
                  color: AppColors.resolve(context, kColorPrimary700A2402F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
