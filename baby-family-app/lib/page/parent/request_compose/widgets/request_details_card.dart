part of '../mobile/request_compose_mobile_view.dart';

/// Chi tiết lời nhờ (Pencil `rsuMx`): nền `surface` bo 16 đệm 14 — Bao lâu?
/// (15/30/60 phút) • Khi nào? (Bây giờ / Tối nay / Chọn giờ) • Trông bé nào?
class _RequestDetailsCard extends StatelessWidget {
  const _RequestDetailsCard({required this.controller});

  final RequestComposeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = AppTypography.adapt(
      context,
      AppTypography.small.copyWith(fontWeight: FontWeight.w600),
    );
    Widget group(String title, Widget child) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: label),
        const SizedBox(height: AppSpacing.s2),
        child,
      ],
    );
    Widget row(List<Widget> boxes) => Row(
      children: [
        for (var index = 0; index < boxes.length; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.s2),
          Expanded(child: boxes[index]),
        ],
      ],
    );
    final pickedTime = controller.dueLabel == RequestComposeController.dueAtTime
        ? controller.dueAt?.toDisplayTime(context.localeName)
        : null;
    final defaultChild = controller.defaultChild;
    final groups = <Widget>[
      group(
        l10n.usRequestDuration,
        row([
          for (final minutes in RequestComposeController.durations)
            _RequestOptionBox(
              label: l10n.usRequestMinutes(minutes),
              selected: controller.minutes == minutes,
              onTap: () => controller.selectMinutes(minutes),
            ),
        ]),
      ),
      group(
        l10n.usRequestWhen,
        row([
          _RequestOptionBox(
            label: l10n.usRequestNow,
            selected: controller.dueLabel == RequestComposeController.dueNow,
            onTap: () => controller.selectDue(RequestComposeController.dueNow),
          ),
          _RequestOptionBox(
            label: l10n.usRequestTonight,
            selected:
                controller.dueLabel == RequestComposeController.dueTonight,
            onTap: () =>
                controller.selectDue(RequestComposeController.dueTonight),
          ),
          _RequestOptionBox(
            label: pickedTime ?? l10n.usRequestChooseTime,
            selected: pickedTime != null,
            onTap: () => _pickTime(context),
          ),
        ]),
      ),
      if (defaultChild != null)
        group(
          l10n.usRequestWhichChild,
          Wrap(
            spacing: AppSpacing.s2,
            runSpacing: AppSpacing.s2,
            children: [
              _childChip(context, defaultChild),
              if (controller.babies.length > 1)
                AppSelectableChip(
                  label: controller.babies.length == 2
                      ? l10n.usRequestOtherChild
                      : l10n.usRequestAllChildren(controller.babies.length),
                  selected: controller.childId == null,
                  filledSelection: false,
                  onPressed: () => controller.selectChild(null),
                ),
            ],
          ),
        ),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < groups.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.s3),
            groups[index],
          ],
        ],
      ),
    );
  }

  /// Chip bé có ảnh 28 (Pencil `ROckb`): chọn → nền `us-100` viền `us-500`.
  Widget _childChip(BuildContext context, Child child) => AppSelectableChip(
    label: child.name,
    selected: controller.childId == child.id,
    filledSelection: false,
    insets: const EdgeInsets.only(left: AppSpacing.s1, right: AppSpacing.s3),
    prefixGap: AppSpacing.s2,
    prefix: ChildAvatar(child: child, size: 28, borderWidth: 0),
    onPressed: () => controller.selectChild(child.id),
  );

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(controller.dueAt ?? controller.now),
    );
    if (picked == null) {
      return;
    }
    final base = controller.dueAt ?? controller.now;
    controller.selectDue(
      RequestComposeController.dueAtTime,
      at: DateTime(base.year, base.month, base.day, picked.hour, picked.minute),
    );
  }
}
