import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_record.freezed.dart';
part 'comment_record.g.dart';

/// Bình luận do server trả (`/v1/memories/{id}/comments`, MEM-10 — đặc tả 7.12).
@Freezed(when: FreezedWhenOptions.none)
abstract class CommentRecord with _$CommentRecord {
  @JsonSerializable(explicitToJson: true)
  const factory CommentRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'authorUserId') String? authorUserId,
    @JsonKey(name: 'parentCommentId') String? parentCommentId,
    @JsonKey(name: 'body') String? body,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'editedAt') DateTime? editedAt,
  }) = _CommentRecord;

  factory CommentRecord.fromJson(Map<String, dynamic> json) =>
      _$CommentRecordFromJson(json);
}
