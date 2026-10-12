part of '../enum.dart';

/// Chủ nhiệm vụ nhìn từ người đang đăng nhập (suy ra từ `ownerUserId`).
/// Tạo nhiệm vụ chỉ được `me` hoặc `together` (BR-020).
enum MissionOwnerKind { me, partner, together }
