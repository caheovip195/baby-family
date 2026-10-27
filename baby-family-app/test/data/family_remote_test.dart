import 'package:baby_family/data/model/billing/billing_plan_record.dart';
import 'package:baby_family/data/model/billing/family_billing_record.dart';
import 'package:baby_family/data/model/billing/family_billing_usage.dart';
import 'package:baby_family/data/model/circle/circle_grant_record.dart';
import 'package:baby_family/data/model/circle/circle_invite_issued.dart';
import 'package:baby_family/data/model/circle/circle_invite_record.dart';
import 'package:baby_family/data/model/circle/circle_member_record.dart';
import 'package:baby_family/data/model/family/family_record.dart';
import 'package:baby_family/data/model/family/family_settings_record.dart';
import 'package:baby_family/data/model/family/my_family_record.dart';
import 'package:baby_family/data/model/family/purchase_intent_record.dart';
import 'package:baby_family/data/model/family/timezone_catalog.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/family_remote.dart';
import 'package:baby_family/data/repository/store_purchase.dart';
import 'package:baby_family/data/service_imp/family_remote.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

/// API gia đình giả (BF-20261018-015).
class _FakeFamily implements IFamilyRemoteRepository {
  FamilySettingsRecord record = const FamilySettingsRecord(
    showLunar: false,
    circleCanSeeTree: false,
    defaultVisibility: 'PARENTS',
    requireCircleReview: true,
    traditionalUseLunar: false,
    milestoneSuggestions: true,
  );
  final patches = <JsonMap>[];
  final names = <String>[];

  @override
  Future<FamilySettingsRecord?> settings(String familyId) async => record;

  @override
  Future<FamilySettingsRecord?> updateSettings(
    String familyId,
    JsonMap patch,
  ) async {
    patches.add(patch);
    return record;
  }

  @override
  Future<void> updateFamily(String familyId, {String? name}) async =>
      names.add(name ?? '');

  FamilyRecord familyRecord = const FamilyRecord(
    contentLocale: 'en',
    coverUrl: 'https://cdn/cover.webp',
  );
  final familyPatches = <JsonMap>[];

  @override
  Future<FamilyRecord?> family(String familyId) async => familyRecord;

  @override
  Future<void> patchFamily(String familyId, JsonMap patch) async =>
      familyPatches.add(patch);

  final defaults = <String>[];

  @override
  Future<List<MyFamilyRecord>> myFamilies() async => const [
    MyFamilyRecord(familyId: 'srv-family', name: 'Nhà mình', role: 'PARENT'),
    MyFamilyRecord(familyId: 'srv-grand', name: 'Nhà ông bà', role: 'CIRCLE'),
  ];

  @override
  Future<void> setDefaultFamily(String familyId) async =>
      defaults.add(familyId);

  @override
  Future<TimezoneCatalog?> timezones(String locale) async =>
      const TimezoneCatalog(
        version: '1',
        items: [
          TimezoneOption(
            id: 'Asia/Ho_Chi_Minh',
            label: 'Hà Nội, TP.HCM',
            offsetMinutes: 420,
          ),
          TimezoneOption(id: 'Asia/Tokyo', label: 'Tokyo', offsetMinutes: 540),
        ],
      );
  final circleCalls = <String>[];
  List<CircleMemberRecord> members = const [];
  List<CircleInviteRecord> invites = const [];

  @override
  Future<CircleInviteIssued?> createCircleInvite(
    String familyId,
    JsonMap body,
  ) async {
    circleCalls.add('invite:$body');
    return CircleInviteIssued(
      inviteId: 'inv-1',
      code: 'BN123456',
      url: 'https://babyfamily.vn/i/x',
      expiresAt: DateTime.utc(2026, 11),
    );
  }

  @override
  Future<List<CircleInviteRecord>> circleInvites(String familyId) async =>
      invites;

