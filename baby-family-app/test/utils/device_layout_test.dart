import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/device_layout.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Phân loại layout theo cạnh ngắn', () {
    expect(
      DeviceLayoutHelper.classify(const Size(390, 844)),
      DeviceLayoutClass.mobile,
    );
    expect(
      DeviceLayoutHelper.classify(const Size(768, 1024)),
      DeviceLayoutClass.tablet,
    );
  });
}
