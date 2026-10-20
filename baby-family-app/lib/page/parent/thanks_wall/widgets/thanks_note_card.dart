part of '../mobile/thanks_wall_mobile_view.dart';

/// Giấy note cảm ơn (Pencil “Note · Papa 06/10”): bo [4,16,16,16], đệm
/// 14/14/12/14, cách 8; băng dính 36×8 trắng 60%; sticker tròn 30 (icon 16);
/// lời nhắn 13; liên kết 11 (`link`); chân: “Papa · 06/10” 11/600 + viên thả
/// tim (đã thả: tim `primary-500` + tên người thả; chưa: `smile-plus`).
class _ThanksNoteCard extends StatelessWidget {
  const _ThanksNoteCard({required this.item, required this.controller});

  final Thanks item;
  final ThanksWallController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mine = controller.isMine(item);
    final dark = AppColors.isDark(context);
    final from = mine ? l10n.usThanksYou : controller.partner?.callName ?? '';
    final reactors = item.reactedByUserIds;
    final String? reactedBy = reactors.contains(controller.myUserId)
        ? l10n.usThanksYou
        : reactors.isNotEmpty
        ? controller.partner?.callName
        : null;
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.cardInset,
        AppSpacing.cardInset,
        AppSpacing.cardInset,
        AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: _noteColor(context, mine: mine),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.s1),
          topRight: Radius.circular(AppRadius.lg),
          bottomLeft: Radius.circular(AppRadius.lg),
          bottomRight: Radius.circular(AppRadius.lg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 8,
              decoration: BoxDecoration(
                color: dark ? kColorWhiteAlpha13 : kColorWhiteAlpha60,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dark ? kColorWhiteAlpha13 : kColorWhiteAlpha70,
            ),
            child: Icon(
              lucideIconByName(item.icon),
              size: 16,
              color: AppColors.resolve(
                context,
                mine ? kColorAccent7009A6A12 : kColorSecondary7003F7A5C,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            item.body,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                height: 19 / 13,
                color: kColorTextPrimary2E2A27,
              ),
            ),
          ),
          if (item.linkedTitle != null) ...[
            const SizedBox(height: AppSpacing.s2),
            Row(
              children: [
                Icon(LucideIcons.link, size: 11, color: secondary),
                const SizedBox(width: AppSpacing.s1),
                Expanded(
                  child: Text(
                    item.linkedTitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.tiny.copyWith(
                        color: kColorTextSecondary6B625B,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (controller.awaitsMyShareDecision(item)) ...[
            const SizedBox(height: AppSpacing.s2),
            _ThanksShareDecision(item: item, controller: controller),
          ],
          const SizedBox(height: AppSpacing.s2),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.usThanksByLine(
                    from,
                    item.createdAt.toDayMonth(l10n.localeName),
                  ),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.tiny.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ),
              Semantics(
                button: true,
                label: l10n.usThanksReact,
                child: Material(
                  color: dark
                      ? kColorWhiteAlpha13
                      : reactedBy == null
                      ? kColorWhiteAlpha40
                      : kColorWhiteAlpha80,
                  shape: const StadiumBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => controller.toggleHeart(item),
                    child: Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            reactedBy == null
                                ? LucideIcons.smilePlus
                                : LucideIcons.heart,
                            size: 12,
                            color: reactedBy == null
                                ? secondary
                                : AppColors.resolve(
                                    context,
                                    kColorPrimary500EE7B67,
                                  ),
                          ),
                          if (reactedBy != null) ...[
                            const SizedBox(width: 3),
                            Text(
                              reactedBy,
                              style: AppTypography.adapt(
                                context,
                                AppTypography.tiny.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kColorTextSecondary6B625B,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bạn đời đề nghị đăng lời cảm ơn thành khoảnh khắc gia đình: người nhận
/// “Đăng cho cả nhà” (tạo ký ức) hoặc “Để riêng hai mình”.
class _ThanksShareDecision extends StatelessWidget {
  const _ThanksShareDecision({required this.item, required this.controller});

  final Thanks item;
  final ThanksWallController controller;

  Future<void> _respond(BuildContext context, {required bool approve}) async {
    final messenger = ScaffoldMessenger.of(context);
    final failed = context.l10n.usThanksShareFailed;
    final ok = await controller.respondShare(item, approve: approve);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(failed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.usThanksShareAsk(controller.partner?.callName ?? ''),
          style: AppTypography.adapt(
            context,
            AppTypography.tiny.copyWith(color: kColorTextSecondary6B625B),
          ),
        ),
        const SizedBox(height: AppSpacing.s1),
        AppButton.us(
          label: l10n.usThanksShareApprove,
          height: 32,
          fontSize: 12,
          horizontalPadding: AppSpacing.s2,
          onPressed: () => _respond(context, approve: true),
        ),
        AppButton.text(
          label: l10n.usThanksShareKeep,
          height: 28,
          fontSize: 12,
          onPressed: () => _respond(context, approve: false),
        ),
      ],
    );
  }
}
