import 'dart:convert';

import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:baby_family/data/model/circle/circle_post_draft.dart';
import 'package:baby_family/data/model/circle/circle_subject_record.dart';
import 'package:baby_family/data/model/circle/my_circle_record.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/session/bootstrap_entitlement.dart';
import 'package:baby_family/data/model/session/bootstrap_family.dart';
import 'package:baby_family/data/model/session/bootstrap_parent.dart';
import 'package:baby_family/data/model/session/bootstrap_subject.dart';
import 'package:baby_family/data/model/session/family_bootstrap.dart';
import 'package:baby_family/data/model/session/invite_decision.dart';
import 'package:baby_family/data/model/session/invite_resolution.dart';
import 'package:baby_family/data/model/session/me_awaiting_approval.dart';
import 'package:baby_family/data/model/session/me_family.dart';
import 'package:baby_family/data/model/session/me_profile.dart';
import 'package:baby_family/data/model/session/otp_dispatch.dart';
import 'package:baby_family/data/model/session/partner_invite_issued.dart';
import 'package:baby_family/data/model/session/partner_invite_status.dart';
import 'package:baby_family/data/model/user.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/notification.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/auth.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/offline_snapshot.dart';
import 'package:baby_family/data/repository/onboarding.dart';
import 'package:baby_family/data/service/auth.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/data/service_imp/circle_remote.dart';
import 'package:baby_family/data/service_imp/session.dart';
import 'package:baby_family/data/service_imp/session_remote.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

/// Server giả: giữ trạng thái `GET /me` + gia đình như backend (BF-20261015-012).
class _FakeServer {
  MeProfile me = const MeProfile(id: 'srv-user', displayName: 'Baby Family');

  /// Mất mạng: mọi lời gọi server lỗi kết nối.
  bool offline = false;
  String? familyStatus;
  String inviteStatus = 'PENDING';
  int invitesIssued = 0;
  final consents = <JsonMap>[];
  final cache = <String, JsonMap>{};
  final setupDone = <String>{};
  bool resolveFound = true;
  String accessPhase = 'TRIAL';
  String acceptResult = 'AWAITING_APPROVAL';
  List<BootstrapSubject> subjects = const [];
  InviteResolution? circleInvite;
  List<MyCircleRecord> circles = const [];
  final left = <String>[];
}

class _FakeAuthService implements IAuthService {
  AuthCertificate? saved;

  @override
  Future<AuthCertificate?> currentSession() async => saved;

  @override
  Future<AuthCertificate> saveSession(AuthCertificate certificate) async =>
      saved = certificate;

  @override
  Future<User?> getMe() async => null;

  @override
  Future<void> logout() async => saved = null;
}

class _FakeAuthRepository implements IAuthRepository {
  _FakeAuthRepository(this.server);

  final _FakeServer server;

  @override
  Future<OtpDispatch?> requestPhoneOtp(String phone) async =>
      const OtpDispatch(expiresIn: 300, resendIn: 60, channelUsed: 'MAIL');

  @override
  Future<AuthCertificate> verifyPhoneOtp({
    required String phone,
    required String code,
    required JsonMap device,
  }) async => const AuthCertificate(
    accessToken: 'access',
    refreshToken: 'refresh',
    expiresIn: 900,
  );

  @override
  Future<MeProfile?> getMeProfile() async {
    if (server.offline) {
      throw DioException.connectionError(
        requestOptions: RequestOptions(path: '/me'),
        reason: 'offline',
      );
    }
    return server.me;
  }

  @override
  Future<void> updateProfile(JsonMap patch) async {
    server.me = server.me.copyWith(displayName: patch['displayName'] as String);
  }

  @override
  Future<void> recordConsents(
    List<JsonMap> consents, {
    String? platform,
  }) async {
    server.consents.addAll(consents);
    server.me = server.me.copyWith(profileCompleted: true);
  }

  @override
  Future<MeProfile?> setOnboardingRole(String role) async =>
      server.me = server.me.copyWith(onboardingRole: role);

  @override
  Future<void> registerDevice(JsonMap device) async {}

