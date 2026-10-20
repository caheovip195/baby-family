import 'package:baby_family/data/model/memory/album_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_list.freezed.dart';
part 'album_list.g.dart';

/// `{items: [...]}` của `GET /families/:fid/albums`.
@Freezed(when: FreezedWhenOptions.none)
abstract class AlbumList with _$AlbumList {
  @JsonSerializable(explicitToJson: true)
  const factory AlbumList({
    @JsonKey(name: 'items') @Default(<AlbumRecord>[]) List<AlbumRecord> items,
  }) = _AlbumList;

  factory AlbumList.fromJson(Map<String, dynamic> json) =>
      _$AlbumListFromJson(json);
}
