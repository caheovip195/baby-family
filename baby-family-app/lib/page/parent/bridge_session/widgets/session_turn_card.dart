part of '../mobile/bridge_session_mobile_view.dart';

/// “Lượt của bạn” (`T46H41`): `surface` bo 20, đệm 16, cách 12; nhãn 11/700
/// `us-700` + “{bạn đời} đã đọc xong” 11; câu hỏi 17/800; “Mình cần nói rõ
/// hơn” (viền `us-700`) + “Mình hiểu” (`us-700`), 14; ghi chú 11. Sau khi tôi
/// đã hiểu: chờ bạn đời, hoặc sang bước tiếp theo khi cả hai đã hiểu.
class _SessionTurnCard extends StatelessWidget {
  const _SessionTurnCard({
    required this.partnerName,
    required this.partnerReadDone,
    required this.understood,
    required this.busy,
    required this.onClarify,
    required this.onUnderstand,
    required this.onNext,
  });

  final String partnerName;
  final bool partnerReadDone;
  final bool understood;
  final bool busy;
  final VoidCallback onClarify;
  final VoidCallback onUnderstand;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    final note = AppTypography.adapt(
      context,
      AppTypography.tiny.copyWith(height: 1.4),
    );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.usBridgeYourTurn,
                  style: AppTypography.tiny.copyWith(
                    fontWeight: FontWeight.w700,
                    color: usDark,
                  ),
                ),
              ),
              if (partnerReadDone)
                Flexible(
                  child: Text(
                    l10n.usBridgePartnerReadDone(partnerName),
                    textAlign: TextAlign.end,
                    style: note,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Text(
            l10n.usBridgeReadQuestion(partnerName),
            style: AppTypography.adapt(context, AppTypography.title17),
          ),
          const SizedBox(height: AppSpacing.s3),
          if (!understood) ...[
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    label: l10n.usBridgeClarify,
                    color: kColorUs7006A549F,
                    fontSize: 14,
                    horizontalPadding: AppSpacing.s3,
                    onPressed: busy ? null : onClarify,
                  ),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: AppButton.us(
                    label: l10n.usBridgeUnderstand,
                    fontSize: 14,
                    horizontalPadding: AppSpacing.s3,
                    isLoading: busy,
                    onPressed: onUnderstand,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s3),
            Text(l10n.usBridgeClarifyNote, style: note),
          ] else if (onNext != null)
            AppButton.us(label: l10n.usBridgeNextStepTitle, onPressed: onNext)
          else
            Text(l10n.usBridgeWaiting(partnerName), style: note),
        ],
      ),
    );
  }
}