  @override
  Future<AuthCertificate> refreshToken(String refreshToken) =>
      throw UnimplementedError();

  @override
  Future<void> logout(String refreshToken) async {}

  @override
  Future<User?> getMe() async => null;
}

class _FakeOnboardingRepository implements IOnboardingRepository {
  _FakeOnboardingRepository(this.server);

  final _FakeServer server;

  FamilyBootstrap get _bootstrap => FamilyBootstrap(
    family: BootstrapFamily(
      id: 'srv-family',
      name: 'Nhà thử',
      status: server.familyStatus,
    ),
    entitlement: BootstrapEntitlement(accessPhase: server.accessPhase),
    subjects: server.subjects,
    parents: const [
      BootstrapParent(userId: 'srv-user', slot: 'PARENT_1'),
      BootstrapParent(userId: 'srv-partner', slot: 'PARENT_2'),
    ],
  );

  @override
  Future<FamilyBootstrap?> createFamily({
    required String name,
    String? kind,
    String? callName,
  }) async {
    server.familyStatus = 'WAITING_PARTNER';
    server.me = server.me.copyWith(
      families: [
        MeFamily(
          familyId: 'srv-family',
          name: name,
          status: 'WAITING_PARTNER',
          slot: 'A',
          kind: 'MOTHER',
          callName: callName ?? 'Mama',
        ),
      ],
    );
    return _bootstrap;
  }

  @override
  Future<void> cancelFamily(String familyId) async {
    server.familyStatus = null;
    server.me = server.me.copyWith(families: [], onboardingRole: null);
  }

  @override
  Future<FamilyBootstrap?> bootstrap(String familyId) async => _bootstrap;

  @override
  Future<PartnerInviteIssued?> createPartnerInvite(
    String familyId, {
    bool requireFinalApproval = true,
    String? message,
  }) async {
    server.invitesIssued++;
    return PartnerInviteIssued(
      inviteId: 'inv-${server.invitesIssued}',
      code: 'K7Q29MX${server.invitesIssued}',
      url: 'https://babyfamily.vn/i/token',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
  }

  @override
  Future<PartnerInviteStatus?> partnerInviteStatus(String familyId) async =>
      PartnerInviteStatus(
        inviteId: 'inv-${server.invitesIssued}',
        status: server.inviteStatus,
        acceptedCallName: 'Bố',
      );

  @override
  Future<InviteResolution?> resolveInvite(String code) async {
    if (!server.resolveFound) {
      throw DioException(
        requestOptions: RequestOptions(),
        response: Response(requestOptions: RequestOptions(), statusCode: 404),
      );
    }
    final circle = server.circleInvite;
    if (circle != null) {
      return circle;
    }
    return const InviteResolution(
      inviteId: 'inv-9',
      type: 'PARTNER',
      state: 'VALID',
      familyName: 'Nhà Lan',
      inviterCallName: 'Mama',
      proposedKind: 'FATHER',
    );
  }

  @override
  Future<InviteDecision?> acceptInvite(String code, {String? callName}) async {
    if (server.circleInvite != null) {
      return const InviteDecision(status: 'AWAITING_APPROVAL');
    }
    if (server.acceptResult == 'AWAITING_APPROVAL') {
      server.me = server.me.copyWith(
        onboardingRole: 'PARENT_FATHER',
        awaitingApproval: [
          const MeAwaitingApproval(inviteId: 'inv-9', familyName: 'Nhà Lan'),
        ],
      );
    }
    return InviteDecision(status: server.acceptResult, familyId: 'other');
  }

  @override
  Future<InviteDecision?> declineInvite(String code) async =>
      const InviteDecision(status: 'DECLINED');

  @override
  Future<InviteDecision?> decideInvite(
    String inviteId, {
    required bool approve,
  }) async {
    if (approve) {
      server.familyStatus = 'ACTIVE';
      final family = server.me.families.first.copyWith(status: 'ACTIVE');
      server.me = server.me.copyWith(families: [family]);
    }
    return InviteDecision(status: approve ? 'JOINED' : 'DECLINED');
  }

  @override
  Future<JsonMap?> cachedPartnerInvite(String familyId) async =>
      server.cache[familyId];

  @override
  Future<void> cachePartnerInvite(String familyId, JsonMap invite) async =>
      server.cache[familyId] = invite;

  @override
  Future<bool> isSetupDone(String familyId) async =>
      server.setupDone.contains(familyId);

  @override
  Future<void> markSetupDone(String familyId) async =>
      server.setupDone.add(familyId);

  @override
  Future<List<MyCircleRecord>> myCircles() async => server.circles;

  @override
  Future<void> leaveCircle(String familyId) async {
    server.left.add(familyId);
    server.circles = const [];
  }
}

/// Bản chụp mất mạng giữ trong bộ nhớ (thay LocalStore).
class _MemorySnapshots implements IOfflineSnapshotRepository {
  JsonMap? saved;

