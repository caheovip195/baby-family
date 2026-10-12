import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory_comment.freezed.dart';
part 'memory_comment.g.dart';

/// Bình luận ký ức (MEM-07). Tên tác giả lưu kèm để hiển thị cả khi thành viên đã rời.
@Freezed(when: FreezedWhenOptions.none)
abstract class MemoryComment with _$MemoryComment {
  @JsonSerializable(explicitToJson: true)
  const factory MemoryComment({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'memoryId') required String memoryId,
    @JsonKey(name: 'authorId') String? authorId,
    @JsonKey(name: 'authorName') @Default('') String authorName,
    @JsonKey(name: 'authorRole') FamilyRole? authorRole,
    @JsonKey(name: 'body') required String body,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'pendingApproval') @Default(false) bool pendingApproval,

    /// Bình luận gốc khi đây là trả lời (MEM-10).
    @JsonKey(name: 'parentId') String? parentId,
  }) = _MemoryComment;

  factory MemoryComment.fromJson(Map<String, dynamic> json) =>
      _$MemoryCommentFromJson(json);
}
