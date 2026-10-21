import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/support_ticket/mobile/support_ticket_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-11 — một yêu cầu hỗ trợ: nội dung đã gửi, trao đổi với CSKH, nhắn thêm.
@RoutePage()
class SupportTicketPage extends BaseHookWidget {
  const SupportTicketPage({@QueryParam('ticketId') this.ticketId, super.key});

  final String? ticketId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return SupportTicketMobileView(ticketId: ticketId ?? '');
  }
}