  @override
  Future<CircleInviteIssued?> circleInviteAction(
    String inviteId,
    String action,
  ) async {
    circleCalls.add('$action:$inviteId');
    return const CircleInviteIssued(inviteId: 'inv-1', code: 'BN654321');
  }

  @override
  Future<List<CircleMemberRecord>> circle(String familyId) async => members;

  @override
  Future<void> updateCircleMember(String memberId, JsonMap patch) async =>
      circleCalls.add('patch:$memberId:$patch');

  @override
  Future<void> circleMemberAction(String memberId, String action) async =>
      circleCalls.add('$action:$memberId');

  @override
  Future<void> removeCircleMember(String memberId) async =>
      circleCalls.add('remove:$memberId');

  FamilyBillingRecord billing = const FamilyBillingRecord(accessPhase: 'TRIAL');
  int billingReads = 0;
  bool offlinePlans = false;
  bool emptyPlans = false;

  @override
  Future<List<BillingPlanRecord>> billingPlans() async {
    if (offlinePlans) {
      throw DioException(
        requestOptions: RequestOptions(path: '/billing/plans'),
      );
    }
    if (emptyPlans) {
      return const [];
    }
    return const [
      BillingPlanRecord(code: 'TRIAL', quotas: {'storageBytes': 10737418240}),
      BillingPlanRecord(
        code: 'FAMILY',
        displayOrder: 200,
        quotas: {
          'storageBytes': 214748364800,
          'circleMax': 12,
          'photosPerMemory': 50,
          'videoMaxSec': 600,
          'audioMaxSec': 600,
          'aiPerMonth': 300,
        },
        features: {'circle.enabled': true, 'media.keepOriginal': true},
      ),
      BillingPlanRecord(
        code: 'HOUSE',
        displayOrder: 100,
        quotas: {'storageBytes': 53687091200, 'circleMax': 0},
        features: {'circle.enabled': false},
      ),
    ];
  }

  @override
  Future<FamilyBillingRecord?> familyBilling(String familyId) async {
    billingReads++;
    return billing;
  }

  final purchaseCalls = <String>[];

  @override
  Future<PurchaseIntentRecord?> purchaseIntent(
    String familyId,
    String idempotencyKey, {
    required String planCode,
    required String store,
  }) async {
    purchaseCalls.add('intent $planCode $store');
    return const PurchaseIntentRecord(
      intentId: 'intent-1',
      productId: 'vn.babyfamily.family.yearly',
      appAccountToken: 'acct-1',
    );
  }

  @override
  Future<FamilyBillingRecord?> verifyPurchase(
    String familyId,
    JsonMap body,
  ) async {
    purchaseCalls.add(
      'verify ${body['intentId']} ${body['signedTransaction']}',
    );
    billing = const FamilyBillingRecord(
      accessPhase: 'PAID',
      plan: BillingPlanRecord(code: 'FAMILY'),
    );
    return billing;
  }
}

class _FakeStore implements IStorePurchaseRepository {
  _FakeStore(this.calls, {this.cancel = false});

  final List<String> calls;
  final bool cancel;

  @override
  String? get store => 'APP_STORE';

  @override
  Future<StorePurchase> buy({
    required String productId,
    required String accountToken,
  }) async {
    calls.add('buy $productId $accountToken');
    if (cancel) {
      throw const StorePurchaseCancelled();
    }
    return StorePurchase(
      store: 'APP_STORE',
      productId: productId,
      credential: 'jws-1',
    );
  }

  @override
  Future<void> complete(StorePurchase purchase) async =>
      calls.add('complete ${purchase.productId}');
}

class _FakeUploader extends Fake implements MediaUploader {
  _FakeUploader(this.calls);

  final List<String> calls;

