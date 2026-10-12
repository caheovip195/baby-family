import 'dart:ui';

// Design tokens màu — tài liệu nghiệp vụ mục 10.2.
// Đặt tên theo quy ước `kColor<Vai trò><HEX>` giống base hanoicheck.
// Không thêm màu ngoài bảng này nếu chưa cập nhật Design System.

// --- Cơ bản ---
const kColorTransparent = Color(0x00000000);
const kColorBlack = Color(0xFF000000);
const kColorWhite = Color(0xFFFFFFFF);

// --- Thương hiệu: San hô ấm (primary) ---
const kColorPrimary50FFF4F1 = Color(0xFFFFF4F1);
const kColorPrimary100FFE3DC = Color(0xFFFFE3DC);
const kColorPrimary300F7A796 = Color(0xFFF7A796);
const kColorPrimary500EE7B67 = Color(0xFFEE7B67);

/// Nền nút chính (chữ trắng đạt AA).
const kColorPrimary600C2513F = Color(0xFFC2513F);
const kColorPrimary700A2402F = Color(0xFFA2402F);

// --- Xanh lá mạ (secondary — chăm con, hoàn thành) ---
const kColorSecondary100E4F2EA = Color(0xFFE4F2EA);
const kColorSecondary5006FAE8E = Color(0xFF6FAE8E);
const kColorSecondary7003F7A5C = Color(0xFF3F7A5C);

// --- Vàng nắng (accent — cột mốc, lời nhờ đang chờ) ---
const kColorAccent100FDF1D6 = Color(0xFFFDF1D6);
const kColorAccent500F4BF5C = Color(0xFFF4BF5C);

/// Icon vàng đậm trên nền `accent-100` (Pencil ONB-04, ONB-08 `#9A6A12`).
const kColorAccent7009A6A12 = Color(0xFF9A6A12);

// --- Tím oải hương (vùng riêng tư Papa & Mama) ---
const kColorUs50F6F2FC = Color(0xFFF6F2FC);
const kColorUs100EAE2F8 = Color(0xFFEAE2F8);
const kColorUs5009B85D1 = Color(0xFF9B85D1);
const kColorUs7006A549F = Color(0xFF6A549F);

// --- Trung tính ấm ---
const kColorBgFFFBF7 = Color(0xFFFFFBF7);
const kColorSurfaceFFFFFF = Color(0xFFFFFFFF);
const kColorSurfaceVariantF7F1EC = Color(0xFFF7F1EC);
const kColorBorderEADFD6 = Color(0xFFEADFD6);
const kColorTextPrimary2E2A27 = Color(0xFF2E2A27);
const kColorTextSecondary6B625B = Color(0xFF6B625B);
const kColorTextTertiary9C928A = Color(0xFF9C928A);
const kColorOverlay2E2A27Alpha48 = Color(0x7A2E2A27);

// --- Ngữ nghĩa ---
const kColorSuccess3E9B6E = Color(0xFF3E9B6E);
const kColorWarningD98E1F = Color(0xFFD98E1F);

/// Chỉ dùng cho lỗi hệ thống/validate — không dùng cho nhiệm vụ chưa làm.
const kColorErrorD14B4B = Color(0xFFD14B4B);
const kColorInfo3F82BF = Color(0xFF3F82BF);

// --- Màu nhận diện bé (8 màu, gán theo thứ tự) ---
const kColorChildPeachFFB59E = Color(0xFFFFB59E);
const kColorChildMint9EDCC4 = Color(0xFF9EDCC4);
const kColorChildSky9CCBF2 = Color(0xFF9CCBF2);
const kColorChildLilacC7B3F0 = Color(0xFFC7B3F0);
const kColorChildLemonF7DD86 = Color(0xFFF7DD86);
const kColorChildRoseF5A8C0 = Color(0xFFF5A8C0);
const kColorChildSandE6C9A8 = Color(0xFFE6C9A8);
const kColorChildAqua8FD8DE = Color(0xFF8FD8DE);

const kChildPalette = <Color>[
  kColorChildPeachFFB59E,
  kColorChildMint9EDCC4,
  kColorChildSky9CCBF2,
  kColorChildLilacC7B3F0,
  kColorChildLemonF7DD86,
  kColorChildRoseF5A8C0,
  kColorChildSandE6C9A8,
  kColorChildAqua8FD8DE,
];

// --- Bóng đổ ấm ---
const kColorShadow2E2A27Alpha06 = Color(0x0F2E2A27);
const kColorShadow2E2A27Alpha10 = Color(0x1A2E2A27);

