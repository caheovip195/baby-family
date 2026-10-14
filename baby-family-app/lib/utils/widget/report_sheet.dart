import 'package:baby_family/data/dto/report_request.dart';
import 'package:baby_family/data/model/memory/report_reason.dart';
import 'package:baby_family/data/model/memory/report_receipt.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/input_decoration.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_radio_mark.dart';
import 'package:baby_family/utils/widget/app_toggle_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Mở RPT-01 — Báo cáo (Pencil `bE4o5`, đã gửi `r46T7`) từ menu ký ức
/// (MEM-07, CIR-03), bình luận (MEM-10) hoặc thành viên (FAM-04).
///
/// [reasons]: lý do đã dịch (`IMemoryService.reportReasons`); [canRemove]:
/// người báo cáo là bố mẹ → thêm “Gỡ khỏi gia đình” / “Gỡ người thân”;
/// [onSubmit] gửi báo cáo và trả mã (RPT-01b); [onTrack] mở “Báo cáo của tôi”.
/// Trả về biên nhận khi đã gửi.
Future<ReportReceipt?> showReportSheet(
  BuildContext context, {
  required ReportTarget target,
  required List<ReportReason> reasons,
  required Future<ReportReceipt?> Function(ReportRequest request) onSubmit,
  String targetName = '',
  bool canRemove = false,
  VoidCallback? onTrack,
}) => showAppBottomSheet<ReportReceipt>(
  context,
  strongScrim: true,
  builder: (_) => ReportSheet(
    target: target,
    targetName: targetName,
    reasons: reasons,
    canRemove: canRemove,
    onSubmit: onSubmit,
    onTrack: onTrack,
  ),
);

/// Nội dung RPT-01: lý do (radio, lý do ưu tiên kèm gợi ý 24 giờ) → mô tả →
/// “Ẩn … với tôi ngay” → (bố mẹ) “Gỡ …” → Gửi; sau khi gửi đổi sang RPT-01b
/// (mã báo cáo, trạng thái, “Theo dõi trong Cài đặt”).
class ReportSheet extends HookWidget {
  const ReportSheet({
    required this.target,
    required this.reasons,
    required this.onSubmit,
    this.targetName = '',
    this.canRemove = false,
    this.onTrack,
    super.key,
  });

  final ReportTarget target;
  final String targetName;
  final List<ReportReason> reasons;
  final bool canRemove;
  final Future<ReportReceipt?> Function(ReportRequest request) onSubmit;
  final VoidCallback? onTrack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = useState<String?>(null);
    final hide = useState(true);
    final remove = useState(false);
    final sending = useState(false);
    final receipt = useState<ReportReceipt?>(null);
    final note = useTextEditingController();

    final sent = receipt.value;
    if (sent != null) {
      return _ReportSent(
        receipt: sent,
        hidden: hide.value || _isPriority(selected.value),
        onTrack: onTrack == null
            ? null
            : () {
                Navigator.of(context).pop(sent);
                onTrack!();
              },
        onDone: () => Navigator.of(context).pop(sent),
      );
    }

    Future<void> submit() async {
      final code = selected.value;
      if (code == null) {
        return;
      }
      sending.value = true;
      final result = await onSubmit(
        ReportRequest(
          reasonCode: code,
          note: note.text.trim().isEmpty ? null : note.text.trim(),
          hideForMe: hide.value,
          removeFromFamily: canRemove && remove.value,
        ),
      );
      if (!context.mounted) {
        return;
      }
      sending.value = false;
      receipt.value = result;
    }

    final title = switch (target) {
      ReportTarget.memory => l10n.rptTitleMemory,
      ReportTarget.comment => l10n.rptTitleComment,
      ReportTarget.member => l10n.rptTitlePerson(targetName),
    };
    final hideLabel = switch (target) {
      ReportTarget.memory => l10n.rptHideMemory,
      ReportTarget.comment => l10n.rptHideComment,
      ReportTarget.member => l10n.rptHidePerson,
    };
    final secondary = AppTypography.adapt(
      context,
      AppTypography.caption.copyWith(color: kColorTextSecondary6B625B),
    );
    final toggleTitle = AppTypography.adapt(
      context,
      AppTypography.text14.copyWith(fontWeight: FontWeight.w500),
    );
    return AppBottomSheet(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.itemGap,
        AppSpacing.screen,
        28,
      ),
      gap: AppSpacing.s3,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.adapt(context, AppTypography.title20),
            ),
            const SizedBox(height: AppSpacing.s1),
            Text(l10n.rptSubtitle, style: secondary.copyWith(height: 19 / 13)),
          ],
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.resolve(context, kColorBorderEADFD6),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Column(
              children: [
                for (final (index, reason) in reasons.indexed)
                  _ReasonRow(
                    reason: reason,
                    selected: reason.code == selected.value,
                    divider: index < reasons.length - 1,
                    onTap: () => selected.value = reason.code,
                  ),
              ],
            ),
          ),
        ),
        Container(
          constraints: const BoxConstraints(minHeight: 46),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardInset),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
            borderRadius: BorderRadius.circular(AppRadius.tile),
          ),
          child: TextField(
            controller: note,
            minLines: 1,
            maxLines: 3,
            style: AppTypography.adapt(context, AppTypography.text14),
            decoration: bareInputDecoration(
              hint: l10n.rptNoteHint,
              hintStyle: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(color: kColorTextTertiary9C928A),
              ),
            ),
          ),
        ),
        AppToggleRow(
          title: hideLabel,
          titleStyle: toggleTitle,
          value: hide.value,
          onChanged: (value) => hide.value = value,
        ),
        if (canRemove)
          AppToggleRow(
            title: target == ReportTarget.member
                ? l10n.rptRemovePerson
                : l10n.rptRemoveContent,
            subtitle: target == ReportTarget.member
                ? l10n.rptRemovePersonHint(targetName)
                : l10n.rptRemoveContentHint,
            titleStyle: toggleTitle,
            value: remove.value,
            onChanged: (value) => remove.value = value,
          ),
        AppButton(
          label: l10n.rptSend,
          isLoading: sending.value,
          onPressed: selected.value == null ? null : submit,
        ),
      ],
    );
  }

  bool _isPriority(String? code) =>
      reasons.any((reason) => reason.code == code && reason.priority);
}

