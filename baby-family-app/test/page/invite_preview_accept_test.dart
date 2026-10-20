import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/service_imp/session.dart';
import 'package:baby_family/page/general/invite_preview/invite_preview_controller.dart';
import 'package:baby_family/utils/constants/enum.dart';
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
}
