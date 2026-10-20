import 'package:baby_family/page/general/support_request/support_request_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_selectable_chip.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// Gửi yêu cầu hỗ trợ (danh mục · tiêu đề · nội dung) + yêu cầu đã gửi.
class SupportRequestMobileView extends HookConsumerWidget {
  const SupportRequestMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(supportRequestControllerProvider);
    final l10n = context.l10n;
    final secondary = AppTypography.adapt(
      context,
      AppTypography.small.copyWith(
        height: 17 / 12,
        color: kColorTextSecondary6B625B,
      ),
    );

    Future<void> send() async {
      try {
        final ticket = await controller.send();
        if (context.mounted) {
          showAppSnackBar(context, l10n.supportSent(ticket.code ?? ''));
        }
      } on Object catch (error) {
        if (context.mounted) {
          showAppSnackBar(context, actionErrorMessage(error));
        }
      }
    }

    Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else {
      const gap = SizedBox(height: AppSpacing.cardInset);
      final date = DateFormat('dd/MM/yyyy', context.localeName);
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.supportTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          gap,
          Text(l10n.supportHint, style: secondary),
          gap,
          AppCard(
            key: ValueKey(controller.formVersion),
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCapsLabel(l10n.supportCategoryLabel),
                const SizedBox(height: AppSpacing.s2),
                Wrap(
                  spacing: AppSpacing.s2,
                  runSpacing: AppSpacing.s2,
                  children: [
                    for (final category in controller.categories)
                      AppSelectableChip(
                        label: l10n.supportCategory(category),
                        selected: controller.category == category,
                        onPressed: () => controller.setCategory(category),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.itemGap),
                AppTextField(
                  label: l10n.supportSubject,
                  maxLength: SupportRequestController.subjectMax,
                  onChanged: controller.setSubject,
                ),
                const SizedBox(height: AppSpacing.itemGap),
                AppTextField(
                  label: l10n.supportBody,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  maxLength: SupportRequestController.bodyMax,
                  onChanged: controller.setBody,
                ),
                const SizedBox(height: AppSpacing.itemGap),
                AppButton(
                  label: l10n.supportSend,
                  height: 44,
                  isLoading: controller.isLoading,
                  onPressed: controller.canSend ? send : null,
                ),
              ],
            ),
          ),
          gap,
          AppCapsLabel(l10n.supportMine),
          gap,
          if (controller.tickets.isEmpty)
            Text(l10n.supportEmpty, style: secondary)
          else
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final ticket in controller.tickets)
                    ListTile(
                      title: Text(
                        ticket.code ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.text14.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        ticket.createdAt == null
                            ? l10n.supportStatus(ticket.status ?? '')
                            : '${l10n.supportStatus(ticket.status ?? '')} · '
                                  '${date.format(ticket.createdAt!.toLocal())}',
                        style: secondary,
                      ),
                    ),
                ],
              ),
            ),
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