// --- Dark theme — product specification 10.2 and Pencil mode=dark ---
const kColorDarkPrimary502A1A16 = Color(0xFF2A1A16);
const kColorDarkPrimary1003D231D = Color(0xFF3D231D);
const kColorDarkPrimary300C9705F = Color(0xFFC9705F);
const kColorDarkPrimary500F4917F = Color(0xFFF4917F);
const kColorDarkPrimary600F7A796 = Color(0xFFF7A796);
const kColorDarkPrimary700FFC2B5 = Color(0xFFFFC2B5);
const kColorDarkSecondary1001C2B23 = Color(0xFF1C2B23);
const kColorDarkSecondary50086C3A3 = Color(0xFF86C3A3);
const kColorDarkSecondary700A9D9BF = Color(0xFFA9D9BF);
const kColorDarkAccent10033291A = Color(0xFF33291A);
const kColorDarkAccent500F7CD7C = Color(0xFFF7CD7C);
const kColorDarkUs501F1A2B = Color(0xFF1F1A2B);
const kColorDarkUs1002C2440 = Color(0xFF2C2440);
const kColorDarkUs500B5A3E3 = Color(0xFFB5A3E3);
const kColorDarkUs700D2C6F0 = Color(0xFFD2C6F0);
const kColorDarkBg171412 = Color(0xFF171412);
const kColorDarkSurface221E1B = Color(0xFF221E1B);
const kColorDarkSurfaceVariant2C2724 = Color(0xFF2C2724);
const kColorDarkBorder3A3430 = Color(0xFF3A3430);
const kColorDarkTextPrimaryF5EFEA = Color(0xFFF5EFEA);
const kColorDarkTextSecondaryBDB3AB = Color(0xFFBDB3AB);
const kColorDarkTextTertiary8A817A = Color(0xFF8A817A);
const kColorDarkOverlayBlackAlpha60 = Color(0x99000000);
const kColorDarkSuccess6FCB9C = Color(0xFF6FCB9C);
const kColorDarkWarningF2B85B = Color(0xFFF2B85B);
const kColorDarkErrorF08080 = Color(0xFFF08080);
const kColorDarkInfo7DB3E0 = Color(0xFF7DB3E0);

/// Overlay used by the original CARE/US/SW/QC bottom sheets.
const kColorSheetScrim2E2A27Alpha60 = Color(0x992E2A27);

// --- Pencil component effects (luKhc TabBar, FAB, CARE-01 segmented tabs) ---
/// TabBar shadow `#2E2A271F` (y −4, blur 24).
const kColorShadow2E2A27Alpha12 = Color(0x1F2E2A27);

/// Selected segment shadow `#2E2A2714` (y 1, blur 4).
const kColorShadow2E2A27Alpha08 = Color(0x142E2A27);

/// Center FAB glow `#EE7B6766` (y 6, blur 16).
const kColorShadowPrimary500Alpha40 = Color(0x66EE7B67);

/// Extended FAB (“Thêm nhiệm vụ”) glow `#C2513F40`.
const kColorShadowPrimary600Alpha25 = Color(0x40C2513F);

/// Destructive settings row icon background `#C2513F1A` (SET-01 Đăng xuất).
const kColorPrimary600Alpha10 = Color(0x1AC2513F);

/// “+3” overlay on photo grids `#2E2A2780`.
const kColorOverlay2E2A27Alpha50 = Color(0x802E2A27);

/// Selected week-day label on coral `#FFFFFFCC`.
const kColorWhiteAlpha80 = Color(0xCCFFFFFF);

/// Bóng vòng tròn thành công CARE-06 `#6FAE8E66`.
const kColorShadowSecondary500Alpha40 = Color(0x666FAE8E);

/// Nút tròn trên ảnh bìa HOME-02 `#FFFFFF33`.
const kColorWhiteAlpha20 = Color(0x33FFFFFF);

/// Lớp phủ đáy ảnh bìa HOME-02 `#2E2A27B3` (từ trong suốt `#2E2A2700`).
const kColorCoverScrim2E2A27Alpha70 = Color(0xB32E2A27);
const kColorCoverScrim2E2A27Alpha00 = Color(0x002E2A27);

// Khu Ký ức (MEM-05/07/21/25): lớp phủ trên ảnh/camera + chữ thẻ cột mốc.
/// Nút tròn trên ảnh hero (MEM-07 `#2E2A2766`).
const kColorOverlay2E2A27Alpha40 = Color(0x662E2A27);

/// Nút/nhãn trên camera (MEM-21 `#00000066`).
const kColorBlackAlpha40 = Color(0x66000000);

/// Bảng dưới camera, bóng dưới story (MEM-21/25 `#000000B3`).
const kColorBlackAlpha70 = Color(0xB3000000);

