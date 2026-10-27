import 'package:baby_family/data/service_imp/offline_read.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _offline() =>
    DioException(requestOptions: RequestOptions(path: '/x'));

DioException _status(int code) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    response: Response(requestOptions: options, statusCode: code),
  );
}

void main() {
  test(
    'OfflineReads: offline returns the last good read for the same key',
    () async {
      final reads = OfflineReads();
      expect(await reads.read(['badges', 'fam-1'], () async => [1, 2]), [1, 2]);
      expect(
        await reads.read<List<int>>([
          'badges',
          'fam-1',
        ], () => throw _offline()),
        [1, 2],
      );
      // Khoá khác (gia đình / người dùng khác) không dùng chung bản đệm.
      await expectLater(
        reads.read<List<int>>(['badges', 'fam-2'], () => throw _offline()),
        throwsA(isA<DioException>()),
      );
      // Lỗi nghiệp vụ (4xx) không bị che bằng bản cũ.
      await expectLater(
        reads.read<List<int>>(['badges', 'fam-1'], () => throw _status(403)),
        throwsA(isA<DioException>()),
      );
      reads.clear();
      await expectLater(
        reads.read<List<int>>(['badges', 'fam-1'], () => throw _offline()),
        throwsA(isA<DioException>()),
      );
    },
  );

  test('whenOnline: null when offline, rethrows refusals', () async {
    expect(await whenOnline(() async => 3), 3);
    expect(await whenOnline<int>(() => throw _offline()), isNull);
    expect(await whenOnline<int>(() => throw _status(503)), isNull);
    await expectLater(
      whenOnline<int>(() => throw _status(404)),
      throwsA(isA<DioException>()),
    );
  });
}
