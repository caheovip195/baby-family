import 'package:baby_family/data/model/memory/album_item.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'album.freezed.dart';
part 'album.g.dart';

/// Album (MEM-03): tự động (`isAuto`, `autoCode`) hoặc do gia đình tạo.
@Freezed(when: FreezedWhenOptions.none)
abstract class Album with _$Album {
  @JsonSerializable(explicitToJson: true)
  const factory Album({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'isAuto') @Default(false) bool isAuto,
    @JsonKey(name: 'autoCode') String? autoCode,
    @JsonKey(name: 'coverAsset') String? coverAsset,
    @JsonKey(name: 'coverIcon') String? coverIcon,
    @JsonKey(name: 'memoryCount') @Default(0) int memoryCount,
    @JsonKey(name: 'childIds') @Default([]) List<String> childIds,
    @JsonKey(name: 'createdByUserId') String? createdByUserId,
    @JsonKey(name: 'startDate') DateTime? startDate,
    @JsonKey(name: 'endDate') DateTime? endDate,
    @JsonKey(name: 'visibility')
    @Default(MemoryVisibility.family)
    MemoryVisibility visibility,
    @JsonKey(name: 'items') @Default([]) List<AlbumItem> items,
  }) = _Album;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}