  @override
  Future<void> save(JsonMap snapshot) async =>
      saved = jsonDecode(jsonEncode(snapshot)) as JsonMap;

  @override
  Future<JsonMap?> load() async => saved;
}

/// Bảng tin server giả cho app người thân: ghi lại lời gọi.
class _FakeMemoryService implements IMemoryService {
  final calls = <String>[];
  final created = <JsonMap>[];

  @override
  Future<List<Memory>> memories({
    String? childId,
    Set<MemoryKind>? kinds,
  }) async {
    calls.add('memories');
    return const [];
  }

  @override
  Future<Memory> create({
    required MemoryKind kind,
    required List<String> childIds,
    String? title,
    String? body,
    String? quoteContext,
    List<String> mediaAssets = const [],
    MemoryVisibility visibility = MemoryVisibility.family,
    DateTime? occurredAt,
    String? feeling,
    List<String> people = const [],
    String? milestoneCode,
    String? milestoneTitle,
    int? monthIndex,
    int? pregnancyWeek,
    int? voiceDurationSec,
    DateTime? sealedUntil,
    String? missionId,
    bool deferUpload = false,
  }) async {
    created.add({
      'kind': kind.name,
      'childIds': childIds,
      'body': body,
      'mediaAssets': mediaAssets,
      'visibility': visibility.name,
    });
    return Memory(
      id: 'm-new',
      familyId: 'local',
      kind: kind,
      authorId: 'me',
      occurredAt: DateTime(2026, 10, 19),
      createdAt: DateTime(2026, 10, 19),
    );
  }

  @override
  Future<void> react(String memoryId, String emoji) async =>
      calls.add('react:$memoryId:$emoji');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeServer server;
  late _FakeAuthService auth;
  late ProviderContainer container;
  late _MemorySnapshots snapshots;

  SessionRemoteServiceImp build() {
    container = ProviderContainer(
      overrides: mockOverrides(seed: DemoSeed.fresh),
    );
    addTearDown(container.dispose);
    return SessionRemoteServiceImp(
      container.read(sessionServiceProvider) as SessionServiceImp,
      auth,
      _FakeAuthRepository(server),
      _FakeOnboardingRepository(server),
      container.read(childRepositoryProvider),
      snapshots,
    );
  }

  setUp(() {
    snapshots = _MemorySnapshots();
    server = _FakeServer();
    auth = _FakeAuthService();
  });

