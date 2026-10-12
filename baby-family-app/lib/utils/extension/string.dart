/// Tiện ích chuỗi dùng chung.
extension StringExt on String {
  /// Câu đầu tiên (gồm dấu kết câu `.`, `!`, `?`, `…`) — MEM-24 tóm tắt ký ức
  /// gốc, MEM-01 trích “Papa kể”. Không có dấu kết câu → cả chuỗi.
  String get firstSentence {
    final text = trim();
    final match = RegExp(r'^.*?[.!?…](?=\s|$)', dotAll: true).firstMatch(text);
    return match?.group(0) ?? text;
  }

  /// Câu đầu tiên kết thúc bằng “…” (trích dẫn ngắn: “Anh đứng sau cầm máy
  /// mà run tay…”).
  String get firstSentenceExcerpt {
    final sentence = firstSentence;
    if (sentence.length >= trim().length) {
      return sentence;
    }
    final body = sentence.endsWith('.')
        ? sentence.substring(0, sentence.length - 1)
        : sentence;
    return body.endsWith('…') ? body : '$body…';
  }
}
