import 'package:baby_family/data/model/settings/support_ticket_detail.dart';
import 'package:baby_family/page/general/support_ticket/support_ticket_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// Một yêu cầu hỗ trợ: mã + trạng thái, nội dung đã gửi, các tin trao đổi
/// (của tôi bên phải, CSKH bên trái), ô nhắn thêm khi yêu cầu còn mở.
class SupportTicketMobileView extends HookConsumerWidget {
  const SupportTicketMobileView({required this.ticketId, super.key});

  final String ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(supportTicketControllerProvider(ticketId));
    final l10n = context.l10n;
    final ticket = controller.ticket;
    final secondary = AppTypography.adapt(
      context,
      AppTypography.small.copyWith(
        height: 17 / 12,
        color: kColorTextSecondary6B625B,
      ),
    );
    final time = DateFormat('HH:mm · dd/MM', context.localeName);

    Future<void> send() async {
      try {
        await controller.send();
      } on Object catch (error) {
        if (context.mounted) {
          showAppSnackBar(context, actionErrorMessage(error));
        }
      }
    }

    Widget bubble(SupportMessage message) {
      final mine = message.sender == kValueSupportSenderUser;
      return Align(
        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          margin: const EdgeInsets.only(bottom: AppSpacing.s2),
          padding: const EdgeInsets.all(AppSpacing.s3),
          decoration: BoxDecoration(
            color: AppColors.resolve(
              context,
              mine ? kColorPrimary50FFF4F1 : kColorSurfaceVariantF7F1EC,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!mine)
                Text(
                  l10n.supportTeam,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              Text(
                message.body,
                style: AppTypography.adapt(context, AppTypography.body),
              ),
              if (message.createdAt != null)
                Text(
                  time.format(message.createdAt!.toLocal()),
                  style: secondary,
                ),
            ],
          ),
        ),
      );
    }

    Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError || ticket == null) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else {
      const gap = SizedBox(height: AppSpacing.cardInset);
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            ticket.subject.isEmpty ? (ticket.code ?? '') : ticket.subject,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            '${ticket.code ?? ''} · ${l10n.supportStatus(ticket.status ?? '')}',
            style: secondary,
          ),
          gap,
          if (ticket.body.isNotEmpty)
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Text(
                ticket.body,
                style: AppTypography.adapt(context, AppTypography.body),
              ),
            ),
          gap,
          AppCapsLabel(l10n.supportThread),
          gap,
          if (ticket.messages.isEmpty)
            Text(l10n.supportNoReply, style: secondary)
          else
            for (final message in ticket.messages) bubble(message),
          gap,
          if (controller.closed)
            Text(l10n.supportClosedHint, style: secondary)
          else ...[
            AppTextField(
              key: ValueKey(controller.replyVersion),
              label: l10n.supportReply,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              maxLength: SupportTicketController.replyMax,
              onChanged: controller.setReply,
            ),
            const SizedBox(height: AppSpacing.itemGap),
            AppButton(
              label: l10n.supportSendReply,
              height: 44,
              isLoading: controller.isLoading,
              onPressed: controller.canSend ? send : null,
            ),
          ],
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
