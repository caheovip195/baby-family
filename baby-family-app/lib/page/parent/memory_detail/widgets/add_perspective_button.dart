part of '../mobile/memory_detail_mobile_view.dart';

/// Nút “Thêm góc nhìn của bạn” (tài liệu 7.8.6 — bạn đời chưa kể): cùng
/// ngôn ngữ khối “Papa kể” — nền `us-50`, viền `us-100`, bo 16, cao 52,
/// icon `heart-handshake` 18 + chữ 14/700 `us-700`.
class _AddPerspectiveButton extends StatelessWidget {
  const _AddPerspectiveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.resolve(context, kColorUs7006A549F);
    return Material(
      color: AppColors.resolve(context, kColorUs50F6F2FC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.resolve(context, kColorUs100EAE2F8)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.buttonHeight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.heartHandshake, size: 18, color: accent),
              const SizedBox(width: AppSpacing.s2),
              Flexible(
                child: Text(
                  context.l10n.memoriesAddPerspective,
                  style: AppTypography.text14.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accent,
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
