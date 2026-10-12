import 'package:baby_family/data/model/care/mission.dart';
import 'package:baby_family/data/model/care/swap_option.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/mission_template_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// CARE-05 “Đổi nhiệm vụ” (Pencil `AJPzj`): tiêu đề 20/800, mô tả 13, 3 lựa
/// chọn Hearts tương đương (chọn: nền `primary-50` viền `primary-500`), số
/// lần đổi còn lại 12 `text-tertiary`, nút “Đổi sang việc này”, “Bỏ khỏi hôm
/// nay (không bị trừ gì)”. Dùng ở CARE-01 (nhấn giữ thẻ) và CARE-02.
class MissionSwapSheet extends HookWidget {
  const MissionSwapSheet({
    super.key,
    required this.mission,
    required this.option,
    required this.onSwap,
    required this.onRemove,
  });

  final Mission mission;
  final SwapOption option;
  final Future<void> Function(String templateId) onSwap;
  final Future<void> Function() onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = useState(0);
    final options = option.options;
    final canSwap = options.isNotEmpty && option.swapsLeft > 0;
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    return AppBottomSheet(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.itemGap,
        AppSpacing.screen,
        28,
      ),
      gap: AppSpacing.cardInset,
      children: [
        Text(
          l10n.careSwapHeading(mission.title),
          style: AppTypography.adapt(context, AppTypography.title20),
        ),
        Text(
          l10n.careSwapHint,
          style: AppTypography.adapt(context, AppTypography.caption),
        ),
        for (var index = 0; index < options.length; index++)
          MissionTemplateTile(
            icon: missionIcon(options[index].icon),
            title: options[index].title,
            meta: missionTemplateMeta(l10n, options[index]),
            hearts: options[index].hearts,
            selected: index == selected.value,
            onTap: () => selected.value = index,
          ),
        Text(
          l10n.careSwapRemaining(option.swapsLeft),
          textAlign: TextAlign.center,
          style: AppTypography.adapt(context, AppTypography.small).copyWith(
            color: AppColors.resolve(context, kColorTextTertiary9C928A),
          ),
        ),
        AppButton(
          label: l10n.careSwapConfirm,
          onPressed: canSwap
              ? () async {
                  final navigator = Navigator.of(context);
                  await onSwap(options[selected.value].id);
                  navigator.pop();
                }
              : null,
        ),
        Center(
          child: TextButton.icon(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await onRemove();
              navigator.pop();
            },
            style: TextButton.styleFrom(foregroundColor: secondary),
            icon: const Icon(LucideIcons.calendarX, size: 16),
            label: Text(
              l10n.careRemoveToday,
              style: AppTypography.text14.copyWith(
                fontWeight: FontWeight.w600,
                color: secondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Mở CARE-05 (nền mờ `#2E2A2799`); sheet tự đóng sau khi đổi / bỏ.
Future<void> showMissionSwapSheet(
  BuildContext context, {
  required Mission mission,
  required SwapOption option,
  required Future<void> Function(String templateId) onSwap,
  required Future<void> Function() onRemove,
}) => showAppBottomSheet<void>(
  context,
  strongScrim: true,
  builder: (_) => MissionSwapSheet(
    mission: mission,
    option: option,
    onSwap: onSwap,
    onRemove: onRemove,
  ),
);
