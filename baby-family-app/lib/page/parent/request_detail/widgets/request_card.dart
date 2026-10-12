part of '../mobile/request_detail_mobile_view.dart';

/// Thẻ lời nhờ (Pencil `Q0R4W`): nền `surface` viền `us-100` bo 20 đệm 16 —
/// người gửi (avatar 40 `primary-500`, “Mama nhờ bạn”, thời gian, nhãn), tiêu
/// đề 20/800, lời nhắn trên nền `us-50`, chip bé / khi nào / bao lâu.
class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.controller, required this.request});

  final RequestDetailController controller;
  final CoupleRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final senderName = controller.sender?.callName ?? '';
    final partnerName = controller.partner?.callName ?? '';
    final tag = _tag(context);
    final due = switch (request.dueLabel) {
      'now' => l10n.usRequestNow,
      'tonight' => l10n.usRequestTonight,
      _ => request.dueAt?.toDisplayTime(context.localeName),
    };
    final chips = <Widget>[
      for (final child in controller.requestChildren)
        _RequestInfoChip(label: child.name, child: child),
      if (due != null)
        _RequestInfoChip(label: due, icon: LucideIcons.alarmClock),
      if (request.durationMin != null)
        _RequestInfoChip(
          label: l10n.usRequestMinutes(request.durationMin!),
          icon: LucideIcons.timer,
        ),
    ];
    final message = request.message;
    final items = <Widget>[
      Row(
        children: [
          AppInitialAvatar(
            name: senderName,
            size: 40,
            color: kColorPrimary500EE7B67,
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.isSender
                      ? l10n.usRequestYouAsked(partnerName)
                      : l10n.usRequestBy(senderName),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  relativeTimeText(
                    l10n,
                    request.sentAt,
                    controller.now,
                    locale: context.localeName,
                  ),
                  style: AppTypography.adapt(context, AppTypography.small),
                ),
              ],
            ),
          ),
          ?tag,
        ],
      ),
      Text(
        request.title,
        style: AppTypography.adapt(
          context,
          AppTypography.title20.copyWith(height: 1.25),
        ),
      ),
      if (message != null && message.isNotEmpty)
        Container(
          padding: const EdgeInsets.all(AppSpacing.s3),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorUs50F6F2FC),
            borderRadius: BorderRadius.circular(AppRadius.tile),
          ),
          child: Text(
            l10n.commonQuoted(message),
            style: AppTypography.adapt(
              context,
              AppTypography.text14.copyWith(height: 1.45),
            ),
          ),
        ),
      if (chips.isNotEmpty)
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: chips,
        ),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.resolve(context, kColorUs100EAE2F8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.s3),
            items[index],
          ],
        ],
      ),
    );
  }

  /// Nhãn trạng thái: “Sớm nhé” (`accent-100`) khi chờ trả lời, “Đã nhận” /
  /// “Đã xong” (`secondary-100`/`secondary-700`), còn lại `us-100`/`us-700`.
  Widget? _tag(BuildContext context) {
    final l10n = context.l10n;
    final status = request.status;
    final pending =
        status == RequestStatus.sent || status == RequestStatus.seen;
    final String label;
    final Color background;
    final Color foreground;
    if (pending && !controller.isSender) {
      if (request.urgency != RequestUrgency.soon) {
        return null;
      }
      label = l10n.usRequestSoon;
      background = kColorAccent100FDF1D6;
      foreground = kColorTextPrimary2E2A27;
    } else if (status == RequestStatus.accepted ||
        status == RequestStatus.done) {
      label = status == RequestStatus.accepted
          ? l10n.usRequestAcceptedBadge
          : l10n.usRequestBadge(status.name);
      background = kColorSecondary100E4F2EA;
      foreground = kColorSecondary7003F7A5C;
    } else {
      label = l10n.usRequestBadge(status.name);
      background = kColorUs100EAE2F8;
      foreground = kColorUs7006A549F;
    }
    return Container(
      margin: const EdgeInsets.only(left: AppSpacing.s2),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.itemGap,
        vertical: AppSpacing.s1,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, background),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.tiny.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.resolve(context, foreground),
        ),
      ),
    );
  }
}
