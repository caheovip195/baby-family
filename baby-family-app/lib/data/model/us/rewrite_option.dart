import 'package:baby_family/utils/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rewrite_option.freezed.dart';
part 'rewrite_option.g.dart';

/// Một phiên bản viết lại (US-09).
@Freezed(when: FreezedWhenOptions.none)
abstract class RewriteOption with _$RewriteOption {
  @JsonSerializable(explicitToJson: true)
  const factory RewriteOption({
    @JsonKey(name: 'tone') required RewriteTone tone,
    @JsonKey(name: 'text') required String text,
  }) = _RewriteOption;

  factory RewriteOption.fromJson(Map<String, dynamic> json) =>
      _$RewriteOptionFromJson(json);
}
