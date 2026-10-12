import 'package:freezed_annotation/freezed_annotation.dart';

part 'thanks.freezed.dart';
part 'thanks.g.dart';

/// Lời cảm ơn (US-05, mục 7.16.3).
@Freezed(when: FreezedWhenOptions.none)
abstract class Thanks with _$Thanks {
  @JsonSerializable(explicitToJson: true)
  const factory Thanks({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'fromUserId') required String fromUserId,
    @JsonKey(name: 'toUserId') required String toUserId,
    @JsonKey(name: 'body') @Default('') String body,
    @JsonKey(name: 'sticker') String? sticker,
    @JsonKey(name: 'missionId') String? missionId,
    @JsonKey(name: 'memoryId') String? memoryId,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'postedToFamily') @Default(false) bool postedToFamily,

    /// Icon Lucide của thẻ trên bức tường cảm ơn (US-06).
    @JsonKey(name: 'icon') String? icon,

    /// Tên việc/ký ức được gắn (“Thư gửi Hana”).
    @JsonKey(name: 'linkedTitle') String? linkedTitle,

    /// Ai đã thả tim lời cảm ơn này.
    @JsonKey(name: 'reactedByUserIds')
    @Default([])
    List<String> reactedByUserIds,
  }) = _Thanks;

  factory Thanks.fromJson(Map<String, dynamic> json) => _$ThanksFromJson(json);
}
