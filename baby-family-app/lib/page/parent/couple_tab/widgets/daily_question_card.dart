part of '../mobile/couple_tab_mobile_view.dart';

/// Câu hỏi kết nối hôm nay (Pencil `fW2eP`): nền `surface`, bo 20, đệm 16,
/// nhãn 11/700 `us-500`, câu hỏi 17/700 Nunito, gợi ý 12. Chạm → trả lời.
/// Câu trả lời của bạn đời chỉ hiện khi cả hai đã trả lời (service lo).
class _DailyQuestionCard extends StatelessWidget {
  const _DailyQuestionCard({
    required this.question,
    required this.partnerName,
    required this.onTap,
  });

  final DailyQuestion question;
  final String partnerName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final answerStyle = AppTypography.adapt(
      context,
      AppTypography.text14.copyWith(height: 1.45),
    );
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.usDailyQuestionShort,
                style: AppTypography.tiny.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.resolve(context, kColorUs5009B85D1),
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              Text(
                question.text,
                style: AppTypography.adapt(
                  context,
                  AppTypography.title17.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              Text(
                l10n.usDailyQuestionHintBoth,
                style: AppTypography.adapt(context, AppTypography.small),
              ),
              if (question.myAnswer != null) ...[
                const SizedBox(height: AppSpacing.itemGap),
                Text(
                  l10n.usDailyQuestionAnswerBy(l10n.usYou, question.myAnswer!),
                  style: answerStyle,
                ),
              ],
              if (question.partnerAnswer != null) ...[
                const SizedBox(height: AppSpacing.compact),
                Text(
                  l10n.usDailyQuestionAnswerBy(
                    partnerName,
                    question.partnerAnswer!,
                  ),
                  style: answerStyle,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
