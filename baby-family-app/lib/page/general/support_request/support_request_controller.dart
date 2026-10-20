import 'package:baby_family/data/model/settings/support_ticket.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:hooks_riverpod/legacy.dart';

/// Gửi yêu cầu hỗ trợ: chọn danh mục (catalog từ server), tiêu đề, nội dung.
/// Hoạt động cả khi gói hết hạn; chỉ gửi những gì người dùng tự nhập.
final supportRequestControllerProvider =
    ChangeNotifierProvider.autoDispose<SupportRequestController>(
      SupportRequestController.new,
    );

class SupportRequestController extends BaseNotifier {
  SupportRequestController(super.ref) {
    load();
  }

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  static const subjectMax = 200;
  static const bodyMax = 10000;

  bool loaded = false;
  bool hasError = false;
  List<String> categories = const [];
  List<SupportTicket> tickets = const [];
  String? category;
  String subject = '';
  String body = '';

  /// Tăng sau mỗi lần gửi để làm mới ô nhập.
  int formVersion = 0;

  bool get canSend =>
      category != null &&
      subject.trim().isNotEmpty &&
      body.trim().isNotEmpty &&
      !isLoading;

  Future<void> load() async {
    hasError = false;
    try {
      final loadedCategories = await settingsService.supportCategories();
      final loadedTickets = await settingsService.supportTickets();
      if (isDisposed) {
        return;
      }
      categories = loadedCategories;
      tickets = loadedTickets;
    } on Object {
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  void setCategory(String value) {
    category = value;
    notifyListeners();
  }

  void setSubject(String value) {
    subject = value;
    notifyListeners();
  }

  void setBody(String value) {
    body = value;
    notifyListeners();
  }

  /// Gửi và trả yêu cầu vừa tạo; ô nhập được xoá, danh sách tải lại.
  Future<SupportTicket> send() async {
    final ticket = await whileLoading(
      () => settingsService.sendSupportRequest(
        category: category!,
        subject: subject.trim(),
        body: body.trim(),
      ),
    );
    subject = '';
    body = '';
    category = null;
    formVersion++;
    final loadedTickets = await settingsService.supportTickets();
    if (!isDisposed) {
      tickets = loadedTickets;
      notifyListeners();
    }
    return ticket;
  }
}
