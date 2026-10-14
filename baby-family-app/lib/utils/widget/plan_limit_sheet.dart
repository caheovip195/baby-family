import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// SUB-05 — sheet “Đạt giới hạn” (Pencil `aISrA`, video dài): mở từ MEM-05
/// khi chọn video dài hơn giới hạn của gói. Trả về [PlanLimitChoice] (null khi
/// vuốt đóng).
///
/// [isTopPlan]: đang ở gói cao nhất (Family) → dòng chú thích “không cần nâng
/// cấp thêm”; ngược lại là link “Nâng cấp lên Family” ([PlanLimitChoice.upgrade]).
Future<PlanLimitChoice?> showPlanLimitSheet(
  BuildContext context, {
  required String title,
  required String message,
  required String primaryLabel,
  required String secondaryLabel,
  required bool isTopPlan,
  IconData icon = LucideIcons.film,
  String? textActionLabel,
  IconData textActionIcon = LucideIcons.notebookPen,
}) => showAppBottomSheet<PlanLimitChoice>(
  context,
  strongScrim: true,
  builder: (_) => PlanLimitSheet(
    title: title,
    message: message,
    primaryLabel: primaryLabel,
    secondaryLabel: secondaryLabel,
    isTopPlan: isTopPlan,
    icon: icon,
    textActionLabel: textActionLabel,
    textActionIcon: textActionIcon,
  ),
);

/// Nội dung SUB-05: icon tròn 64 nền `accent-100`, tiêu đề 22/800 + mô tả
/// 14 căn giữa, ô “an toàn” nền `secondary-100`, nút chính/phụ, link chữ
/// có icon và chú thích gói 11 `text-tertiary`.
class PlanLimitSheet extends StatelessWidget {
  const PlanLimitSheet({
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.isTopPlan,
    this.icon = LucideIcons.film,
    this.textActionLabel,
    this.textActionIcon = LucideIcons.notebookPen,
    super.key,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final String secondaryLabel;
  final bool isTopPlan;
  final IconData icon;
  final String? textActionLabel;
  final IconData textActionIcon;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void choose(PlanLimitChoice choice) => Navigator.of(context).pop(choice);
    return AppBottomSheet(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.itemGap,
        AppSpacing.screen,
        28,
      ),
      children: [
        Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorAccent100FDF1D6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: AppColors.resolve(context, kColorTextPrimary2E2A27),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: AppSpacing.compact),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(
                  height: 1.45,
                  color: kColorTextSecondary6B625B,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.s3),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSecondary100E4F2EA),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.shieldCheck,
                size: 18,
                color: AppColors.resolve(context, kColorSecondary7003F7A5C),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Text(
                  l10n.subLimitSafe,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: kColorSecondary7003F7A5C,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton(
              label: primaryLabel,
              onPressed: () => choose(PlanLimitChoice.primary),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            AppButton.secondary(
              label: secondaryLabel,
              onPressed: () => choose(PlanLimitChoice.secondary),
            ),
            if (textActionLabel != null) ...[
              const SizedBox(height: AppSpacing.itemGap),
              Center(
                child: AppPillButton(
                  label: textActionLabel!,
                  icon: textActionIcon,
                  height: 30,
                  fontSize: 14,
                  color: kColorTransparent,
                  foreground: kColorPrimary600C2513F,
                  onPressed: () => choose(PlanLimitChoice.saveAsText),
                ),
              ),
            ],
          ],
        ),
        if (isTopPlan)
          Text(
            l10n.subLimitTopPlan,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(context, AppTypography.tiny),
          )
        else
          Center(
            child: AppPillButton(
              label: l10n.subLimitUpgrade,
              icon: LucideIcons.crown,
              height: 30,
              color: kColorTransparent,
              foreground: kColorPrimary600C2513F,
              onPressed: () => choose(PlanLimitChoice.upgrade),
            ),
          ),
      ],
    );
  }
}
