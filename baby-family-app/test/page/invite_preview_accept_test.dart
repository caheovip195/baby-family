import 'package:baby_family/data/dto/invite_preview_data.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service_imp/session.dart';
import 'package:baby_family/page/general/invite_preview/invite_preview_controller.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

/// Server từ chối khi nhận lời mời (BF-20261018-015).
class _RejectingSession extends SessionServiceImp {
  _RejectingSession(
    super.sessionRepository,
    super.clock,
    super.familyRepository,
    super.childRepository,
    this.code,
  );

  final String code;

  @override
  Future<void> acceptInvite(String code, {String? callName}) async {
    final options = RequestOptions(path: '/v1/invites/accept');
    throw DioException(
      requestOptions: options,
      response: Response(
        requestOptions: options,
        statusCode: 409,
        data: {
          'error': {'code': this.code},
        },
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<InvitePreviewController> open(String errorCode) async {
    final container = ProviderContainer(
      overrides: [
        ...mockOverrides(seed: DemoSeed.fresh),
        sessionServiceProvider.overrideWith(
          (ref) => _RejectingSession(
            ref.watch(sessionRepositoryProvider),
            ref.watch(appClockProvider),
            ref.watch(familyRepositoryProvider),
            ref.watch(childRepositoryProvider),
            errorCode,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      invitePreviewControllerProvider('K7Q29MXA'),
      (_, _) {},
    );
    addTearDown(subscription.close);
    await container.read(sessionServiceProvider).restore();
    final controller = subscription.read();
    await controller.load();
    return controller;
  }

  test('an invite that expired after the preview shows INV-02', () async {
    final controller = await open('INVITE_EXPIRED');
    expect(controller.state, InvitePreviewState.valid);
    await controller.accept();
    expect(controller.state, InvitePreviewState.invalid);
  });

  test('a parent of another family is sent to INV-03 on accept', () async {
    final controller = await open('ALREADY_PARENT_OF_ANOTHER_FAMILY');
    await controller.accept();
    expect(controller.state, InvitePreviewState.alreadyParent);
  });

  test('other errors still surface to the view', () async {
    final controller = await open('SERVICE_UNAVAILABLE');
    await expectLater(controller.accept(), throwsA(isA<DioException>()));
  });

  // BF-20261026-004: bản server chỉ có tên gọi người mời, không có tên gọi đề
  // xuất cho người thân → không hiện “ (Mama) mời…”, “ · Chỉ xem”.
  testWidgets('INV-01 relative without inviter name or call name', (
    tester,
  ) async {
    await pumpRoute(
      tester,
      InvitePreviewRoute(code: 'B4N0I123'),
      seed: DemoSeed.fresh,
      overrides: [
        sessionServiceProvider.overrideWith(
          (ref) => _ServerLikePreview(
            ref.watch(sessionRepositoryProvider),
            ref.watch(appClockProvider),
            ref.watch(familyRepositoryProvider),
            ref.watch(childRepositoryProvider),
          ),
        ),
      ],
    );
    expect(find.textContaining(RegExp(r'^ [(·]')), findsNothing);
    expect(find.textContaining(RegExp(r'^Mama mời ')), findsOneWidget);
  });

  // BF-20261026-004: người thân đã nhận lời mời, chờ Papa/Mama xác nhận.
  testWidgets('CIR-WAIT says the invite was accepted while awaiting', (
    tester,
  ) async {
    await pumpRoute(
      tester,
      const CircleWaitingRoute(),
      seed: DemoSeed.fresh,
      overrides: [
        sessionServiceProvider.overrideWith(
          (ref) => _AwaitingApproval(
            ref.watch(sessionRepositoryProvider),
            ref.watch(appClockProvider),
            ref.watch(familyRepositoryProvider),
            ref.watch(childRepositoryProvider),
          ),
        ),
      ],
    );
    expect(find.text('Đã nhận lời mời'), findsOneWidget);
    expect(find.text('Bà cần được con cháu mời vào gia đình'), findsNothing);
  });
}

/// Như server: lời mời người thân chỉ có tên gọi người mời.
class _ServerLikePreview extends SessionServiceImp {
  _ServerLikePreview(
    super.sessionRepository,
    super.clock,
    super.familyRepository,
    super.childRepository,
  );

  @override
  Future<InvitePreviewData> previewInvite(String code) async {
    final data = await super.previewInvite(code);
    return InvitePreviewData(
      invite: data.invite.copyWith(
        inviterName: null,
        inviterCallName: 'Mama',
        callName: null,
      ),
      children: data.children,
      hiddenChildren: data.hiddenChildren,
      state: data.state,
    );
  }
}

/// Đã nhận lời mời người thân, chờ xác nhận lần cuối.
class _AwaitingApproval extends SessionServiceImp {
  _AwaitingApproval(
    super.sessionRepository,
    super.clock,
    super.familyRepository,
    super.childRepository,
  );

  @override
  bool get awaitingPartnerApproval => true;
}