/// Nút phụ trên camera (MEM-21 `#FFFFFF22`).
const kColorWhiteAlpha13 = Color(0x22FFFFFF);

/// Nút cảm xúc story (MEM-25 `#FFFFFF26`).
const kColorWhiteAlpha15 = Color(0x26FFFFFF);

/// Đoạn tiến độ chưa xem (MEM-25 `#FFFFFF55`).
const kColorWhiteAlpha33 = Color(0x55FFFFFF);

/// Viền ô trả lời story (MEM-25 `#FFFFFF80`).
const kColorWhiteAlpha50 = Color(0x80FFFFFF);

/// Chữ gợi ý ô trả lời story (MEM-25 `#FFFFFFB3`).
const kColorWhiteAlpha70 = Color(0xB3FFFFFF);

/// PREG-05 welcome card shadow `#6A549F33` (y 10, blur 30).
const kColorShadowUs700Alpha20 = Color(0x336A549F);

/// Nền nút tròn trên ảnh bìa (CHD-01 `#FFFFFFE6`).
const kColorWhiteAlpha90 = Color(0xE6FFFFFF);

/// Băng dính / huy hiệu trên giấy note (US-06 `#FFFFFF99`, `#FFFFFF66`).
const kColorWhiteAlpha60 = Color(0x99FFFFFF);
const kColorWhiteAlpha40 = Color(0x66FFFFFF);

/// Giấy note cảm ơn của tôi (US-06 `#FFE9B8`).
const kColorNoteYellowFFE9B8 = Color(0xFFFFE9B8);

/// Giấy note cảm ơn của bạn đời (US-06 `#D9EEDF`).
const kColorNoteGreenD9EEDF = Color(0xFFD9EEDF);

/// Lớp tối đầu ảnh bìa CHD-01 (`#00000059` → trong suốt).
const kColorBlackAlpha35 = Color(0x59000000);
const kColorBlackAlpha00 = Color(0x00000000);

// Khu Ký ức batch 2 (MEM-03a/08/10/11/13/14/15/16, REC-02).
/// Icon vàng trên nền `accent-100` (MEM-11/13/14/15, REC-02 `#B7862B`).
const kColorAccent600B7862B = Color(0xFFB7862B);

/// Viền lịch ngày MEM-16 `#F0DDB0`.
const kColorAccentBorderF0DDB0 = Color(0xFFF0DDB0);

/// Chữ “Xoá” trên menu nền tối MEM-10 `#FF9A8A`.
const kColorDangerOnDarkFF9A8A = Color(0xFFFF9A8A);

/// Lớp tối nền khi mở menu MEM-03a `#2E2A2733`.
const kColorOverlay2E2A27Alpha20 = Color(0x332E2A27);

/// Bóng menu giữ lâu MEM-10 `#2E2A2740`.
const kColorShadow2E2A27Alpha25 = Color(0x402E2A27);

/// Nút / viền trên nền đen MEM-08 `#FFFFFF1F`.
const kColorWhiteAlpha12 = Color(0x1FFFFFFF);

/// Chấm trang chưa chọn MEM-08 `#FFFFFF59`.
const kColorWhiteAlpha35 = Color(0x59FFFFFF);

/// Dòng meta chú thích MEM-08 `#FFFFFFA6`.
const kColorWhiteAlpha65 = Color(0xA6FFFFFF);

/// Meta trên ảnh bìa album MEM-03a `#FFFFFFDD`.
const kColorWhiteAlpha87 = Color(0xDDFFFFFF);

/// Giấy viết thư MEM-14 `#FFFDF7`, viền `#EBDDC8`, mực `#4A3F36`, bóng
/// `#8A6A4020`.
const kColorLetterPaperFFFDF7 = Color(0xFFFFFDF7);
const kColorLetterBorderEBDDC8 = Color(0xFFEBDDC8);
const kColorLetterInk4A3F36 = Color(0xFF4A3F36);
const kColorLetterShadow8A6A40Alpha13 = Color(0x208A6A40);

/// Phong bì MEM-14: thân `#F6E6D2`, nắp `#EFD8BC`, viền `#E5CFB3`, tên
/// `#7A4E2E`, ngày mở `#8C6A4E`.
const kColorEnvelopeF6E6D2 = Color(0xFFF6E6D2);
const kColorEnvelopeFlapEFD8BC = Color(0xFFEFD8BC);
const kColorEnvelopeBorderE5CFB3 = Color(0xFFE5CFB3);
const kColorEnvelopeInk7A4E2E = Color(0xFF7A4E2E);
const kColorEnvelopeMeta8C6A4E = Color(0xFF8C6A4E);