  test('Parent A: OTP → profile → role → family → approval → trial', () async {
    final session = build();
    expect(session.usesServer, isTrue);
    expect((await session.restore()).state, SessionState.signedOut);

    await session.requestOtp('+84912345678');
    await session.verifyOtp('123456');
    expect(auth.saved?.accessToken, 'access');
    expect(session.current.state, SessionState.needsProfile);

    await session.saveProfile(name: 'Lan');
    expect(server.consents.map((item) => item['document']), [
      'TERMS',
      'PRIVACY',
    ]);
    expect(session.current.state, SessionState.needsRole);

    await session.chooseRole(FamilyRole.mother);
    expect(server.me.onboardingRole, 'PARENT_MOTHER');
    expect(session.current.state, SessionState.needsFamily);

    await session.createFamily(name: 'Nhà thử');
    expect(session.current.state, SessionState.waitingPartner);

    final invite = await session.partnerInvite();
    expect(invite?.code, 'K7Q29MX1');
    expect(invite?.link, 'https://babyfamily.vn/i/token');
    // The plain code is cached: reopening ONB-WAIT does not rotate it.
    expect((await session.partnerInvite())?.code, 'K7Q29MX1');
    expect(server.invitesIssued, 1);
    // Turning off final approval before sharing issues a new invite.
    await session.markPartnerInviteSent(requireApproval: false);
    expect(server.invitesIssued, 2);

    expect(await session.checkPartnerStatus(), PartnerJoinStatus.waiting);
    server.inviteStatus = 'AWAITING_APPROVAL';
    expect(
      await session.checkPartnerStatus(),
      PartnerJoinStatus.awaitingApproval,
    );
    expect(session.pendingPartnerCallName, 'Bố');

    expect(
      await session.decidePartner(approve: true),
      PartnerJoinStatus.joined,
    );
    expect(session.current.state, SessionState.activatedSetup);
    // The partner's server id is kept for calendar invites/reminders.
    expect(
      container
          .read(sessionRepositoryProvider)
          .session()[kValueSessionKeyServerPartnerUserId],
      'srv-partner',
    );

    await session.completeSetup();
    expect(server.setupDone, {'srv-family'});
    expect(session.current.state, SessionState.active);

    // App restart: the in-memory mirror is rebuilt from the server.
    final restarted = build();
    expect((await restarted.restore()).state, SessionState.active);
  });

  test(
    'Parent B: preview, accept and wait for the final approval (INV-04)',
    () async {
      final session = build();
      await session.requestOtp('+84987654321');
      await session.verifyOtp('654321');
      await session.saveProfile(name: 'Minh');

      final preview = await session.previewInvite('k7q2 9mxa');
      expect(preview.state, InvitePreviewState.valid);
      expect(preview.invite.familyName, 'Nhà Lan');
      expect(preview.invite.role, FamilyRole.father);

      await session.acceptInvite('K7Q29MXA', callName: 'Bố');
      expect(session.awaitingPartnerApproval, isTrue);
      expect(
        (await session.previewInvite('K7Q29MXA')).state,
        InvitePreviewState.waitingConfirm,
      );
    },
  );

