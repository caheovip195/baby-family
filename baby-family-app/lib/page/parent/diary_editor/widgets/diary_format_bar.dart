part of '../mobile/diary_editor_mobile_view.dart';

/// Thanh định dạng (`M2o1m7`): nền `surface`, viền trên, đệm 8/12/30/12,
/// cách 4; nút 40 bo 10 (đang bật: nền `surface-variant`, icon
/// `text-primary`; tắt: `text-secondary`) — đậm • nghiêng • danh sách •
/// đánh số | chèn ảnh • tiêu đề … ẩn bàn phím.
class _DiaryFormatBar extends StatelessWidget {
  const _DiaryFormatBar({required this.controller});

  final DiaryEditorController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final block = controller.focusedBlock;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    final bottom = MediaQuery.paddingOf(context).bottom;
    Widget button(
      IconData icon,
      String label,
      VoidCallback onTap, {
      bool active = false,
    }) => Semantics(
      button: true,
      selected: active,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: active
            ? AppColors.resolve(context, kColorSurfaceVariantF7F1EC)
            : kColorTransparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: SizedBox.square(
            dimension: 40,
            child: Icon(
              icon,
              size: 20,
              color: AppColors.resolve(
                context,
                active ? kColorTextPrimary2E2A27 : kColorTextSecondary6B625B,
              ),
            ),
          ),
        ),
      ),
    );
    const gap = SizedBox(width: AppSpacing.s1);
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s3,
        AppSpacing.s2,
        AppSpacing.s3,
        keyboard ? AppSpacing.s2 : (bottom > 0 ? bottom : 30),
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        border: Border(
          top: BorderSide(
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
        ),
      ),
      child: Row(
        children: [
          button(
            LucideIcons.bold,
            l10n.memFormatBold,
            controller.toggleBold,
            active: block?.bold ?? false,
          ),
          gap,
          button(
            LucideIcons.italic,
            l10n.memFormatItalic,
            controller.toggleItalic,
            active: block?.italic ?? false,
          ),
          gap,
          button(
            LucideIcons.list,
            l10n.memFormatList,
            () => controller.toggleKind(DiaryBlockKind.bullet),
            active: block?.kind == DiaryBlockKind.bullet,
          ),
          gap,
          button(
            LucideIcons.listOrdered,
            l10n.memFormatNumbered,
            () => controller.toggleKind(DiaryBlockKind.numbered),
            active: block?.kind == DiaryBlockKind.numbered,
          ),
          Container(
            width: 1,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
          button(
            LucideIcons.imagePlus,
            l10n.memFormatImage,
            controller.insertPhoto,
          ),
          gap,
          button(
            LucideIcons.heading,
            l10n.memFormatHeading,
            () => controller.toggleKind(DiaryBlockKind.heading),
            active: block?.kind == DiaryBlockKind.heading,
          ),
          const Spacer(),
          button(
            LucideIcons.chevronDown,
            l10n.memFormatHideKeyboard,
            () => FocusScope.of(context).unfocus(),
          ),
        ],
      ),
    );
  }
}