/// Một lý do: radio 20 + chữ 14; đang chọn → nền `primary-50`, chữ 700
/// `primary-700`; lý do ưu tiên kèm icon `shield-alert` và hai dòng gợi ý.
class _ReasonRow extends StatelessWidget {
  const _ReasonRow({
    required this.reason,
    required this.selected,
    required this.divider,
    required this.onTap,
  });

  final ReportReason reason;
  final bool selected;
  final bool divider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strong = AppColors.resolve(context, kColorPrimary700A2402F);
    final hint = reason.hint;
    final note = reason.note;
    return Material(
      color: selected
          ? AppColors.resolve(context, kColorPrimary50FFF4F1)
          : kColorTransparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardInset,
            vertical: AppSpacing.itemGap,
          ),
          decoration: divider
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.resolve(context, kColorBorderEADFD6),
                    ),
                  ),
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppRadioMark(selected: selected, size: 20),
                  const SizedBox(width: AppSpacing.itemGap),
                  if (reason.priority) ...[
                    Icon(
                      LucideIcons.shieldAlert,
                      size: 16,
                      color: selected
                          ? strong
                          : AppColors.resolve(
                              context,
                              kColorTextSecondary6B625B,
                            ),
                    ),
                    const SizedBox(width: AppSpacing.itemGap),
                  ],
                  Expanded(
                    child: Text(
                      reason.title,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: selected ? strong : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (selected && reason.priority && (hint != null || note != null))
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.compact,
                    left: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hint != null)
                        Text(
                          hint,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small.copyWith(
                              fontWeight: FontWeight.w700,
                              color: strong,
                            ),
                          ),
                        ),
                      if (note != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          note,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small.copyWith(
                              height: 17 / 12,
                              color: kColorTextSecondary6B625B,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// RPT-01b (Pencil `r46T7`): vòng 64 `shield-check`, “Đã gửi báo cáo”, lời
/// cảm ơn, ô mã báo cáo + trạng thái, liên kết “Báo cáo của tôi”, “Xong”.
class _ReportSent extends StatelessWidget {
  const _ReportSent({
    required this.receipt,
    required this.hidden,
    required this.onDone,
    this.onTrack,
  });

  final ReportReceipt receipt;
  final bool hidden;
  final VoidCallback onDone;
  final VoidCallback? onTrack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reviewing = receipt.status == ReportStatus.reviewing;
    return AppBottomSheet(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.itemGap,
        AppSpacing.screen,
        28,
      ),
      gap: AppSpacing.cardInset,
      children: [
        Center(
          child: Container(
            width: 64,
            height: 64,
            margin: const EdgeInsets.only(top: AppSpacing.s2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSecondary100E4F2EA),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.shieldCheck,
              size: 30,
              color: AppColors.resolve(context, kColorSecondary7003F7A5C),
            ),
          ),
        ),
        Text(
          l10n.rptSentTitle,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        Text(
          hidden ? l10n.rptSentBodyHidden : l10n.rptSentBody,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.text14.copyWith(
              height: 21 / 14,
              color: kColorTextSecondary6B625B,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardInset,
            vertical: AppSpacing.s3,
          ),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.rptCodeLabel,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          color: kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      receipt.code,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title17,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.itemGap,
                  vertical: AppSpacing.s1,
                ),
                decoration: BoxDecoration(
                  color: AppColors.resolve(
                    context,
                    reviewing
                        ? kColorAccent100FDF1D6
                        : kColorSecondary100E4F2EA,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  reviewing ? l10n.rptStatusReviewing : l10n.rptStatusResolved,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.resolve(
                        context,
                        reviewing
                            ? kColorAccent7009A6A12
                            : kColorSecondary7003F7A5C,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onTrack,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardInset,
              vertical: AppSpacing.s1,
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.listChecks,
                  size: 18,
                  color: AppColors.resolve(context, kColorTextSecondary6B625B),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Text(
                    l10n.rptTrack,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        color: kColorTextSecondary6B625B,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: AppColors.resolve(context, kColorTextTertiary9C928A),
                ),
              ],
            ),
          ),
        ),
        AppButton(label: l10n.rptDone, onPressed: onDone),
      ],
    );
  }
}
