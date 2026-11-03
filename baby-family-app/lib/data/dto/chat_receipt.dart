/// Trạng thái dưới tin cuối đã gửi của tôi (CHAT-02): “Đã gửi” hoặc “Đã
/// xem · {tên}”. [seenBy] = tên người đã đọc tới tin đó (trừ tôi).
class ChatReceipt {
  const ChatReceipt({required this.messageId, this.seenBy = const []});

  final String messageId;
  final List<String> seenBy;

  bool get seen => seenBy.isNotEmpty;
}
