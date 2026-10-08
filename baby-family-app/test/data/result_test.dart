import 'package:baby_family/data/dto/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('guardFuture trả success khi future thành công', () async {
      final result = await Result.guardFuture(() async => 42);
      expect(result.isSuccess, isTrue);
      expect(result.dataOrThrow, 42);
    });

    test('guardFuture trả failure khi future ném Exception', () async {
      final result = await Result.guardFuture<int>(
        () async => throw Exception('lỗi'),
      );
      expect(result.isFailure, isTrue);
    });
  });
}
