part of '../mobile/bridge_next_step_mobile_view.dart';

/// Xác nhận của một người (`iNy82`): đệm 10/12, cách 8, bo 16 viền `us-100`
/// (đã đồng ý: nền `us-100`); avatar 28; tên 13/700 + “Chưa xác nhận” 11
/// `text-tertiary` / “Đã đồng ý” `us-700`; `circle-dashed` / `circle-check`
/// 18.
class _NextStepConfirmation extends StatelessWidget {
  const _NextStepConfirmation({
    required this.member,
    required this.name,
    required this.agreed,
  });

  final Member? member;
  final String name;
  final bool agreed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stateColor = AppColors.resolve(
      context,
      agreed ? kColorUs7006A549F : kColorTextTertiary9C928A,
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.itemGap,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(
          context,
          agreed ? kColorUs100EAE2F8 : kColorSurfaceFFFFFF,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorUs100EAE2F8),
        ),
      ),
      child: Row(
        children: [
          AppInitialAvatar(
            name: member?.callName ?? name,
            size: 28,
            color: parentAvatarColor(member?.role),
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: kColorTextPrimary2E2A27,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  agreed ? l10n.usBridgeAgreed : l10n.usBridgeNotConfirmed,
                  style: AppTypography.tiny.copyWith(color: stateColor),
                ),
              ],
            ),
          ),
          Icon(
            agreed ? LucideIcons.circleCheck : LucideIcons.circleDashed,
            size: 18,
            color: stateColor,
          ),
        ],
      ),
    );
  }
}
