import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';

/// Màn tương ứng với trạng thái phiên (tài liệu nghiệp vụ 9.2 “Logic điều
/// hướng”). Splash và các bước onboarding “đi tiếp” dùng hàm này.
///
/// Không có guard chặn route: bản UI-first luôn cho đi xuyên luồng; trạng thái
/// phiên được đẩy tiến bởi các service (`ISessionService`).
PageRouteInfo routeForSession(AppSession session) {
  return switch (session.state) {
    SessionState.signedOut =>
      session.pendingInvite == null ? const WelcomeRoute() : const AuthRoute(),
    SessionState.needsProfile => const AuthProfileRoute(),
    SessionState.needsRole => const OnboardingRoleRoute(),
    SessionState.needsFamily => const OnboardingFamilyRoute(),
    SessionState.waitingPartner => const OnboardingWaitingRoute(),
    SessionState.activatedSetup => const OnboardingActivatedRoute(),
    SessionState.active => const MainShellRoute(),
    SessionState.circleWaiting => const CircleWaitingRoute(),
    SessionState.circleActive => const CircleHomeRoute(),
    SessionState.expired => const ExpiredRoute(),
  };
}
