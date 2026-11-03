part of '../mobile/year_book_mobile_view.dart';

/// Bản cho ông bà (BF-20261030-002): bật để người thân được xem bé (sách cả
/// nhà: mọi người thân) đọc bản đã lưu; gói chưa có Family Circle thì khoá +
/// “Nâng cấp”.
class _ShareCard extends StatelessWidget {
  const _ShareCard({required this.controller});

  final YearBookController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final book = controller.book!;
    if (!book.canShare) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInfoNote(icon: LucideIcons.users, text: l10n.yearBookShareLocked),
          AppTextAction(
            label: l10n.yearBookUpgrade,
            onPressed: () => context.router.push(const UpgradePlanRoute()),
          ),
        ],
      );
    }
    return AppCard(
      child: AppToggleRow(
        icon: LucideIcons.users,
        title: l10n.yearBookShareTitle,
        subtitle: l10n.yearBookShareHint,
        value: book.sharedWithCircle,
        onChanged: controller.setShared,
      ),
    );
  }
}
