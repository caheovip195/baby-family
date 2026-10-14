part of '../mobile/circle_memory_detail_mobile_view.dart';

/// Ảnh lớn (Pencil “Hero Photo” cao 380) chạy dưới thanh trạng thái, nút
/// quay lại và ⋯ cách lề 16.
class _HeroPhoto extends StatelessWidget {
  const _HeroPhoto({
    required this.asset,
    required this.onBack,
    required this.onMore,
  });

  static const _height = 380.0;

  final String? asset;
  final VoidCallback onBack;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final image = asset;
    return SizedBox(
      height: _height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (image != null)
            Image.asset(image, fit: BoxFit.cover)
          else
            ColoredBox(
              color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
            ),
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _RoundIconButton(
                      icon: LucideIcons.chevronLeft,
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).backButtonTooltip,
                      color: kColorOverlay2E2A27Alpha40,
                      foreground: kColorWhite,
                      onTap: onBack,
                    ),
                    _RoundIconButton(
                      icon: LucideIcons.ellipsis,
                      tooltip: l10n.memMoreActions,
                      color: kColorWhite,
                      foreground: kColorTextPrimary2E2A27,
                      onTap: onMore,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