  test('bootstrap subjects are the children list when the app opens', () async {
    auth.saved = const AuthCertificate(
      accessToken: 'access',
      refreshToken: 'refresh',
      expiresIn: 900,
    );
    server
      ..me = server.me.copyWith(
        profileCompleted: true,
        onboardingRole: 'PARENT_MOTHER',
        families: const [
          MeFamily(
            familyId: 'srv-family',
            name: 'Nhà thử',
            status: 'ACTIVE',
            kind: 'MOTHER',
            callName: 'Mama',
          ),
        ],
      )
      ..familyStatus = 'ACTIVE'
      ..setupDone.add('srv-family')
      ..subjects = [
        BootstrapSubject(
          type: 'CHILD',
          id: 'srv-child',
          displayName: 'Hana',
          birthDate: DateTime(2026, 1, 20),
          colorIndex: 2,
          gender: 'FEMALE',
          status: 'ACTIVE',
        ),
        BootstrapSubject(
          type: 'PREGNANCY',
          id: 'srv-pregnancy',
          displayName: 'Bơ',
          dueDate: DateTime(2027, 2, 14),
          expectedCount: 2,
          seqNo: 1,
          status: 'ACTIVE',
        ),
      ];
    final session = build();
    expect((await session.restore()).state, SessionState.active);
    final children = await container.read(childServiceProvider).children();
    expect(children.map((child) => child.id), ['srv-child', 'srv-pregnancy']);
    expect(children.first.name, 'Hana');
    expect(children.first.colorIndex, 1);
    expect(children.first.gender, ChildGender.girl);
    expect(children.last.kind, ChildKind.pregnancy);
    expect(children.last.babyCount, 2);

    // Mất mạng khi mở app: giữ phiên + dữ liệu đã phản chiếu, không đăng xuất.
    server.offline = true;
    expect((await session.restore()).state, SessionState.active);
    // Mở app nguội (kho trên máy dựng lại từ đầu) lúc mất mạng → bản chụp.
    expect(snapshots.saved, isNotNull);
    await container.read(sessionRepositoryProvider).reseed(DemoSeed.fresh);
    expect(session.current.state, isNot(SessionState.active));
    expect((await session.restore()).state, SessionState.active);
    expect(
      (await container.read(childServiceProvider).children()).map((c) => c.id),
      ['srv-child', 'srv-pregnancy'],
    );
    server.offline = false;

    // A rename on the server is applied without duplicating rows.
    server.subjects = [
      server.subjects.first.copyWith(displayName: 'Hana Bé'),
      server.subjects.last,
    ];
    await session.restore();
    final renamed = await container.read(childServiceProvider).children();
    expect(renamed.map((child) => child.name), ['Hana Bé', 'Bơ']);

    // SW-01: Bơ chào đời / lưu trữ trên máy khác → không còn trong bootstrap.
    final both = server.subjects;
    server.subjects = [both.first];
    await session.restore();
    final switcher = await container.read(childServiceProvider).children();
    expect(switcher.map((child) => child.id), ['srv-child']);
    server.subjects = both;
    await session.restore();
    expect(
      (await container.read(childServiceProvider).children()).map((c) => c.id),
      ['srv-child', 'srv-pregnancy'],
    );

    // Ảnh bé và ảnh đại diện của tôi đặt trên máy khác (URL ký của server).
    server.subjects = [
      server.subjects.first.copyWith(
        avatarUrl: 'https://cdn/hana-avatar.webp?sig=1',
        coverUrl: 'https://cdn/hana-cover.webp?sig=1',
      ),
      server.subjects.last,
    ];
    server.me = server.me.copyWith(avatarUrl: 'https://cdn/me.webp?sig=1');
    await session.restore();
    final pictured =
        (await container.read(childServiceProvider).children()).first;
    expect(pictured.avatarAsset, 'https://cdn/hana-avatar.webp?sig=1');
    expect(pictured.coverAsset, 'https://cdn/hana-cover.webp?sig=1');
    expect(
      container
          .read(familyRepositoryProvider)
          .member(session.current.memberId)?['avatarAsset'],
      'https://cdn/me.webp?sig=1',
    );
  });

  test(
    'PARTNER_LEFT keeps the app usable and a new invite revokes the old one',
    () async {
      auth.saved = const AuthCertificate(
        accessToken: 'access',
        refreshToken: 'refresh',
        expiresIn: 900,
      );
      server
        ..me = server.me.copyWith(
          profileCompleted: true,
          onboardingRole: 'PARENT_MOTHER',
          families: const [
            MeFamily(
              familyId: 'srv-family',
              name: 'Nhà thử',
              status: 'PARTNER_LEFT',
              kind: 'MOTHER',
              callName: 'Mama',
            ),
          ],
        )
        ..familyStatus = 'PARTNER_LEFT'
        ..setupDone.add('srv-family');
      final session = build();
      expect((await session.restore()).state, SessionState.active);
      final family = await container
          .read(familyServiceProvider)
          .currentFamily();
      expect(family?.partnerLeftAt, isNotNull);

      final first = await session.partnerInvite();
      final issued = server.invitesIssued;
      await session.revokePartnerInvite();
      expect(server.invitesIssued, issued + 1);
      expect((await session.partnerInvite())?.code, isNotNull);
      expect(first, isNotNull);
    },
  );

  test('invite accepted before sign-in is applied after AUTH-04', () async {
    final session = build();
    await session.acceptInvite('K7Q29MXA', callName: 'Bố');
    expect(session.awaitingPartnerApproval, isFalse);
    await session.requestOtp('+84987654321');
    await session.verifyOtp('654321');
    await session.saveProfile(name: 'Minh');
    expect(session.awaitingPartnerApproval, isTrue);
  });

