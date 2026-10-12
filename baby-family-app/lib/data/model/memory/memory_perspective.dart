import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory_perspective.freezed.dart';
part 'memory_perspective.g.dart';

/// Góc nhìn thứ hai (MEM-24, BR-071).
@Freezed(when: FreezedWhenOptions.none)
abstract class MemoryPerspective with _$MemoryPerspective {
  @JsonSerializable(explicitToJson: true)
  const factory MemoryPerspective({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'memoryId') required String memoryId,
    @JsonKey(name: 'authorId') required String authorId,
    @JsonKey(name: 'body') @Default('') String body,
    @JsonKey(name: 'mediaAssets') @Default([]) List<String> mediaAssets,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'hiddenFromRelatives')
    @Default(false)
    bool hiddenFromRelatives,
  }) = _MemoryPerspective;

  factory MemoryPerspective.fromJson(Map<String, dynamic> json) =>
      _$MemoryPerspectiveFromJson(json);
}
