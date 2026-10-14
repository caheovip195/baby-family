part of '../mobile/circle_post_mobile_view.dart';

/// Thanh trên CIR-04 (Pencil “App Bar”): cao 60, đệm ngang 12; nút ✕ 48
/// (icon 26) + tiêu đề 22/800 (CIR-04b chỉ có nút ✕).
class _PostAppBar extends StatelessWidget {
  const _PostAppBar({required this.onClose, this.title});

  final String? title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
        child: Row(
          children: [
            IconButton(
              onPressed: onClose,
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              iconSize: 26,
              constraints: const BoxConstraints.tightFor(
                width: AppSpacing.s12,
                height: AppSpacing.s12,
              ),
              icon: Icon(
                LucideIcons.x,
                color: AppColors.resolve(context, kColorTextPrimary2E2A27),
              ),
            ),
            if (title != null) ...[
              const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: Text(
                  title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