  test(
    'pending invite applies right after OTP for an account with a profile',
    () async {
      server.me = server.me.copyWith(profileCompleted: true);
      final session = build();
      await session.acceptInvite('K7Q29MXA', callName: 'Bố');
      await session.requestOtp('+84987654321');
      await session.verifyOtp('654321');
      expect(session.awaitingPartnerApproval, isTrue);
    },
  );

  test(
    'server entitlement wins: no local trial when the server says EXPIRED',
    () async {
      server.accessPhase = 'EXPIRED';
      final session = build();
      await session.requestOtp('+84912345678');
      await session.verifyOtp('123456');
      await session.saveProfile(name: 'Lan');
      await session.chooseRole(FamilyRole.mother);
      await session.createFamily(name: 'Nhà thử');
      server.inviteStatus = 'AWAITING_APPROVAL';
      await session.decidePartner(approve: true);
      expect(session.current.state, SessionState.expired);
    },
  );

  test('unknown invite code shows INV-02', () async {
    server.resolveFound = false;
    final session = build();
    expect(() => session.previewInvite('ZZZZZZZZ'), throwsA(isA<StateError>()));
  });

  test('cancelling the waiting family returns to role selection', () async {
    final session = build();
    await session.requestOtp('+84912345678');
    await session.verifyOtp('123456');
    await session.saveProfile(name: 'Lan');
    await session.chooseRole(FamilyRole.mother);
    await session.createFamily(name: 'Nhà thử');
    await session.cancelFamily();
    expect(session.current.familyId, isNull);
    expect(session.current.state, SessionState.needsRole);
  });

  test('sign out clears the server session and the local mirror', () async {
    final session = build();
    await session.requestOtp('+84912345678');
    await session.verifyOtp('123456');
    await session.signOut();
    expect(auth.saved, isNull);
    expect(session.current.state, SessionState.signedOut);
  });

