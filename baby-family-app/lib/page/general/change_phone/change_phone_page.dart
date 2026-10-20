import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/change_phone/mobile/change_phone_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET bảo mật — đổi số điện thoại đăng nhập.
@RoutePage()
class ChangePhonePage extends BaseHookWidget {
  const ChangePhonePage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const ChangePhoneMobileView();
  }
}
