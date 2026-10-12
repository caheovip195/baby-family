part of '../mobile/care_tab_mobile_view.dart';

/// Nội dung tab đang chọn của CARE-01:
/// - Của tôi: Hearts của tôi hôm nay + thẻ có ✓ (nhấn giữ nhiệm vụ hệ thống
///   → CARE-05);
/// - Của bạn đời: ghi chú quyền riêng tư, “đã xong cả …”, chỉ ✓ + 💛 Cảm ơn;
/// - Cùng nhau: một trong hai bấm “Xong cùng nhau”.
class _CareMissionList extends StatelessWidget {
  const _CareMissionList({required this.controller});

  final CareTabController controller;

  @override
  Widget build(BuildContext context) {
    final board = controller.board!;
    final l10n = context.l10n;
    final tab = controller.tabIndex;
    final missions = switch (tab) {
      0 => board.mine,
      1 => board.partner,
      _ => board.together,
    };
    final callName = controller.partnerCallName;
    final header = <Widget>[
      if (tab == 0) _CareMyHeartsRow(hearts: board.heartsToday),
      if (tab == 1) _CarePartnerNote(callName: callName),
      if (tab == 1 &&
          missions.isNotEmpty &&
          missions.every((mission) => mission.isDone))
        _CareAllDoneBanner(
          text: l10n.carePartnerAllDone(callName, missions.length),
        ),
    ];
    final emptyText = switch (tab) {
      0 => l10n.careMineEmpty,
      1 => l10n.carePartnerEmpty(callName),
      _ => l10n.careTogetherEmpty,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in header) ...[
          item,
          const SizedBox(height: AppSpacing.s3),
        ],
        if (missions.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
            child: Text(
              emptyText,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(context, AppTypography.caption),
            ),
          ),
        for (var index = 0; index < missions.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.itemGap),
          _card(context, missions[index]),
        ],
      ],
    );
  }

  Widget _card(BuildContext context, Mission mission) {
    final l10n = context.l10n;
    final partner = mission.ownerKind == MissionOwnerKind.partner;
    final canSwap =
        mission.ownerKind == MissionOwnerKind.me &&
        mission.source == MissionSource.system &&
        !mission.isDone &&
        controller.isToday;
    Widget? trailing;
    if (partner && mission.isDone) {
      final thanked = mission.thankedByPartner;
      trailing = AppPillButton(
        label: thanked ? l10n.careThanked : l10n.careThank,
        icon: LucideIcons.heart,
        height: 34,
        fontSize: 12,
        iconSize: 14,
        horizontalPadding: AppSpacing.s3,
        color: thanked ? kColorPrimary100FFE3DC : kColorSurfaceVariantF7F1EC,
        foreground: thanked
            ? kColorPrimary700A2402F
            : kColorTextSecondary6B625B,
        onPressed: thanked ? null : () => controller.thank(mission),
      );
    }
    return MissionCard(
      key: ValueKey(mission.id),
      title: mission.title,
      meta: careMissionMetaText(l10n, mission),
      done: mission.isDone,
      dimDone: !partner,
      child: controller.childOf(mission),
      trailing: trailing,
      onToggle: partner || mission.isDone
          ? null
          : () => _completeMission(context, controller, mission),
      onTap: () =>
          context.router.push(MissionDetailRoute(missionId: mission.id)),
      onLongPress: canSwap
          ? () => _openSwap(context, controller, mission)
          : null,
    );
  }
}
