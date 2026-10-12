part of '../mobile/event_create_mobile_view.dart';

/// “Người tham gia” (Pencil `ucQ2H`): chip Mama/Papa (avatar chữ 32) + thẻ
/// “Mời cả nhà” (icon `users`, nhãn “Gói Family” `accent-100`, công tắc).
class _EventPeopleSection extends StatelessWidget {
  const _EventPeopleSection({
    required this.people,
    required this.controller,
    required this.chip,
  });

  final List<Member> people;
  final EventCreateController controller;
  final Widget Function(
    BuildContext context, {
    required String label,
    required bool selected,
    required Widget avatar,
    required VoidCallback onTap,
  })
  chip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final event = controller.event;
    return _EventSection(
      label: l10n.calendarParticipants,
      children: [
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: [
            for (final member in people)
              chip(
                context,
                label: member.callName,
                selected: event.participantUserIds.contains(
                  member.userId ?? member.id,
                ),
                avatar: AppInitialAvatar(
                  name: member.callName,
                  size: 32,
                  color: parentAvatarColor(member.role),
                ),
                onTap: () =>
                    controller.toggleParticipant(member.userId ?? member.id),
              ),
          ],
        ),
        AppCard(
          padding: EdgeInsets.zero,
          radius: AppRadius.md,
          child: AppSettingRow(
            icon: LucideIcons.users,
            title: l10n.calendarInviteFamily,
            titleBadge: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorAccent100FDF1D6),
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Text(
                l10n.calendarFamilyPlanTag,
                style: AppTypography.adapt(
                  context,
                  AppTypography.micro.copyWith(
                    fontWeight: FontWeight.w700,
                    color: kColorAccent7009A6A12,
                  ),
                ),
              ),
            ),
            subtitle: l10n.calendarInviteFamilyHint,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardInset,
              vertical: AppSpacing.s3,
            ),
            onTap: () => controller.setInviteFamily(!event.inviteFamily),
            trailing: AppSwitch(
              value: event.inviteFamily,
              onChanged: controller.setInviteFamily,
            ),
          ),
        ),
      ],
    );
  }
}
