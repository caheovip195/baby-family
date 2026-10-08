import 'package:baby_family/data/remote/request_options.dart';
import 'package:baby_family/utils/constants/server.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'base_response.dart';

part 'app_client.g.dart';

/// Khai báo Retrofit — CHỈ khai báo, không xử lý logic (Skill 6).
/// Endpoint lấy từ `Api` (utils/constants/server.dart).
@RestApi()
sealed class AppClient {
  factory AppClient(Dio dio, {String? baseUrl}) = _AppClient;

  // ========================================================================
  // AUTH & ME
  // ========================================================================

  @POST(Api.authRefresh)
  @Extra({
    RequestOptionsExtra.deviceReq: true,
    RequestOptionsExtra.authRefresh: true,
  })
  Future<AuthCertificateRespond> refreshToken(
    @Body() Map<String, dynamic> body,
  );

  @POST(Api.authLogout)
  @Extra({
    RequestOptionsExtra.requiresAuth: true,
    RequestOptionsExtra.deviceReq: true,
  })
  Future<void> logout(@Body() Map<String, dynamic> body);

  @GET(Api.me)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<UserRespond> getMe();

  /// Cập nhật hồ sơ: `displayName`, `avatarAssetId`, `locale`, `timezone`.
  @PATCH(Api.me)
  @Extra({RequestOptionsExtra.requiresAuth: true})
  Future<UserRespond> updateMe(@Body() Map<String, dynamic> body);

  @POST(Api.meDevices)
  @Extra({
    RequestOptionsExtra.requiresAuth: true,
    RequestOptionsExtra.deviceReq: true,
  })
  Future<void> registerDevice(@Body() Map<String, dynamic> body);
}
