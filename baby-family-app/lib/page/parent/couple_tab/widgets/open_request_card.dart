part of '../mobile/couple_tab_mobile_view.dart';

/// Lời nhờ đang mở (Pencil `PPjiW`): nền `us-100`, bo 20, đệm 14, icon
/// `hand-helping` 24 + tiêu đề 14/700 + trạng thái 12 `us-700`. Chạm → US-04.
class _OpenRequestCard extends StatelessWidget {
  const _OpenRequestCard({
    required this.request,
    required this.controller,
    required this.onTap,
  });

  final CoupleRequest request;
  final CoupleTabController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.resolve(context, kColorUs7006A549F);
    return Material(
      color: AppColors.resolve(context, kColorUs100EAE2F8),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          child: Row(
            children: [
              Icon(LucideIcons.handHelping, size: 24, color: accent),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title(context),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _status(context),
                      style: AppTypography.small.copyWith(color: accent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _mine => request.senderId == controller.myUserId;

  String _title(BuildContext context) {
    final l10n = context.l10n;
    final partner = controller.partner?.callName ?? '';
    if (!_mine) {
      return l10n.usOpenRequestTheirs(partner, request.title);
    }
    final child = request.childIds.length == 1
        ? controller.childById(request.childIds.first)
        : null;
    final minutes = request.durationMin;
    if (request.kind == RequestKind.task && child != null && minutes != null) {
      return l10n.usOpenRequestWatch(partner, child.name, minutes);
    }
    return l10n.usOpenRequestMine(partner, request.title);
  }

  String _status(BuildContext context) {
    final l10n = context.l10n;
    final at = switch (request.status) {
      RequestStatus.accepted => request.acceptedAt,
      RequestStatus.seen => request.seenAt,
      _ => null,
    };
    final time = (at ?? request.sentAt).toDisplayTime(context.localeName);
    return _mine
        ? l10n.usRequestStatusPartner(
            request.status.name,
            controller.partner?.callName ?? '',
            time,
          )
        : l10n.usRequestStatusMine(request.status.name, time);
  }
}
