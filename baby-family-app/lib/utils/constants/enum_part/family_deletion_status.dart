part of '../enum.dart';

/// Xoá gia đình (mục 7.25): chưa yêu cầu → chờ Bố/Mẹ còn lại đồng ý → đã
/// hẹn xoá (còn thời gian chờ để huỷ).
enum FamilyDeletionStatus { none, awaitingPartner, scheduled }
