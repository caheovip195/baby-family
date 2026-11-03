part of '../mobile/growth_mobile_view.dart';

/// Thêm / sửa lần đo: ngày (từ ngày sinh tới hôm nay), cân nặng kg, chiều cao
/// cm, ghi chú; sửa thì có “Xoá”.
class _GrowthEntrySheet extends StatefulWidget {
  const _GrowthEntrySheet({required this.controller, this.entry});

  final GrowthController controller;
  final GrowthEntry? entry;

  @override
  State<_GrowthEntrySheet> createState() => _GrowthEntrySheetState();
}

class _GrowthEntrySheetState extends State<_GrowthEntrySheet> {
  late DateTime _day;
  late final TextEditingController _weight;
  late final TextEditingController _height;
  late final TextEditingController _note;
  bool _invalid = false;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    final locale = currentL10n().localeName;
    String? show(double? value) =>
        value == null ? null : _GrowthChart.number(value, locale);
    _day = entry?.date ?? widget.controller.today;
    _weight = TextEditingController(
      text: show(
        entry == null
            ? null
            : GrowthController.valueOf(entry, GrowthMetric.weight),
      ),
    );
    _height = TextEditingController(
      text: show(
        entry == null
            ? null
            : GrowthController.valueOf(entry, GrowthMetric.height),
      ),
    );
    _note = TextEditingController(text: entry?.note);
  }

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final controller = widget.controller;
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: controller.firstDay,
      lastDate: controller.today,
    );
    if (picked != null && mounted) {
      setState(() => _day = picked);
    }
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    try {
      final saved = await widget.controller.save(
        day: _day,
        weightKg: _weight.text,
        heightCm: _height.text,
        note: _note.text,
      );
      if (!mounted) {
        return;
      }
      if (!saved) {
        setState(() => _invalid = true);
        return;
      }
      Navigator.of(context).pop();
      showAppSnackBar(context, l10n.growthSaved);
    } on Object catch (error) {
      if (mounted) {
        showAppSnackBar(context, actionErrorMessage(error));
      }
    }
  }

  Future<void> _remove() async {
    try {
      await widget.controller.remove(_day);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on Object catch (error) {
      if (mounted) {
        showAppSnackBar(context, actionErrorMessage(error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final decimal = [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))];
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AppBottomSheet(
        title: widget.entry == null ? l10n.growthAdd : l10n.growthEdit,
        children: [
          AppPickerField(
            label: l10n.growthDate,
            value: _day.toFormDate(l10n.localeName),
            icon: LucideIcons.calendar,
            // Sửa: giữ ngày (mỗi ngày một lần đo).
            onTap: widget.entry == null ? _pickDay : () {},
          ),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: l10n.growthWeightLabel,
                  controller: _weight,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: decimal,
                  onChanged: (_) => setState(() => _invalid = false),
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: AppTextField(
                  label: l10n.growthHeightLabel,
                  controller: _height,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: decimal,
                  onChanged: (_) => setState(() => _invalid = false),
                ),
              ),
            ],
          ),
          AppTextField(
            label: l10n.growthNote,
            controller: _note,
            maxLength: 200,
          ),
          if (_invalid)
            Text(
              l10n.growthNeedValue,
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(color: kColorErrorD14B4B),
              ),
            ),
          AppButton(
            label: l10n.commonSave,
            isLoading: widget.controller.isLoading,
            onPressed: _save,
          ),
          if (widget.entry != null)
            Center(
              child: AppTextAction(
                label: l10n.commonDelete,
                color: kColorErrorD14B4B,
                onPressed: _remove,
              ),
            ),
        ],
      ),
    );
  }
}
