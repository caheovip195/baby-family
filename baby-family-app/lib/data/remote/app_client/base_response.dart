import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:baby_family/data/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response.freezed.dart';
part 'base_response.g.dart';

/// Envelope response thành công của API: `{ "data": <payload>, "nextCursor"? }`.
/// Lỗi: `{ "error": { code, messageKey, message, details, traceId } }` — xử lý
/// ở `ErrorHandleInterceptor` / `serverErrorMessage`.
///
/// Mỗi kiểu response là một factory; nhóm theo module giống tài liệu kỹ thuật
/// mục 11.3.
@freezed
sealed class BaseRespond with _$BaseRespond {
  BaseRespond._();

  // ========================================================================
  // AUTH & ME
  // ========================================================================

  factory BaseRespond.authCertificateRespond({
    @JsonKey(name: 'data') AuthCertificate? auth,
  }) = AuthCertificateRespond;

  factory BaseRespond.userRespond({@JsonKey(name: 'data') User? user}) =
      UserRespond;

  factory BaseRespond.fromJson(Map<String, dynamic> json) =>
      _$BaseRespondFromJson(json);
}