  @override
  Future<String> uploadImage(
    String serverFamilyId,
    String path, {
    required String purpose,
  }) async {
    calls.add('$purpose:$path');
    return 'asset-cover';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakeFamily remote;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    remote = _FakeFamily();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({kValueSessionKeyServerFamilyId: 'srv-family'});
  });

  FamilyRemoteServiceImp service() => FamilyRemoteServiceImp(
    container.read(sessionRepositoryProvider),
    container.read(appClockProvider),
    container.read(familyRepositoryProvider),
    remote,
    container.read(childRepositoryProvider),
  );

  test(
    'BF-20261023-001: stale member id cannot resolve another family fixture',
    () async {
      final session = container.read(sessionRepositoryProvider);
      final fixtureId = session.session()['memberId'] as String;
      expect(
        container.read(familyRepositoryProvider).member(fixtureId),
        isNotNull,
      );
      session.patchSession({'familyId': 'server-family-mirror'});
      expect(await service().member(fixtureId), isNull);
    },
  );

  test(
    'BF-20261023-001: billing catalog never falls back to fixture offers',
    () async {
      final family = service();
      final offers = await family.planOffers();
      // Giá hiển thị theo catalog giá của app (ONB-ACT “House (…)”).
      expect(offers.every((offer) => offer.priceText.isNotEmpty), isTrue);
      remote.emptyPlans = true;
      expect(await family.planOffers(), isEmpty);
      remote.offlinePlans = true;
      expect(await family.planOffers(), isEmpty);
    },
  );

  test(
    'BF-20261023-001: settings summary hides unknown quota and app lock',
    () async {
      final summary = await service().settingsSummary();
      expect(summary.aiRemaining, isNull);
      expect(summary.aiTotal, isNull);
      expect(summary.appLockName, isNull);
    },
  );

  test(
    'BF-20261023-001: plan details exclude fixture payer and usage',
    () async {
      final details = await service().planDetails();
      expect(details, isNotNull);
      expect(details!.payerUserId, isNull);
      expect(details.channel, isEmpty);
      expect(details.storage, isEmpty);
      expect((details.aiRemaining, details.aiTotal), (0, 0));
      expect(details.aiRenewsAt, isNull);
      expect((details.videoMaxMinutes, details.photosPerMemory), (0, 0));
    },
  );

  test(
    'BF-20261023-001: absent family timezone has no fixture label',
    () async {
      expect((await service().familySettings()).timezoneLabel, isEmpty);
    },
  );

  test(
    'FAM-08: my families come from the server; switching saves it',
    () async {
      final family = service();
      final memberships = await family.memberships();
      expect(memberships.map((m) => m.familyId), ['srv-family', 'srv-grand']);
      expect(memberships.first.current, isTrue);
      expect(memberships.last.role, FamilyRole.relative);
      await family.switchFamily('srv-grand');
      expect(remote.defaults, ['srv-grand']);
    },
  );

  test('FAM-07: time zone from the catalog; a new pick is patched', () async {
    remote.familyRecord = remote.familyRecord.copyWith(
      timezone: 'Asia/Ho_Chi_Minh',
    );
    final family = service();
    final options = await family.timezones();
    final settings = await family.familySettings();
    expect(settings.timezoneId, 'Asia/Ho_Chi_Minh');
    expect(settings.timezoneLabel, 'Hà Nội, TP.HCM');
    await family.saveFamilySettings(
      settings.copyWith(
        timezoneId: options.last.id,
        timezoneLabel: options.last.label,
      ),
    );
    expect(remote.familyPatches.single, {'timezone': 'Asia/Tokyo'});
  });

  test(
    'SUB-01/02: buy via the Store; the server verifies before the plan changes',
    () async {
      final family = FamilyRemoteServiceImp(
        container.read(sessionRepositoryProvider),
        container.read(appClockProvider),
        container.read(familyRepositoryProvider),
        remote,
        container.read(childRepositoryProvider),
        null,
        _FakeStore(remote.purchaseCalls),
      );
      await family.purchasePlan(PlanState.family);
      expect(remote.purchaseCalls, [
        'intent FAMILY APP_STORE',
        'buy vn.babyfamily.family.yearly acct-1',
        'verify intent-1 jws-1',
        'complete vn.babyfamily.family.yearly',
      ]);
      expect((await family.currentFamily())?.plan.state, PlanState.family);
    },
  );

  test(
    'SUB-02: cancelling at the Store changes nothing on the server',
    () async {
      final family = FamilyRemoteServiceImp(
        container.read(sessionRepositoryProvider),
        container.read(appClockProvider),
        container.read(familyRepositoryProvider),
        remote,
        container.read(childRepositoryProvider),
        null,
        _FakeStore(remote.purchaseCalls, cancel: true),
      );
      await expectLater(
        family.purchasePlan(PlanState.family),
        throwsA(isA<StorePurchaseCancelled>()),
      );
      expect(
        remote.purchaseCalls.where((c) => c.startsWith('verify')),
        isEmpty,
      );
    },
  );

  test('SUB-01/04: plan quotas come from the server catalog', () async {
    final offers = await service().planOffers();
    expect(offers.map((offer) => offer.code), [
      PlanState.house,
      PlanState.family,
    ]);
    final family = offers.last;
    expect(family.storageGb, 200);
    expect(family.relativeSlots, 12);
    expect(family.videoMinutes, 10);
    expect(family.aiPerMonth, 300);
    expect(family.originalQuality, isTrue);
    expect(family.digestAndReview, isTrue);
    // Giá hiển thị lấy từ catalog giá của app.
    expect(family.priceText, isNotEmpty);
  });

  test('SUB-03/06/07: the family plan mirrors /billing', () async {
    remote.billing = FamilyBillingRecord(
      accessPhase: 'PAID',
      plan: const BillingPlanRecord(
        code: 'FAMILY',
        quotas: {'storageBytes': 214748364800, 'circleMax': 12},
      ),
      validUntil: DateTime.utc(2027, 10, 19),
      inGrace: true,
      usage: const FamilyBillingUsage(storageBytes: '1073741824'),
    );
    final family = service();
    final details = await family.planDetails();
    expect(details?.plan.state, PlanState.family);
    expect(details?.plan.storageQuotaMb, 204800);
    expect(details?.plan.storageUsedMb, 1024);
    expect(details?.plan.relativeSlotsMax, 12);
    expect(details?.plan.paymentIssue, isTrue);
    expect(details?.plan.endsAt?.toUtc(), DateTime.utc(2027, 10, 19));

    remote.billing = const FamilyBillingRecord(accessPhase: 'EXPIRED');
    final reads = remote.billingReads;
    // Đọc lại trong khoảng làm mới: không hỏi lại server.
    await family.currentFamily();
    expect(remote.billingReads, reads);
    expect((await family.planDetails())?.plan.state, PlanState.expired);
  });

  test(
    'FAM-07: cover and content language come from and go to the server',
    () async {
      final uploads = <String>[];
      final family = FamilyRemoteServiceImp(
        container.read(sessionRepositoryProvider),
        container.read(appClockProvider),
        container.read(familyRepositoryProvider),
        remote,
        container.read(childRepositoryProvider),
        _FakeUploader(uploads),
      );
      final settings = await family.familySettings();
      expect(settings.coverAsset, 'https://cdn/cover.webp');
      expect(settings.contentLanguage, 'en');
      await family.saveFamilySettings(
        settings.copyWith(coverAsset: '/tmp/cover.jpg', contentLanguage: 'vi'),
      );
      expect(uploads, ['COVER:/tmp/cover.jpg']);
      expect(remote.familyPatches.single, {
        'contentLocale': 'vi',
        'coverAssetId': 'asset-cover',
      });
    },
  );

  test('ONB-08: privacy defaults come from the server', () async {
    final settings = await service().familySettings();
    expect(settings.defaultVisibility, MemoryVisibility.parents);
    expect(settings.showLunar, isFalse);
    expect(settings.relativesSeeTree, isFalse);
    expect(settings.approveRelativePhotos, isTrue);
    expect(settings.milestonesByLunar, isFalse);
  });

  test(
    'FAM-07: only changed keys are sent; the name uses PATCH /families',
    () async {
      final family = service();
      final settings = await family.familySettings();
      await family.saveFamilySettings(
        settings.copyWith(
          defaultVisibility: MemoryVisibility.onlyMe,
          relativesSeeTree: true,
          name: 'Nhà Mới',
        ),
      );
      expect(remote.patches.single, {
        'circleCanSeeTree': true,
        'defaultVisibility': 'PRIVATE',
      });
      expect(remote.familyPatches.single, {'name': 'Nhà Mới'});

      // Nothing changed → no request.
      await family.saveFamilySettings(await family.familySettings());
      expect(remote.patches, hasLength(1));
    },
  );

  test(
    'FAM-03/05: a relative invite is created and renewed on the server',
    () async {
      final family = service();
      final session = container.read(sessionRepositoryProvider);
      final childId =
          container
                  .read(childRepositoryProvider)
                  .children(session.session()['familyId'] as String)
                  .firstWhere((row) => row['kind'] == ChildKind.baby.name)['id']
              as String;
      final invite = await family.createRelativeInvite(
        relation: RelativeRelation.grandmaMaternal,
        callName: 'Bà ngoại',
        childIds: [childId],
      );
      expect(invite.id, 'inv-1');
      expect(invite.code, 'BN123456');
      expect(remote.circleCalls.single, contains('GRANDMOTHER_MATERNAL'));
      expect(remote.circleCalls.single, contains('COMMENT'));

      remote.invites = [
        CircleInviteRecord(
          inviteId: 'inv-1',
          status: 'EXPIRED',
          displayName: 'Bà ngoại',
          relation: 'GRANDMOTHER_MATERNAL',
        ),
      ];
      final listed = await family.relativeInvites();
      final mine = listed.firstWhere((item) => item.id == 'inv-1');
      expect(mine.status, 'expired');
      expect(mine.code, 'BN123456');
      await family.renewInvite('inv-1');
      expect(remote.circleCalls.last, 'renew:inv-1');
      expect(
        (await family.relativeInvites())
            .firstWhere((item) => item.id == 'inv-1')
            .code,
        'BN654321',
      );
    },
  );

  test('FAM-04/06: relatives come from the server; edits go back', () async {
    final family = service();
    final session = container.read(sessionRepositoryProvider);
    final childId =
        container
                .read(childRepositoryProvider)
                .children(session.session()['familyId'] as String)
                .firstWhere((row) => row['kind'] == ChildKind.baby.name)['id']
            as String;
    remote.members = [
      CircleMemberRecord(
        id: 'cm-1',
        userId: 'srv-grandma',
        displayName: 'Bà nội',
        relation: 'GRANDMOTHER_PATERNAL',
        status: 'ACTIVE',
        grants: [CircleGrantRecord(childId: childId, permission: 'VIEW')],
      ),
    ];
    final relative = (await family.members()).firstWhere(
      (member) => member.id == 'cm-1',
    );
    expect(relative.relation, RelativeRelation.grandmaPaternal);
    expect(relative.grantedChildIds, [childId]);

    await family.setChildPermission(
      'cm-1',
      childId,
      RelativePermission.contribute,
    );
    expect(remote.circleCalls.last, contains('CONTRIBUTE'));
    await family.updateRelative('cm-1', paused: true, allowDownload: true);
    expect(remote.circleCalls.sublist(remote.circleCalls.length - 2), [
      'patch:cm-1:{allowDownload: true}',
      'pause:cm-1',
    ]);
    await family.removeRelative('cm-1');
    expect(remote.circleCalls.last, 'remove:cm-1');

    // Gone on the server → removed on this device too.
    remote.members = const [];
    final after = await family.members();
    expect(after.where((member) => member.id == 'cm-1'), isEmpty);
  });
}
