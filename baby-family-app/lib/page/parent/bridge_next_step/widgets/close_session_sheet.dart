part of '../mobile/bridge_next_step_mobile_view.dart';

/// Mở US-12b “Đóng phiên?” — trả `true` khi đã đóng, `false` khi “Chưa, để
/// sau”, `null` khi vuốt đóng sheet.
Future<bool?> showCloseSessionSheet(
  BuildContext context, {
  required BridgeNextStepController controller,
}) => showAppBottomSheet<bool>(
  context,
  strongScrim: true,
  builder: (_) => _CloseSessionSheet(controller: controller),
);

/// US-12b — Đóng phiên? (Pencil `EjpK0`): vòng 56 `heart-handshake`, tiêu đề
/// 20/800 giữa, “Phiên chỉ đóng khi cả hai cùng đồng ý.”, bước đã chọn
/// (`us-50`, `circle-check` 20), “{bạn đời} đã đồng ý đóng phiên”, lời cảm ơn
/// tuỳ chọn (chip cao 34; chọn: `us-100` viền `us-500`), ghi chú lưu trữ 30
/// ngày, “Đóng phiên” / “Chưa, để sau”.
class _CloseSessionSheet extends HookWidget {
  const _CloseSessionSheet({required this.controller});

  final BridgeNextStepController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = l10n.localeName;
    final partner = controller.partner;
    final partnerName = partner?.callName ?? '';
    final role = partner?.role == FamilyRole.father ? 'father' : 'mother';
    final thanks = [
      l10n.usBridgeThanksListened(role),
      l10n.usBridgeThanksShort(role),
    ];
    final selected = useState<int?>(0);
    final closing = useState(false);
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final step = controller.step;
    final option = controller.selectedOption;
    final session = controller.session;
    final closedOn = (session?.startedAt ?? controller.now).toDayMonth(locale);
    final retentionDays = session?.retentionDays ?? 0;

    String chosenAt() {
      final at = step?.at;
      if (at == null) {
        return step?.whenLabel ?? '';
      }
      final days = controller.now.dateOnly.difference(at.dateOnly).inDays;
      final evening = at.hour >= 18;
      final day = switch (days) {
        0 => evening ? 'tonight' : 'today',
        1 => evening ? 'lastNight' : 'yesterday',
        _ => 'other',
      };
      final time = days > 1
          ? '${at.toDayMonth(locale)} ${at.toDisplayTime(locale)}'
          : at.toDisplayTime(locale);
      return l10n.usBridgeRelativeWhen(day, time);
    }

    Future<void> close() async {
      closing.value = true;
      final index = selected.value;
      final ok = await controller.close(
        thanks: index == null ? null : thanks[index],
      );
      if (context.mounted) {
        closing.value = false;
        if (ok) {
          Navigator.of(context).pop(true);
        }
      }
    }

    return AppBottomSheet(
      gap: AppSpacing.cardInset,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.itemGap,
        AppSpacing.screen,
        28,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.compact),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, kColorUs100EAE2F8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.heartHandshake,
                  size: 28,
                  color: usDark,
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                l10n.usBridgeCloseTitle,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(context, AppTypography.title20),
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                l10n.usBridgeCloseSub,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(context, AppTypography.caption),
              ),
            ],
          ),
        ),
        if (option != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardInset,
              vertical: AppSpacing.s3,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorUs50F6F2FC),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.circleCheck, size: 20, color: usDark),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.text14.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.usBridgeStepChosen(chosenAt()),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (controller.partnerAgreedClose)
          Row(
            children: [
              AppInitialAvatar(
                name: partnerName,
                size: 24,
                color: parentAvatarColor(partner?.role),
              ),
              const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: Text(
                  l10n.usBridgePartnerAgreedClose(partnerName),
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: usDark,
                  ),
                ),
              ),
            ],
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.usBridgeThanksLabel(partnerName),
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: kColorTextPrimary2E2A27,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s2),
            Wrap(
              spacing: AppSpacing.s2,
              runSpacing: AppSpacing.s2,
              children: [
                for (final (index, text) in thanks.indexed)
                  AppSelectableChip(
                    label: text,
                    selected: selected.value == index,
                    filledSelection: false,
                    outlined: true,
                    height: 34,
                    fontSize: 12,
                    padding: AppSpacing.s3,
                    textColor: kColorUs7006A549F,
                    onPressed: () =>
                        selected.value = selected.value == index ? null : index,
                  ),
              ],
            ),
          ],
        ),
        if (retentionDays > 0)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(
                  LucideIcons.timerReset,
                  size: 14,
                  color: AppColors.resolve(context, kColorTextTertiary9C928A),
                ),
              ),
              const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: Text(
                  l10n.usBridgeRetention(retentionDays, closedOn),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.tiny.copyWith(height: 1.4),
                  ),
                ),
              ),
            ],
          ),
        AppButton.us(
          label: l10n.usBridgeCloseConfirm,
          isLoading: closing.value,
          onPressed: close,
        ),
        AppButton.secondary(
          label: l10n.usBridgeCloseLater,
          color: kColorUs7006A549F,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}
