import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final requestOptions = RequestOptions(path: '/v1/me');

  test('Đọc message và code từ envelope lỗi của server', () {
    final error = DioException(
      requestOptions: requestOptions,
      response: Response(
        requestOptions: requestOptions,
        statusCode: 403,
        data: {
          'error': {
            'code': 'FAMILY_NOT_ACTIVE',
            'message': 'Gia đình chưa đủ Bố và Mẹ.',
          },
        },
      ),
    );
    expect(serverErrorMessage(error), 'Gia đình chưa đủ Bố và Mẹ.');
    expect(serverErrorCode(error), 'FAMILY_NOT_ACTIVE');
  });

  test('Lỗi mạng trả câu thông báo kết nối theo ngôn ngữ hiện hành', () {
    final error = DioException(
      requestOptions: requestOptions,
      type: DioExceptionType.connectionError,
    );
    expect(serverErrorMessage(error), currentL10n().errorNetwork);
  });
}
