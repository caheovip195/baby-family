part of '../mobile/couple_tab_mobile_view.dart';

/// US-02 — Check-in cảm xúc (Pencil `w3t2ak`): 10 cảm xúc (2 hàng × 5) →
/// năng lượng 5 vạch → “Mình cần…” → Chia sẻ với {bạn đời}/Chỉ mình tôi →
/// “Gửi cho {bạn đời}”. Điền sẵn như Pencil (Mệt, năng lượng 2, Yên tĩnh).
class _CheckinSheet extends HookWidget {
  const _CheckinSheet({required this.partnerName, required this.onSave});

  final String partnerName;
  final Future<bool> Function({
    required MoodCode mood,
    required int energy,
    required List<CoupleNeed> needs,
    required bool shared,
  })
  onSave;

  static const _energyLevels = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mood = useState(MoodCode.tired);
    final energy = useState(2);
    final needs = useState(const <CoupleNeed>{CoupleNeed.quiet});
    final shared = useState(true);
    final saving = useState(false);
    final label = AppTypography.adapt(
      context,
      AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
    );

    Widget moodRow(Iterable<MoodCode> moods) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, code) in moods.indexed) ...[
          if (index > 0) const SizedBox(width: AppSpacing.compact),
          Expanded(
            child: _CheckinMoodTile(
              mood: code,
              selected: mood.value == code,
              onTap: () => mood.value = code,
            ),
          ),
        ],
      ],
    );

    String needLabel(CoupleNeed need) => switch (need) {
      CoupleNeed.rest => l10n.usNeedRest,
      CoupleNeed.childcare => l10n.usNeedChildcare,
      CoupleNeed.quiet => l10n.usNeedQuiet,
      CoupleNeed.hug => l10n.usNeedHug,
      CoupleNeed.talk => l10n.usNeedConversation,
      CoupleNeed.encouragement => l10n.usNeedEncouragement,
    };

    Future<void> save() async {
      saving.value = true;
      final ok = await onSave(
        mood: mood.value,
        energy: energy.value,
        needs: needs.value.toList(),
        shared: shared.value,
      );
      if (context.mounted) {
        Navigator.of(context).pop(ok);
      }
    }

    final half = MoodCode.values.length ~/ 2;
    return AppBottomSheet(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.itemGap,
        AppSpacing.screen,
        AppSpacing.s8,
      ),
      children: [
        Text(
          l10n.usCheckinTitle,
          style: AppTypography.adapt(context, AppTypography.title20),
        ),
        moodRow(MoodCode.values.take(half)),
        moodRow(MoodCode.values.skip(half)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.usEnergyShort, style: label),
            const SizedBox(height: AppSpacing.s2),
            _CheckinEnergyBar(
              value: energy.value,
              max: _energyLevels,
              onChanged: (value) => energy.value = value,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.usNeedShort, style: label),
            const SizedBox(height: AppSpacing.s2),
            Wrap(
              spacing: AppSpacing.s2,
              runSpacing: AppSpacing.s2,
              children: [
                for (final need in CoupleNeed.values)
                  AppSelectableChip(
                    label: needLabel(need),
                    selected: needs.value.contains(need),
                    onPressed: () {
                      final next = {...needs.value};
                      if (!next.remove(need)) {
                        next.add(need);
                      }
                      needs.value = next;
                    },
                  ),
              ],
            ),
          ],
        ),
        _CheckinShareToggle(
          shared: shared.value,
          sharedLabel: l10n.usShareWith(partnerName),
          privateLabel: l10n.usOnlyMe,
          onChanged: (value) => shared.value = value,
        ),
        AppButton.us(
          label: shared.value ? l10n.usSendTo(partnerName) : l10n.commonSave,
          isLoading: saving.value,
          onPressed: save,
        ),
      ],
    );
  }
}
