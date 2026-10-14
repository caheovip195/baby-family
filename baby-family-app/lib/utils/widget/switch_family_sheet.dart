import 'package:baby_family/data/model/family/family_membership.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_info_note.dart';
import 'package:baby_family/utils/widget/app_radio_mark.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// FAM-08 — “Chuyển gia đình” (Pencil `jA5Jt`): mở từ HOME-01 (giữ avatar
/// gia đình) và CIR-06 “Chuyển gia đình”. Trả về `familyId` được chọn (null
/// khi đóng sheet).
Future<String?> showSwitchFamilySheet(
  BuildContext context, {
  required List<FamilyMembership> memberships,
}) => showAppBottomSheet<String>(
  context,
  strongScrim: true,
  builder: (_) => SwitchFamilySheet(memberships: memberships),
);

/// Nội dung FAM-08: tiêu đề 22/800 + mô tả, mỗi gia đình một thẻ (avatar 48
/// bo 14, tên 16/700, nhãn vai trò, dòng mô tả, vòng chọn 22); gia đình đang
/// xem nền `primary-50` viền `primary-300`. Ghi chú `surface-variant` cuối.
class SwitchFamilySheet extends StatelessWidget {
  const SwitchFamilySheet({required this.memberships, super.key});

  final List<FamilyMembership> memberships;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final parentOf = memberships
        .where((m) => m.role != FamilyRole.relative)
        .firstOrNull;
    final relativeOf = memberships
        .where((m) => m.role == FamilyRole.relative)
        .firstOrNull;
    return AppBottomSheet(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.itemGap,
        AppSpacing.screen,
        28,
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.famSwitchTitle,
              style: AppTypography.adapt(
                context,
                AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            if (parentOf != null && relativeOf != null) ...[
              const SizedBox(height: AppSpacing.s1),
              Text(
                l10n.famSwitchSubtitle(parentOf.callName, parentOf.familyName),
                style: AppTypography.adapt(
                  context,
                  AppTypography.caption.copyWith(height: 1.4),
                ),
              ),
            ],
          ],
        ),
        for (final membership in memberships)
          _FamilyOption(
            membership: membership,
            onTap: () => Navigator.of(context).pop(membership.familyId),
          ),
        if (relativeOf != null)
          AppInfoNote(
            icon: LucideIcons.info,
            text: l10n.famSwitchNote(relativeOf.familyName),
            background: kColorSurfaceVariantF7F1EC,
            iconColor: kColorTextSecondary6B625B,
            iconSize: 16,
            lineHeight: 1.45,
            alignTop: true,
          ),
      ],
    );
  }
}

class _FamilyOption extends StatelessWidget {
  const _FamilyOption({required this.membership, required this.onTap});

  final FamilyMembership membership;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = membership.current;
    final parent = membership.role != FamilyRole.relative;
    final details = parent
        ? [
            membership.childNames.join(', '),
            ?membership.partnerName,
            if (selected) l10n.famSwitchViewing,
          ]
        : [
            l10n.famSwitchFollows(membership.childNames.join(', ')),
            ?membership.permissionSummary,
          ];
    final radius = BorderRadius.circular(AppRadius.lg);
    return Material(
      color: AppColors.resolve(
        context,
        selected ? kColorPrimary50FFF4F1 : kColorSurfaceFFFFFF,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(
          color: AppColors.resolve(
            context,
            selected ? kColorPrimary300F7A796 : kColorBorderEADFD6,
          ),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          child: Row(
            children: [
              Container(
                width: AppSpacing.s12,
                height: AppSpacing.s12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  color: parent
                      ? null
                      : AppColors.resolve(context, kColorSecondary100E4F2EA),
                  // Pencil: gradient 200° #FFE3DC → #FDF1D6 như avatar HOME.
                  gradient: parent
                      ? const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            kColorPrimary100FFE3DC,
                            kColorAccent100FDF1D6,
                          ],
                        )
                      : null,
                ),
                child: const Icon(
                  LucideIcons.house,
                  size: 22,
                  color: kColorPrimary700A2402F,
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      membership.familyName,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title16.copyWith(height: 20 / 16),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.resolve(
                          context,
                          parent
                              ? kColorSurfaceFFFFFF
                              : kColorSurfaceVariantF7F1EC,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        parent
                            ? l10n.famSwitchRoleParent(membership.callName)
                            : l10n.famSwitchRoleRelative(membership.callName),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.tiny.copyWith(
                            fontWeight: FontWeight.w600,
                            color: parent
                                ? kColorPrimary700A2402F
                                : kColorTextSecondary6B625B,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      details.where((d) => d.isNotEmpty).join(' · '),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              AppRadioMark(selected: selected, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
