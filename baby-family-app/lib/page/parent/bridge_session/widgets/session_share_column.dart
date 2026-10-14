part of '../mobile/bridge_session_mobile_view.dart';

/// Một cột chia sẻ (`hC6hi`): `surface` viền `us-100` bo 16, đệm 12, cách
/// 10; đầu cột avatar 28 + tên 13/700; “{tên} cảm thấy” / “{tên} cần” 11/600
/// `text-tertiary` + viên giá trị xếp dọc ([pillColor]); lời nhắn 12 (dòng
/// 1.4) `text-secondary`; trạng thái cao 30 bo 10 (đã hiểu: `us-100` +
/// `check`; chưa: `surface-variant` + `hourglass`).
class _SessionShareColumn extends StatelessWidget {
  const _SessionShareColumn({
    required this.title,
    required this.avatar,
    required this.feelsLabel,
    required this.needsLabel,
    required this.feelings,
    required this.needs,
    required this.message,
    required this.pillColor,
    required this.understood,
    required this.status,
  });

  final String title;
  final Widget avatar;
  final String feelsLabel;
  final String needsLabel;
  final List<String> feelings;
  final List<String> needs;
  final String? message;
  final Color pillColor;
  final bool understood;
  final String status;

  @override
  Widget build(BuildContext context) {
    final statusColor = AppColors.resolve(
      context,
      understood ? kColorUs7006A549F : kColorTextTertiary9C928A,
    );
    Widget group(String label, List<String> values) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.adapt(
            context,
            AppTypography.tiny.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        for (final value in values) ...[
          const SizedBox(height: AppSpacing.compact),
          AppValuePill(
            label: value,
            color: pillColor,
            foreground: kColorTextPrimary2E2A27,
          ),
        ],
      ],
    );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorUs100EAE2F8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              avatar,
              const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: kColorTextPrimary2E2A27,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          group(feelsLabel, feelings),
          const SizedBox(height: AppSpacing.itemGap),
          group(needsLabel, needs),
          if (message != null && message!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.itemGap),
            Text(
              context.l10n.commonQuoted(message!.trim()),
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(height: 1.4),
              ),
            ),
          ],
          const Spacer(),
          const SizedBox(height: AppSpacing.itemGap),
          Container(
            constraints: const BoxConstraints(minHeight: 30),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
            decoration: BoxDecoration(
              color: AppColors.resolve(
                context,
                understood ? kColorUs100EAE2F8 : kColorSurfaceVariantF7F1EC,
              ),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  understood ? LucideIcons.check : LucideIcons.hourglass,
                  size: 13,
                  color: statusColor,
                ),
                const SizedBox(width: AppSpacing.compact),
                Flexible(
                  child: Text(
                    status,
                    style: AppTypography.tiny.copyWith(
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
