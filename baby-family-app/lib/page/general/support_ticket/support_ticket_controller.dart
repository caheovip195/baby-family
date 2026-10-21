import 'package:baby_family/data/model/settings/support_ticket_detail.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/legacy.dart';

final supportTicketControllerProvider = ChangeNotifierProvider.autoDispose
    .family<SupportTicketController, String>(SupportTicketController.new);

class SupportTicketController extends BaseNotifier {
  SupportTicketController(super.ref, this.ticketId) {
    load();
  }

  final String ticketId;

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  static const replyMax = 10000;

  bool loaded = false;
  bool hasError = false;
  SupportTicketDetail? ticket;
  String reply = '';

  /// Tăng sau mỗi lần gửi để làm mới ô nhập.
  int replyVersion = 0;

  bool get closed => kValueSupportClosedStatuses.contains(ticket?.status);

  bool get canSend => !closed && reply.trim().isNotEmpty && !isLoading;

  Future<void> load() async {
    hasError = false;
    try {
      final loadedTicket = await settingsService.supportTicket(ticketId);
      if (isDisposed) {
        return;
      }
      ticket = loadedTicket;
      hasError = loadedTicket == null;
    } on Object {
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  void setReply(String value) {
    reply = value;
    notifyListeners();
  }

  Future<void> send() async {
    await whileLoading(
      () => settingsService.sendSupportMessage(ticketId, reply.trim()),
    );
    reply = '';
    replyVersion++;
    await load();
  }
}
