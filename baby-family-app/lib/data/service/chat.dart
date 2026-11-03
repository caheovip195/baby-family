import 'package:baby_family/data/model/chat/chat_conversation.dart';
import 'package:baby_family/data/model/chat/chat_message.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Nhắn tin gia đình (CHAT-01…04, BF-20261101-001), offline-first: cuộc trò
/// chuyện và tin nhắn lưu trên máy, hiện ngay; tin gửi đi lưu trước rồi gửi
/// qua outbox (Idempotency-Key = `clientKey`); realtime chỉ báo có thay đổi,
/// nội dung đọc qua REST theo `seq`.
abstract class IChatService extends IBaseService {
  /// Có gia đình server + đang chạy với server (bản mock không có chat).
  bool get available;

  /// Phát id cuộc trò chuyện vừa đổi (tin, đã xem, đang nhập); `''` = danh
  /// sách cuộc trò chuyện đổi.
  Stream<String> get changes;

  /// userId của tôi (từ `ready` hoặc tin của tôi); null khi chưa biết.
  String? get myUserId;

  RealtimeStatus get status;

  Stream<RealtimeStatus> get statusChanges;

  /// Bản trên máy, mới nhất trước; người thân không bao giờ có `COUPLE`.
  List<ChatConversation> get conversations;

  ChatConversation? conversation(String id);

  /// Tin trên máy tăng dần theo thời gian, gồm tin của tôi đang chờ gửi.
  List<ChatMessage> messages(String conversationId);

  /// Còn tin cũ hơn trên server.
  bool hasOlder(String conversationId);

  /// userId đang nhập (trong [kValueChatTypingVisible]).
  List<String> typingUsers(String conversationId);

  /// Số tin của tôi đang chờ gửi trong cuộc trò chuyện.
  int pendingCount(String conversationId);

  /// Phiên đổi: [active] = đã vào app chính với gia đình server; [parent] =
  /// Bố/Mẹ (được thấy `COUPLE`). Đổi gia đình / đăng xuất → bỏ trạng thái cũ.
  Future<void> attach({required bool active, required bool parent});

  /// App vào nền: ngắt realtime để server gửi push.
  void pause();

  /// App lên lại / có mạng lại: kết nối lại, đồng bộ, gửi tin chờ.
  Future<void> resume();

  Future<List<ChatConversation>> refreshConversations();

  /// Màn hội thoại đang mở: (kết nối lại) thì đồng bộ cuộc trò chuyện này.
  void open(String conversationId);

  void close(String conversationId);

  /// Lấy tin mới hơn tin cuối trên máy (`afterSeq`).
  Future<void> refresh(String conversationId);

  /// Tải trang tin cũ hơn (`beforeSeq`); false khi không còn.
  Future<bool> loadOlder(String conversationId);

  Future<void> send(String conversationId, String body);

  /// Gửi lại tin chưa gửi được ([clientKey]).
  Future<void> retry(String clientKey);

  /// Tôi đang nhập (gửi tín hiệu, có giới hạn tần suất).
  void typing(String conversationId);

  /// Đánh dấu đã đọc tới tin mới nhất (gộp các lần gọi liền nhau).
  void markRead(String conversationId);

  /// Có mạng lại: gửi các tin chờ.
  Future<void> syncPending();
}
