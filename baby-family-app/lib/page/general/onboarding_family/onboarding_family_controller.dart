import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/person_name.dart';
import 'package:hooks_riverpod/legacy.dart';

/// ONB-06 — đặt tên gia đình (điền sẵn “Nhà {tên}”), tạo gia đình
/// `WAITING_PARTNER` rồi sang ONB-07.
final onboardingFamilyControllerProvider =
    ChangeNotifierProvider.autoDispose<OnboardingFamilyController>(
      OnboardingFamilyController.new,
    );

class OnboardingFamilyController extends BaseNotifier {
  OnboardingFamilyController(super.ref);

  ISessionService get sessionService => ref.read(sessionServiceProvider);

  /// “Lan” — tên ngắn của người tạo.
  String get firstName => shortPersonName(sessionService.userName);

  FamilyRole get role => sessionService.current.role ?? FamilyRole.mother;

  String get callName {
    final value = sessionService.current.callName;
    return value == null || value.isEmpty ? _defaultCallName(role) : value;
  }

  String get partnerCallName => _defaultCallName(role.partnerRole);

  Future<void> create(String name) async {
    await whileLoading(() async {
      await sessionService.createFamily(name: name);
    });
  }

  static String _defaultCallName(FamilyRole role) => switch (role) {
    FamilyRole.father => kValueDefaultCallNameFather,
    FamilyRole.mother => kValueDefaultCallNameMother,
    FamilyRole.relative => '',
  };
}
