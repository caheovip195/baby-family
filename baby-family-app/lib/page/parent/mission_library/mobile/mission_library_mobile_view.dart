import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/ai/ai_result.dart';
import 'package:baby_family/page/parent/mission_library/mission_library_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/ai_consent.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_text_action.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/memory_list_skeleton.dart';
import 'package:baby_family/utils/widget/mission_template_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// CARE-04 — không có frame Pencil: dựng từ dòng mẫu của CARE-05
/// (`MissionTemplateTile`). Chạm một mẫu → quay lại CARE-03 với mẫu đó.
class MissionLibraryMobileView extends HookConsumerWidget {
  const MissionLibraryMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(missionLibraryControllerProvider);
    final templates = controller.templates;
    final l10n = context.l10n;
    Widget body;
    if (templates == null) {
      body = controller.hasError
          ? Center(child: ErrorState(onRetry: controller.load))
          : const SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.screen),
              child: MemoryListSkeleton(),
            );
    } else {
      body = ListView.separated(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s1,
          AppSpacing.screen,
          AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
        ),
        itemCount: templates.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.itemGap),
        itemBuilder: (context, index) {
          // AI 1.2: gợi ý vài việc trong chính thư viện này.
          if (index == 0) {
            return Align(
              alignment: Alignment.centerLeft,
              child: AppPillButton(
                label: l10n.careAiSuggest,
                onPressed: () => _suggest(context, controller),
                height: 34,
                fontSize: 13,
                horizontalPadding: AppSpacing.s4,
                color: kColorUs50F6F2FC,
                foreground: kColorUs7006A549F,
              ),
            );
          }
          final template = templates[index - 1];
          return MissionTemplateTile(
            icon: missionIcon(template.icon),
            title: template.title,
            meta: missionTemplateMeta(l10n, template),
            hearts: template.hearts,
            onTap: () => context.router.maybePop(template.id),
          );
        },
      );
    }
    return BaseScaffold(
      appBar: AppTopBar(title: l10n.careLibraryTitle),
      body: body,
    );
  }
}

/// Hỏi đồng ý lần đầu → 3–5 việc AI chọn kèm lý do → chạm một việc trả mẫu
/// đó về CARE-03 (như chọn từ thư viện).
Future<void> _suggest(
  BuildContext context,
  MissionLibraryController controller,
) async {
  final AiDraftRecord? draft;
  try {
    draft = await runWithAiConsent(
      context,
      action: controller.suggest,
      grant: controller.grantAiConsent,
    );
  } on Object catch (error) {
    if (context.mounted) {
      showAppSnackBar(context, actionErrorMessage(error));
    }
    return;
  }
  final picks = draft?.missions ?? const <AiMissionPick>[];
  if (picks.isEmpty || !context.mounted) {
    return;
  }
  final invocationId = draft?.invocationId;
  final chosen = await showAppBottomSheet<String>(
    context,
    builder: (sheetContext) {
      final l10n = sheetContext.l10n;
      return AppBottomSheet(
        title: l10n.careAiSuggestTitle,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.sparkles,
                size: 14,
                color: AppColors.resolve(sheetContext, kColorUs7006A549F),
              ),
              const SizedBox(width: AppSpacing.compact),
              Text(
                l10n.commonAiSuggested,
                style: AppTypography.adapt(sheetContext, AppTypography.small),
              ),
            ],
          ),
          for (final pick in picks)
            MissionTemplateTile(
              icon: LucideIcons.sparkles,
              title: pick.title,
              meta: pick.reason,
              hearts: pick.hearts,
              onTap: () => Navigator.of(sheetContext).pop(pick.templateId),
            ),
          if (invocationId != null)
            Center(
              child: AppTextAction(
                label: l10n.commonAiReport,
                color: kColorTextTertiary9C928A,
                onPressed: () async {
                  Navigator.of(sheetContext).pop();
                  try {
                    await controller.reportSuggestion(
                      invocationId,
                      [
                        for (final pick in picks)
                          '${pick.title}: ${pick.reason}',
                      ].join('\n'),
                    );
                    if (context.mounted) {
                      showAppSnackBar(context, context.l10n.commonAiReported);
                    }
                  } on Object catch (error) {
                    if (context.mounted) {
                      showAppSnackBar(context, actionErrorMessage(error));
                    }
                  }
                },
              ),
            ),
        ],
      );
    },
  );
  if (chosen != null && context.mounted) {
    await context.router.maybePop(chosen);
  }
}
