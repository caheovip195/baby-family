import 'package:baby_family/data/model/memory/download_url_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_url_list.freezed.dart';
part 'download_url_list.g.dart';

/// `{items: [...]}` của `POST /memories/:id/download-urls`.
@Freezed(when: FreezedWhenOptions.none)
abstract class DownloadUrlList with _$DownloadUrlList {
  @JsonSerializable(explicitToJson: true)
  const factory DownloadUrlList({
    @JsonKey(name: 'items')
    @Default(<DownloadUrlRecord>[])
    List<DownloadUrlRecord> items,
  }) = _DownloadUrlList;

  factory DownloadUrlList.fromJson(Map<String, dynamic> json) =>
      _$DownloadUrlListFromJson(json);
}