  group('Relative (BF-20261019-005)', () {
    late _FakeOnboardingRepository onboarding;

    Future<SessionRemoteServiceImp> signedInRelative() async {
      container = ProviderContainer(
        overrides: mockOverrides(seed: DemoSeed.fresh),
      );
      addTearDown(container.dispose);
      onboarding = _FakeOnboardingRepository(server);
      final session = SessionRemoteServiceImp(
        container.read(sessionServiceProvider) as SessionServiceImp,
        auth,
        _FakeAuthRepository(server),
        onboarding,
        container.read(childRepositoryProvider),
      );
      await session.requestOtp('+84912345678');
      await session.verifyOtp('123456');
      await session.saveProfile(name: 'Bà Nội');
      await session.chooseRole(FamilyRole.relative);
      return session;
    }

    const kid = CircleSubjectRecord(
      id: 'srv-kid',
      name: 'Hana',
      kind: 'CHILD',
      permission: 'CONTRIBUTE',
    );

    JsonMap? me(SessionRemoteServiceImp session) => container
        .read(familyRepositoryProvider)
        .member(session.current.memberId);

    test('CIRCLE invite → waiting → active → paused → removed', () async {
      final session = await signedInRelative();
      expect(session.current.state, SessionState.circleWaiting);

      server.circleInvite = const InviteResolution(
        inviteId: 'inv-c',
        type: 'CIRCLE',
        state: 'VALID',
        familyName: 'Nhà Lan',
        inviterCallName: 'Mama',
        relation: 'GRANDMOTHER_PATERNAL',
        children: [kid],
      );
      final preview = await session.previewInvite('CIRC1234');
      expect(preview.invite.kind, InviteKind.relative);
      expect(preview.invite.relation, RelativeRelation.grandmaPaternal);
      expect(preview.children.map((child) => child.name), ['Hana']);
      expect(preview.state, InvitePreviewState.valid);

      // Bố/Mẹ chưa xác nhận lần cuối → vẫn CIR-WAIT.
      server.circles = const [
        MyCircleRecord(familyId: 'srv-fam', status: 'AWAITING_APPROVAL'),
      ];
      await session.acceptInvite('CIRC1234');
      expect(session.current.state, SessionState.circleWaiting);

      server.circles = const [
        MyCircleRecord(
          familyId: 'srv-fam',
          familyName: 'Nhà Lan',
          status: 'ACTIVE',
          children: [kid],
          allowDownload: true,
        ),
      ];
      await session.restore();
      expect(session.current.state, SessionState.circleActive);
      expect(me(session)?['grantedChildIds'], ['srv-kid']);
      expect(me(session)?['canPost'], isTrue);
      expect(me(session)?['canComment'], isTrue);
      expect(me(session)?['allowDownload'], isTrue);
      expect(
        container.read(childRepositoryProvider).child('srv-kid')?['name'],
        'Hana',
      );
      expect(
        container
            .read(sessionRepositoryProvider)
            .session()[kValueSessionKeyServerFamilyId],
        'srv-fam',
      );

      // CIR-05: gói hết hạn — server không trả bé, quyền cũ giữ nguyên.
      server.circles = const [
        MyCircleRecord(
          familyId: 'srv-fam',
          familyName: 'Nhà Lan',
          status: 'PAUSED',
        ),
      ];
      await session.restore();
      expect(session.current.state, SessionState.circlePaused);
      expect(me(session)?['grantedChildIds'], ['srv-kid']);

      // Bị gỡ khỏi gia đình → về CIR-WAIT.
      server.circles = const [];
      await session.restore();
      expect(session.current.state, SessionState.circleWaiting);
      expect(session.current.memberId, isNull);
    });

    test(
      'Circle app reads the server feed, posts for review, leaves',
      () async {
        final session = await signedInRelative();
        server.circles = const [
          MyCircleRecord(
            familyId: 'srv-fam',
            familyName: 'Nhà Lan',
            status: 'ACTIVE',
            children: [kid],
          ),
        ];
        await session.restore();
        final store = container.read(memoryRepositoryProvider);
        final localFamilyId = session.current.familyId!;
        for (final (id, status) in [
          ('m-ready', 'READY'),
          ('m-pending', 'PENDING_REVIEW'),
        ]) {
          store.addMemory({
            'id': id,
            'familyId': localFamilyId,
            'kind': MemoryKind.photo.name,
            'childIds': ['srv-kid'],
            'authorId': 'someone',
            'visibility': MemoryVisibility.family.name,
            'occurredAt': DateTime(2026, 10, 18).toIso8601String(),
            'createdAt': DateTime(2026, 10, 18).toIso8601String(),
            'remoteStatus': status,
          });
        }
        final memories = _FakeMemoryService();
        final circle = CircleRemoteServiceImp(
          container.read(sessionRepositoryProvider),
          container.read(appClockProvider),
          container.read(familyRepositoryProvider),
          container.read(childRepositoryProvider),
          store,
          container.read(notificationRepositoryProvider),
          memories,
          onboarding,
          session,
        );

        final view = await circle.view();
        expect(memories.calls, contains('memories'));
        expect(view?.children.map((child) => child.id), ['srv-kid']);
        // Ảnh đang chờ Bố/Mẹ duyệt chưa hiện cho cả nhà.
        expect(view?.memories.map((memory) => memory.id), ['m-ready']);

        await circle.toggleHeart('m-ready');
        expect(memories.calls, contains('react:m-ready:$kValueHeartReaction'));

        await circle.submitPost(
          const CirclePostDraft(
            mediaAssets: ['/tmp/a.jpg'],
            childIds: ['srv-kid'],
            message: ' Bà gửi ảnh ',
          ),
        );
        expect(memories.created.single, {
          'kind': MemoryKind.photo.name,
          'childIds': ['srv-kid'],
          'body': 'Bà gửi ảnh',
          'mediaAssets': ['/tmp/a.jpg'],
          'visibility': MemoryVisibility.family.name,
        });

        await circle.leaveFamily();
        expect(server.left, ['srv-fam']);
        expect(session.current.state, SessionState.circleWaiting);
        expect(
          container
              .read(sessionRepositoryProvider)
              .session()[kValueSessionKeyServerFamilyId],
          isNull,
        );
      },
    );
  });
}
