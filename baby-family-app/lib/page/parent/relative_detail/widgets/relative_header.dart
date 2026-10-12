part of '../mobile/relative_detail_mobile_view.dart';

/// Đầu trang FAM-04 (Pencil `a1rsfy`): avatar chữ 84, tên 22/800, “Quan hệ:
/// Bà ngoại · Tham gia 12/08/2026” 13, viên trạng thái “Hoạt động 2 giờ
/// trước” (`secondary-100`, chấm `secondary-500`).
class _RelativeHeader extends StatelessWidget {
  const _RelativeHeader({required this.member, required this.now});

  final Member member;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    final relation = relativeRelationLabel(
      l10n,
      member.relation,
      fallback: member.callName,
    );
    final joinedAt = member.joinedAt;
    final lastActive = member.lastActiveAt;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s1, bottom: 6),
      child: Column(
        children: [
          AppRelativeAvatar(
            name: member.callName,
            relation: member.relation,
            size: 84,
          ),
          const SizedBox(height: 6),
          Text(
            member.callName,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(
              context,
              AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            joinedAt == null
                ? relation
                : l10n.famRelativeSince(relation, joinedAt.toFormDate(locale)),
            textAlign: TextAlign.center,
            style: AppTypography.adapt(context, AppTypography.caption),
          ),
          if (member.status == MemberStatus.pending) ...[
            const SizedBox(height: 6),
            AppTagPill(
              label: l10n.famRelativePending,
              color: kColorAccent100FDF1D6,
              foreground: kColorTextPrimary2E2A27,
            ),
          ] else if (lastActive != null) ...[
            const SizedBox(height: 6),
            AppTagPill(
              label: l10n.famRelativeActive(
                relativeTimeText(l10n, lastActive, now, locale: locale),
              ),
              dotColor: kColorSecondary5006FAE8E,
            ),
          ],
        ],
      ),
    );
  }
}
