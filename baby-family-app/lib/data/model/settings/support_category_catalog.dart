import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_category_catalog.freezed.dart';
part 'support_category_catalog.g.dart';

/// Danh mục yêu cầu hỗ trợ do server cấu hình (`{version, categories}`).
@Freezed(when: FreezedWhenOptions.none)
abstract class SupportCategoryCatalog with _$SupportCategoryCatalog {
  @JsonSerializable(explicitToJson: true)
  const factory SupportCategoryCatalog({
    @JsonKey(name: 'version') int? version,
    @JsonKey(name: 'categories') @Default(<String>[]) List<String> categories,
  }) = _SupportCategoryCatalog;

  factory SupportCategoryCatalog.fromJson(Map<String, dynamic> json) =>
      _$SupportCategoryCatalogFromJson(json);
}
