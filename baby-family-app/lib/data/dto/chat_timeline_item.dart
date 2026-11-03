import 'package:baby_family/data/model/chat/chat_message.dart';

/// Một dòng của CHAT-02: ngăn cách ngày ([day]) hoặc một tin ([message]).
/// [showSender] = tin đầu của một chuỗi tin liền nhau của cùng người (hiện
/// tên + avatar với tin người khác).
class ChatTimelineItem {
  const ChatTimelineItem.day(DateTime this.day)
    : message = null,
      showSender = false;

  const ChatTimelineItem.message(
    ChatMessage this.message, {
    this.showSender = false,
  }) : day = null;

  final DateTime? day;
  final ChatMessage? message;
  final bool showSender;
}
