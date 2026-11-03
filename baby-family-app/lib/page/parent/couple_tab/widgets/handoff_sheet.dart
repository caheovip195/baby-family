part of '../mobile/couple_tab_mobile_view.dart';

/// Mở sheet bàn giao ca; gửi xong có thể mở US-03 để nhờ việc tiếp.
Future<void> _openHandoff(
  BuildContext context,
  CoupleTabController controller,
  Member? partner,
) async {
  final askRequest = await showAppBottomSheet<bool>(
    context,
    builder: (_) => _HandoffSheet(
      controller: controller,
      partnerName: partner?.callName ?? '',
    ),
  );
  if (askRequest == true && context.mounted) {
    await context.router.push(RequestComposeRoute());
  }
}

/// Bàn giao ca (7.13.8): bé nào, đã ăn / ngủ / dậy lúc, ghi chú, tuỳ chọn
/// nhờ việc tiếp. Không phải tracker y tế.
class _HandoffSheet extends StatefulWidget {
  const _HandoffSheet({required this.controller, required this.partnerName});

  final CoupleTabController controller;
  final String partnerName;

  @override
  State<_HandoffSheet> createState() => _HandoffSheetState();
}

class _HandoffSheetState extends State<_HandoffSheet> {
  late final Set<String> _childIds = {
    if (widget.controller.babies.length == 1)
      widget.controller.babies.single.id,
  };
  DateTime? _fedAt;
  DateTime? _sleptAt;
  DateTime? _wokeAt;
  String _note = '';
  bool _askRequest = false;
  bool _invalid = false;

  /// Giờ chọn hôm nay; sau giờ hiện tại thì là hôm qua (ca đêm).
  Future<DateTime?> _pickTime(DateTime? current) async {
    final now = widget.controller.now;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current ?? now),
    );
    if (picked == null) {
      return current;
    }
    final at = DateTime(
      now.year,
      now.month,
      now.day,
      picked.hour,
      picked.minute,
    );
    return at.isAfter(now) ? at.subtract(const Duration(days: 1)) : at;
  }

  Future<void> _send() async {
    final l10n = context.l10n;
    if (_fedAt == null &&
        _sleptAt == null &&
        _wokeAt == null &&
        _note.trim().isEmpty) {
      setState(() => _invalid = true);
      return;
    }
    try {
      await widget.controller.sendHandoff(
        childIds: _childIds.toList(),
        fedAt: _fedAt,
        sleptAt: _sleptAt,
        wokeAt: _wokeAt,
        note: _note,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(_askRequest);
      showAppSnackBar(context, l10n.usHandoffSent(widget.partnerName));
    } on Object catch (error) {
      if (mounted) {
        showAppSnackBar(context, actionErrorMessage(error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = l10n.localeName;
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    Widget timeField(
      String label,
      DateTime? value,
      ValueChanged<DateTime?> onChanged,
    ) => AppPickerField(
      label: label,
      value: value?.toDisplayTime(locale),
      placeholder: l10n.usHandoffPickTime,
      icon: LucideIcons.clock,
      onTap: () async {
        final picked = await _pickTime(value);
        if (mounted) {
          setState(() {
            onChanged(picked);
            _invalid = false;
          });
        }
      },
    );
    final babies = widget.controller.babies;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AppBottomSheet(
        title: l10n.usHandoffTitle(widget.partnerName),
        children: [
          Text(
            l10n.usHandoffHint(widget.partnerName),
            style: AppTypography.adapt(
              context,
              AppTypography.body.copyWith(color: secondary),
            ),
          ),
          if (babies.length > 1)
            Wrap(
              spacing: AppSpacing.s2,
              runSpacing: AppSpacing.s2,
              children: [
                for (final child in babies)
                  AppSelectableChip(
                    label: child.name,
                    selected: _childIds.contains(child.id),
                    onPressed: () => setState(() {
                      if (!_childIds.remove(child.id)) {
                        _childIds.add(child.id);
                      }
                    }),
                  ),
              ],
            ),
          timeField(l10n.usHandoffFed, _fedAt, (value) => _fedAt = value),
          timeField(l10n.usHandoffSlept, _sleptAt, (value) => _sleptAt = value),
          timeField(l10n.usHandoffWoke, _wokeAt, (value) => _wokeAt = value),
          AppTextField(
            label: l10n.usHandoffNote,
            hint: l10n.usHandoffNoteHint,
            maxLines: 3,
            maxLength: 500,
            onChanged: (value) => setState(() {
              _note = value;
              _invalid = false;
            }),
          ),
          AppToggleRow(
            title: l10n.usHandoffAttachRequest(widget.partnerName),
            value: _askRequest,
            onChanged: (value) => setState(() => _askRequest = value),
          ),
          if (_invalid)
            Text(
              l10n.usHandoffNeedContent,
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(color: kColorErrorD14B4B),
              ),
            ),
          AppButton.us(
            label: l10n.usHandoffSend,
            isLoading: widget.controller.isLoading,
            onPressed: _send,
          ),
          Text(
            l10n.usHandoffNotMedical,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(context, AppTypography.tiny),
          ),
        ],
      ),
    );
  }
}
