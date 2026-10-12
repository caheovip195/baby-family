/// Hiển thị mã mời 8 ký tự theo nhóm 4: `K7Q29MXA` → `K7Q2 · 9MXA`
/// (ONB-07, ONB-WAIT).
String formatInviteCode(String code) {
  final clean = code.trim().toUpperCase();
  if (clean.length <= 4) {
    return clean;
  }
  return '${clean.substring(0, 4)} · ${clean.substring(4)}';
}
