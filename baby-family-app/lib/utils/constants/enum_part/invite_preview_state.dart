part of '../enum.dart';

/// Trạng thái màn INV-01 theo lời mời: hợp lệ, không còn hiệu lực (INV-02),
/// đang là Bố/Mẹ ở gia đình khác (INV-03), đã nhận — chờ xác nhận (INV-04).
enum InvitePreviewState { valid, invalid, alreadyParent, waitingConfirm }
