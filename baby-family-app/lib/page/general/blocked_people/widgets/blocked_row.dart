part of '../mobile/blocked_people_mobile_view.dart';

/// Dòng người bị chặn (Pencil “Cô Hạnh”): đệm 14/16, cách 12; avatar chữ 44
/// nền `surface-variant` (15/800 `text-secondary`), tên 15/600, nơi gặp 12,
/// “Chặn từ …” 12 `text-tertiary`, viên “Bỏ chặn” viền `primary-600`.
class _BlockedRow extends StatelessWidget {
  const _BlockedRow({required this.person, required this.onUnblock});

  final BlockedPerson person;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final blockedAt = person.blockedAt;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.cardInset,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
              shape: BoxShape.circle,
            ),
            child: Text(
              nameInitials(person.name),
              style: AppTypography.adapt(
                context,
                AppTypography.title16.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: kColorTextSecondary6B625B,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.bodyStrong.copyWith(height: 19 / 15),
                  ),
                ),
                if (person.context != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    person.context!,
                    style: AppTypography.adapt(context, AppTypography.small),
                  ),
                ],
                if (blockedAt != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    l10n.setBlockedSince(
                      blockedAt.toFormDate(context.localeName),
                    ),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        color: kColorTextTertiary9C928A,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          AppPillButton(
            label: l10n.setUnblock,
            height: 32,
            outlined: true,
            borderColor: kColorPrimary600C2513F,
            foreground: kColorPrimary600C2513F,
            onPressed: onUnblock,
          ),
        ],
      ),
    );
  }
}
