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

    /// Asset id của server cùng thứ tự [mediaAssets] (để sửa giữ ảnh cũ).
    @JsonKey(name: 'mediaAssetIds') @Default([]) List<String> mediaAssetIds,

    /// URL phát video cùng thứ tự [mediaAssets] (ảnh: null, BF-20261030-008).
    @JsonKey(name: 'mediaVideos') @Default([]) List<String?> mediaVideos,

    /// Ghi âm góc nhìn: URL nghe (server) hoặc tệp trên máy (bản mock).
    @JsonKey(name: 'voiceUrl') String? voiceUrl,
    @JsonKey(name: 'voiceDurationSec') int? voiceDurationSec,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'hiddenFromRelatives')
    @Default(false)
    bool hiddenFromRelatives,
  }) = _MemoryPerspective;

  factory MemoryPerspective.fromJson(Map<String, dynamic> json) =>
      _$MemoryPerspectiveFromJson(json);
}
