/// Deep link của server (`babyfamily://…`, trong thông báo đẩy / hộp thư)
/// → đường dẫn route của app theo vai trò (BF-20261030-005). null = không có
/// màn tương ứng (mở app như bình thường). Người thân không bao giờ được đưa
/// vào màn của Bố Mẹ (Papa & Mama, gia đình).
String? routeForDeepLink(String link, {required bool circle}) {
  const scheme = 'babyfamily://';
  if (!link.startsWith(scheme)) {
    return null;
  }
  final parts = link
      .substring(scheme.length)
      .split('?')
      .first
      .split('/')
      .where((part) => part.isNotEmpty)
      .toList();
  final (head, id) = (parts.firstOrNull, parts.elementAtOrNull(1));
  // Nhắn tin (BF-20261101-001): server chỉ gửi cuộc trò chuyện người nhận
  // được xem; người thân không có `COUPLE` trong danh sách nên màn hội thoại
  // tự báo không mở được.
  if (head == 'chats') {
    return id == null ? '/chats' : '/chats/$id';
  }
  if (circle) {
    return switch (head) {
      'memories' when id != null => '/circle/memory/$id',
      'year-books' => '/circle/year-books',
      'recaps' => '/recap/week',
      _ => null,
    };
  }
  return switch (head) {
    'memories' when id != null => '/memory/$id',
    'us' => '/main/us',
    'recaps' => '/recap/week',
    'family' => '/family',
    // CAL-02 nhắc sự kiện (BF-20261030-010).
    'calendar' => '/calendar',
    // SUB-06 nhắc gia hạn / hết dùng thử: `families/{id}/billing` → SUB-03.
    'families' when parts.elementAtOrNull(2) == 'billing' => '/billing/plan',
    _ => null,
  };
}
