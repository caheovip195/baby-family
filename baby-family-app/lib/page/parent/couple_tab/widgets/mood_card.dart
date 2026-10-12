part of '../mobile/couple_tab_mobile_view.dart';

/// Ô cảm xúc “Hôm nay của hai ta” (Pencil `zldeN`/`lVbKY`): nền `surface`,
/// viền `us-100`, bo 20, đệm 14; avatar chữ 28 (Papa/Mama theo slot), emoji
/// 34, nhãn 18/800, dòng phụ 12. Ô của tôi chưa check-in → “Hôm nay bạn thế
/// nào?”; ô bạn đời chưa chia sẻ → “Chưa chia sẻ”.
class _MoodCard extends StatelessWidget {
  const _MoodCard({
    required this.member,
    required this.isMe,
    required this.checkin,
    this.onTap,
  });

  final Member? member;
  final bool isMe;
  final MoodCheckin? checkin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final callName = member?.callName ?? '';
    final value = checkin;
    final secondary = AppTypography.adapt(context, AppTypography.small);
    final children = <Widget>[
      Row(
        children: [
          _avatar(context, callName),
          const SizedBox(width: AppSpacing.s2),
          Flexible(
            child: Text(
              isMe ? l10n.usMe(callName) : callName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      if (value != null) ...[
        Text(
          value.mood.emoji,
          style: AppTypography.body.copyWith(fontSize: 34, height: 1.2),
        ),
        Text(
          l10n.usMoodLabel(value.mood.name),
          style: AppTypography.adapt(
            context,
            AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        Text(_subtitle(context, value), style: secondary),
      ] else if (isMe) ...[
        Icon(
          LucideIcons.smilePlus,
          size: 34,
          color: AppColors.resolve(context, kColorUs5009B85D1),
        ),
        Text(
          l10n.usCheckinTitle,
          style: AppTypography.text14.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.resolve(context, kColorUs7006A549F),
          ),
        ),
      ] else ...[
        Icon(
          LucideIcons.eyeOff,
          size: 30,
          color: AppColors.resolve(context, kColorTextTertiary9C928A),
        ),
        Text(l10n.usMoodNotShared, style: secondary),
      ],
    ];
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        side: BorderSide(color: AppColors.resolve(context, kColorUs100EAE2F8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < children.length; index++) ...[
                if (index > 0) const SizedBox(height: AppSpacing.s2),
                children[index],
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle(BuildContext context, MoodCheckin value) {
    final l10n = context.l10n;
    if (value.needs.isEmpty) {
      return l10n.usEnergyValue(value.energy);
    }
    final need = l10n.usCheckinNeed(value.needs.first.name);
    final minutes = value.needMinutes;
    return minutes == null ? need : l10n.usCheckinNeedMinutes(need, minutes);
  }

  /// Avatar chữ cái 28 viền `surface` 2: Mama (slot A) `child-mint`, Papa
  /// (slot B) `child-peach` — như Pencil US-01.
  Widget _avatar(BuildContext context, String callName) {
    final color = member?.slot == ParentSlot.b
        ? kColorChildPeachFFB59E
        : kColorChildMint9EDCC4;
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.resolve(context, kColorSurfaceFFFFFF),
          width: 2,
        ),
      ),
      child: Text(
        callName.isEmpty ? '' : callName.characters.first,
        style: AppTypography.small.copyWith(
          fontFamily: AppTypography.headingFamily,
          fontWeight: FontWeight.w800,
          height: 1,
          color: kColorTextPrimary2E2A27,
        ),
      ),
    );
  }
}
