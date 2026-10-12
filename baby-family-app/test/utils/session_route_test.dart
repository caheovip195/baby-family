import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/model/session/pending_invite.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every session state maps to its screen (doc 9.2)', () {
    final expected = {
      SessionState.signedOut: WelcomeRoute.name,
      SessionState.needsProfile: AuthProfileRoute.name,
      SessionState.needsRole: OnboardingRoleRoute.name,
      SessionState.needsFamily: OnboardingFamilyRoute.name,
      SessionState.waitingPartner: OnboardingWaitingRoute.name,
      SessionState.activatedSetup: OnboardingActivatedRoute.name,
      SessionState.active: MainShellRoute.name,
      SessionState.circleWaiting: CircleWaitingRoute.name,
      SessionState.circleActive: CircleHomeRoute.name,
      SessionState.expired: ExpiredRoute.name,
    };
    for (final state in SessionState.values) {
      expect(
        routeForSession(AppSession(state: state)).routeName,
        expected[state],
        reason: state.name,
      );
    }
  });

  test('signed out with a pending invite continues to sign in', () {
    const session = AppSession(
      pendingInvite: PendingInvite(code: 'K7Q29MXA', kind: InviteKind.partner),
    );
    expect(routeForSession(session).routeName, AuthRoute.name);
  });
}
