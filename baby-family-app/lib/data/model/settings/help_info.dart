import 'package:freezed_annotation/freezed_annotation.dart';

part 'help_info.freezed.dart';
part 'help_info.g.dart';

/// Trợ giúp (SET-11): câu hỏi thường gặp (catalog đã dịch) + liên hệ.
@Freezed(when: FreezedWhenOptions.none)
abstract class HelpInfo with _$HelpInfo {
  @JsonSerializable(explicitToJson: true)
  const factory HelpInfo({
    @JsonKey(name: 'faqs') @Default([]) List<String> faqs,
    @JsonKey(name: 'openReports') @Default(0) int openReports,
    @JsonKey(name: 'email') @Default('') String email,
    @JsonKey(name: 'hotline') @Default('') String hotline,

    /// Câu trả lời cùng thứ tự với [faqs] (bản server); rỗng ở bản mẫu.
    @JsonKey(name: 'faqAnswers') @Default([]) List<String> faqAnswers,

    /// SET-12 đường dẫn pháp lý (bản server, khi đã cấu hình).
    @JsonKey(name: 'termsUrl') String? termsUrl,
    @JsonKey(name: 'privacyUrl') String? privacyUrl,
  }) = _HelpInfo;

  factory HelpInfo.fromJson(Map<String, dynamic> json) =>
      _$HelpInfoFromJson(json);
}
