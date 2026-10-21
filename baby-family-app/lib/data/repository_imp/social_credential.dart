import 'dart:convert';
import 'dart:math';

import 'package:baby_family/data/repository/social_credential.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Client id Google cấu hình lúc build (`--dart-define`), không fix cứng.
const _googleClientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
const _googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

class SocialCredentialRepositoryImp extends BaseRepositoryImp
    implements ISocialCredentialRepository {
  bool _googleReady = false;

  @override
  Future<AppleCredential> apple() async {
    final random = Random.secure();
    final rawNonce = base64Url.encode(
      List<int>.generate(32, (_) => random.nextInt(256)),
    );
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [AppleIDAuthorizationScopes.fullName],
        nonce: sha256.convert(utf8.encode(rawNonce)).toString(),
      );
      final token = credential.identityToken;
      if (token == null) {
        throw StateError('Apple did not return an identity token');
      }
      final name = [
        credential.givenName,
        credential.familyName,
      ].nonNulls.where((part) => part.trim().isNotEmpty).join(' ');
      return AppleCredential(
        identityToken: token,
        rawNonce: rawNonce,
        fullName: name.isEmpty ? null : name,
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) {
        throw const SocialSignInCancelled();
      }
      rethrow;
    }
  }

  @override
  Future<String> google() async {
    final signIn = GoogleSignIn.instance;
    if (!_googleReady) {
      await signIn.initialize(
        clientId: _googleClientId.isEmpty ? null : _googleClientId,
        serverClientId: _googleServerClientId.isEmpty
            ? null
            : _googleServerClientId,
      );
      _googleReady = true;
    }
    try {
      final account = await signIn.authenticate();
      final token = account.authentication.idToken;
      if (token == null) {
        throw StateError('Google did not return an id token');
      }
      return token;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const SocialSignInCancelled();
      }
      rethrow;
    }
  }
}
