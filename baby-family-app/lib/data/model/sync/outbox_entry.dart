import 'package:freezed_annotation/freezed_annotation.dart';

part 'outbox_entry.freezed.dart';
part 'outbox_entry.g.dart';

/// Một thao tác ghi đang chờ gửi lên server (offline-first, BF-20261022-001).
/// [id] cũng là id ký ức tạm trên máy và gốc của mọi Idempotency-Key của thao
/// tác, nên gửi lại sau khi mất mạng/tắt app không tạo trùng.
@Freezed(when: FreezedWhenOptions.none)
abstract class OutboxEntry with _$OutboxEntry {
  @JsonSerializable(explicitToJson: true)
  const factory OutboxEntry({
    @JsonKey(name: 'id') required String id,

    /// Loại thao tác, vd `memory.create`.
    @JsonKey(name: 'kind') required String kind,

    /// Tham số của thao tác (đường dẫn media là bản sao trong thư mục app).
    @JsonKey(name: 'args')
    @Default(<String, dynamic>{})
    Map<String, dynamic> args,

    /// Bản ghi tạm hiện trên giao diện tới khi server nhận.
    @JsonKey(name: 'placeholder')
    @Default(<String, dynamic>{})
    Map<String, dynamic> placeholder,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'attempts') @Default(0) int attempts,

    /// Server từ chối (4xx nghiệp vụ): chờ người dùng thử lại hoặc huỷ.
    @JsonKey(name: 'failed') @Default(false) bool failed,
  }) = _OutboxEntry;

  factory OutboxEntry.fromJson(Map<String, dynamic> json) =>
      _$OutboxEntryFromJson(json);
}
