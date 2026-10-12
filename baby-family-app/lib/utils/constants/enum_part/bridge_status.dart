part of '../enum.dart';

/// Phiên Cầu nối (US-08…12): nháp riêng → đã mời → đang diễn ra → chọn bước
/// tiếp theo → đã đóng; có thể tạm dừng bất cứ lúc nào.
enum BridgeStatus { draft, invited, active, nextStep, closed, paused }
