import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/service_imp/base.dart';
import 'package:baby_family/utils/helper/app_clock.dart';

/// Base of the mock services: who is signed in and the injectable clock.
class MockServiceImp extends BaseServiceImp {
  MockServiceImp(this.sessionRepository, this.clock);

  final ISessionRepository sessionRepository;
  final AppClock clock;

  Future<void> ready() => sessionRepository.ensureLoaded();

  String get myUserId =>
      (sessionRepository.session()['userId'] as String?) ?? '';

  String get familyId =>
      (sessionRepository.session()['familyId'] as String?) ?? '';

  String? get myMemberId => sessionRepository.session()['memberId'] as String?;

  DateTime get now => clock.now();

  DateTime get today => clock.today;

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
