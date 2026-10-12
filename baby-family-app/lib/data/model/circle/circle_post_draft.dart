import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_post_draft.freezed.dart';
part 'circle_post_draft.g.dart';

/// CIR-04 bài đăng của người thân (chờ bố mẹ duyệt).
@Freezed(when: FreezedWhenOptions.none)
abstract class CirclePostDraft with _$CirclePostDraft {
  @JsonSerializable(explicitToJson: true)
  const factory CirclePostDraft({
    @JsonKey(name: 'mediaAssets') @Default([]) List<String> mediaAssets,
    @JsonKey(name: 'childIds') @Default([]) List<String> childIds,
    @JsonKey(name: 'takenAt') DateTime? takenAt,
    @JsonKey(name: 'message') @Default('') String message,
  }) = _CirclePostDraft;

  factory CirclePostDraft.fromJson(Map<String, dynamic> json) =>
      _$CirclePostDraftFromJson(json);
}
