import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/page/parent/request_compose/request_compose_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_selectable_chip.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/request_details_card.dart';
part '../widgets/request_message_card.dart';
part '../widgets/request_option_box.dart';
part '../widgets/request_task_card.dart';

/// US-03 — Gửi lời nhờ (Pencil `HGWaE`).
class RequestComposeMobileView extends HookConsumerWidget {
  const RequestComposeMobileView({this.title, super.key});

  /// Điền sẵn “Tự gõ” (mở từ màn khác với một việc cụ thể).
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(requestComposeControllerProvider);
    final l10n = context.l10n;
    useEffect(() {
      final value = title?.trim();
      if (value != null && value.isNotEmpty) {
        Future.microtask(() => controller.prefill(value));
      }
      return null;
    }, [title]);

    final partnerName = controller.partner?.callName ?? '';
    final childName = _childName(controller);
    final accent = AppColors.resolve(context, kColorUs7006A549F);
    final sectionStyle = AppTypography.small.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
      color: accent,
    );
    final message = _message(context, controller, childName);

    final tasks = [
      (
        RequestComposeController.templateRest,
        LucideIcons.coffee,
        l10n.usRequestRest,
        l10n.usRequestRestHint,
      ),
      (
        RequestComposeController.templateChildcare,
        LucideIcons.baby,
        l10n.usRequestWatchChild,
        l10n.usRequestWatchHint,
      ),
      (
        null,
        LucideIcons.library,
        l10n.usRequestLibrary,
        l10n.usRequestLibraryHint,
      ),
      (
        RequestComposeController.templateCustom,
        LucideIcons.pencil,
        l10n.usRequestCustom,
        l10n.usRequestCustomHint,
      ),
    ];
    final needs = [
      (CoupleNeed.quiet, l10n.usNeedQuiet),
      (CoupleNeed.hug, l10n.usNeedHug),
      (CoupleNeed.talk, l10n.usNeedConversation),
      (CoupleNeed.encouragement, l10n.usNeedEncouragement),
    ];

    final content = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.usRequestTo(partnerName),
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            l10n.usRequestGentle(partnerName),
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
      Text(l10n.usRequestOneThing, style: sectionStyle),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, task) in tasks.indexed) ...[
              if (index > 0) const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: _RequestTaskCard(
                  icon: task.$2,
                  title: task.$3,
                  description: task.$4,
                  selected: task.$1 != null && controller.template == task.$1,
                  onTap: task.$1 == null
                      ? () => showComingSoonSnackBar(context)
                      : () => controller.selectTemplate(task.$1!),
                ),
              ),
            ],
          ],
        ),
      ),
      if (controller.isTask) _RequestDetailsCard(controller: controller),
      _RequestMessageCard(
        message: message,
        hint: l10n.usRequestMessage,
        onChanged: controller.editMessage,
      ),
      Text(l10n.usRequestNeeds, style: sectionStyle),
      Wrap(
        spacing: AppSpacing.compact,
        runSpacing: AppSpacing.s2,
        children: [
          for (final (need, label) in needs)
            AppSelectableChip(
              label: label,
              selected: controller.need == need,
              outlined: true,
              height: 34,
              fontSize: 12,
              padding: AppSpacing.itemGap,
              textColor: controller.need == need ? null : kColorUs7006A549F,
              onPressed: () => controller.selectNeed(need),
            ),
        ],
      ),
    ];

    return BaseScaffold(
      backgroundColor: kColorUs50F6F2FC,
      appBar: const AppTopBar(backgroundColor: kColorUs50F6F2FC),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.cardInset,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < content.length; index++) ...[
                    if (index > 0) const SizedBox(height: AppSpacing.cardInset),
                    content[index],
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: AppSpacing.s6),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: AppButton.us(
                label: l10n.usRequestSendCount(
                  partnerName,
                  controller.openCount,
                ),
                isLoading: controller.isLoading,
                onPressed: controller.loaded
                    ? () => _send(context, controller, message, childName)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tên bé trong câu mẫu: bé đang chọn hoặc “Hana & Haru” khi chọn tất cả.
  String _childName(RequestComposeController controller) =>
      controller.selectedChild?.name ??
      controller.babies.map((child) => child.name).join(' & ');

  String _message(
    BuildContext context,
    RequestComposeController controller,
    String childName,
  ) {
    final custom = controller.customMessage;
    if (custom != null) {
      return custom;
    }
    final l10n = context.l10n;
    return switch (controller.template) {
      RequestComposeController.templateRest => l10n.usRequestRestMessage(
        controller.minutes,
        childName,
      ),
      RequestComposeController.templateChildcare => l10n.usRequestWatchMessage(
        controller.minutes,
        childName,
      ),
      _ => '',
    };
  }

  String _title(
    BuildContext context,
    RequestComposeController controller,
    String message,
    String childName,
  ) {
    final l10n = context.l10n;
    return switch ((controller.need, controller.template)) {
      (CoupleNeed.quiet, _) => l10n.usNeedQuiet,
      (CoupleNeed.hug, _) => l10n.usNeedHug,
      (CoupleNeed.talk, _) => l10n.usNeedConversation,
      (CoupleNeed.encouragement, _) => l10n.usNeedEncouragement,
      (CoupleNeed.rest, _) => l10n.usNeedRest,
      (CoupleNeed.childcare, _) => l10n.usNeedChildcare,
      (null, RequestComposeController.templateRest) => l10n.usRequestRestTitle(
        controller.minutes,
        childName,
      ),
      (null, RequestComposeController.templateChildcare) =>
        l10n.usRequestWatchTitle(controller.minutes, childName),
      _ => message.trim().isEmpty ? l10n.usRequestCustomHint : message.trim(),
    };
  }

  Future<void> _send(
    BuildContext context,
    RequestComposeController controller,
    String message,
    String childName,
  ) async {
    final request = await controller.send(
      title: _title(context, controller, message, childName),
      message: message.trim().isEmpty ? null : message.trim(),
    );
    if (!context.mounted) {
      return;
    }
    if (request == null) {
      showAppSnackBar(context, context.l10n.errorGeneric);
      return;
    }
    await context.router.replace(RequestDetailRoute(requestId: request.id));
  }
}
