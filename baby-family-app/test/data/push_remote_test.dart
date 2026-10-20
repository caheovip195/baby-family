import 'dart:async';

import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:baby_family/data/repository/auth.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/push_token.dart';
import 'package:baby_family/data/service/auth.dart';
import 'package:baby_family/data/service_imp/push_remote.dart';
import 'package:flutter_test/flutter_test.dart';

/// FCM giả (BF-20261018-014).
class _FakeTokens extends Fake implements IPushTokenRepository {
  bool allow = true;
  bool authorized = false;
  String? value = 'fcm-token-0123456789abcdef';
  final refresh = StreamController<String>.broadcast();

  @override
  Future<bool> requestPermission() async => allow;

  @override
  Future<bool> isAuthorized() async => authorized;

  @override
  Future<String?> token() async => value;

  @override
  Stream<String> get onTokenRefresh => refresh.stream;
}

class _FakeAuthRepository extends Fake implements IAuthRepository {
  final devices = <JsonMap>[];

  @override
  Future<void> registerDevice(JsonMap device) async => devices.add(device);
}

class _FakeAuth extends Fake implements IAuthService {
  bool signedIn = true;

  @override
  Future<AuthCertificate?> currentSession() async =>
      signedIn ? const AuthCertificate(accessToken: 'access') : null;
}

void main() {
  late _FakeTokens tokens;
  late _FakeAuthRepository repository;
  late _FakeAuth auth;
  late PushRemoteServiceImp push;

  setUp(() {
    tokens = _FakeTokens();
    repository = _FakeAuthRepository();
    auth = _FakeAuth();
    push = PushRemoteServiceImp(
      auth,
      repository,
      tokens,
      platform: () => 'IOS',
    );
    addTearDown(push.dispose);
    addTearDown(tokens.refresh.close);
  });

  test('ONB-10: allowing notifications registers the FCM token', () async {
    expect(await push.enable(), isTrue);
    expect(repository.devices.single, {
      'platform': 'IOS',
      'locale': repository.devices.single['locale'],
      'pushEnabled': true,
      'pushToken': 'fcm-token-0123456789abcdef',
    });

    // A rotated token is sent again.
    tokens.refresh.add('fcm-token-rotated-0123456789');
    await Future<void>.delayed(Duration.zero);
    expect(
      repository.devices.last['pushToken'],
      'fcm-token-rotated-0123456789',
    );
  });

  test('ONB-10: refusing clears the token on the server', () async {
    tokens.allow = false;
    expect(await push.enable(), isFalse);
    expect(repository.devices.single['pushEnabled'], isFalse);
    expect(repository.devices.single['pushToken'], isNull);
  });

  test('app start re-sends only when already allowed and signed in', () async {
    await push.syncIfAuthorized();
    expect(repository.devices, isEmpty);
    tokens.authorized = true;
    auth.signedIn = false;
    await push.syncIfAuthorized();
    expect(repository.devices, isEmpty);
    auth.signedIn = true;
    await push.syncIfAuthorized();
    expect(repository.devices.single['pushEnabled'], isTrue);
  });
}
