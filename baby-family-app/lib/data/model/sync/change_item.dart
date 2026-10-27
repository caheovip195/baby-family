import 'package:baby_family/utils/helper/lenient_json.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_item.freezed.dart';
part 'change_item.g.dart';

/// Một thay đổi từ `GET /v1/families/{fid}/changes` (BF-20261022-002):
/// `entity` = `memory` | `memoryComment` | `memoryReaction`, `op` = `upsert` |
/// `delete` (tombstone, không có [data]).
@Freezed(when: FreezedWhenOptions.none)
abstract class ChangeItem with _$ChangeItem {
  @JsonSerializable(explicitToJson: true)
  const factory ChangeItem({
    @JsonKey(name: 'entity') required String entity,
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'op') required String op,
    @JsonKey(name: 'version') int? version,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    @JsonKey(name: 'data') Map<String, dynamic>? data,
  }) = _ChangeItem;

  const ChangeItem._();

  bool get isDelete => op == 'delete';

  factory ChangeItem.fromJson(Map<String, dynamic> json) =>
      _$ChangeItemFromJson(json);
}

/// Một trang thay đổi; response **không** bọc `{data}`. Luôn lưu
/// [nextCursor] (kể cả trang rỗng).
@Freezed(when: FreezedWhenOptions.none)
abstract class ChangesPage with _$ChangesPage {
  @JsonSerializable(explicitToJson: true)
  const factory ChangesPage({
    @JsonKey(name: 'items', fromJson: _changeItems)
    @Default([])
    List<ChangeItem> items,
    @JsonKey(name: 'nextCursor') String? nextCursor,
    @JsonKey(name: 'hasMore') @Default(false) bool hasMore,
  }) = _ChangesPage;

  factory ChangesPage.fromJson(Map<String, dynamic> json) =>
      _$ChangesPageFromJson(json);
}

/// Một thay đổi hỏng không chặn cả trang (cursor vẫn tiến).
List<ChangeItem> _changeItems(Object? json) =>
    lenientList(json, ChangeItem.fromJson, label: 'thay đổi');
