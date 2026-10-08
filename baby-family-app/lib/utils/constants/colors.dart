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
