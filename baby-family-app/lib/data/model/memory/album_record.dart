import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_record.freezed.dart';
part 'album_record.g.dart';

/// Album trên server (MEM-03); `cover` là ký ức bìa người gọi xem được.
@Freezed(when: FreezedWhenOptions.none)
abstract class AlbumRecord with _$AlbumRecord {
  @JsonSerializable(explicitToJson: true)
  const factory AlbumRecord({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'ownerUserId') String? ownerUserId,
    @JsonKey(name: 'isSensitive') @Default(false) bool isSensitive,
    @JsonKey(name: 'coverMemoryId') String? coverMemoryId,
    @JsonKey(name: 'cover') MemoryRecord? cover,
    @JsonKey(name: 'memoryCount') @Default(0) int memoryCount,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _AlbumRecord;

  factory AlbumRecord.fromJson(Map<String, dynamic> json) =>
      _$AlbumRecordFromJson(json);
}
