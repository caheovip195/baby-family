import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/circle.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/notification.dart';
import 'package:baby_family/data/provider/pregnancy.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

ProviderContainer _container({
  DemoSeed seed = DemoSeed.active,
  String actor = 'mama',
}) {
  final container = ProviderContainer(
    overrides: mockOverrides(seed: seed, actor: actor),
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('trial policy (BF-20261013-005)', () {
    test('catalog trial policy is 7 days', () async {
      final c = _container(seed: DemoSeed.fresh);
      expect(
        await c.read(familyServiceProvider).trialDuration(),
        const Duration(days: 7),
      );
    });

    test('trial seed ends 7 days after mock now (14/10/2026)', () async {
      final c = _container(seed: DemoSeed.trial);
      final plan = (await c.read(familyServiceProvider).currentFamily())!.plan;
      expect(plan.state, PlanState.trial);
      expect(plan.endsAt!.difference(plan.startedAt!), const Duration(days: 7));
      expect(
        DateTime(plan.endsAt!.year, plan.endsAt!.month, plan.endsAt!.day),
        DateTime(2026, 10, 14),
      );
    });
  });

  group('design story data (active seed, Mama Lan)', () {
    test('family, plan and children match FAM-01 / SW-01', () async {
      final c = _container();
      final family = await c.read(familyServiceProvider).currentFamily();
      expect(family!.name, 'Nhà Lan');
      expect(family.plan.state, PlanState.family);
      expect(family.plan.storageQuotaMb, 204800);
      expect(family.plan.endsAt, DateTime(2026, 12, 8, 23, 59));
      expect(family.plan.storageUsedMb, 3277);
      final members = await c.read(familyServiceProvider).members();
      // Trial has no relatives (C-07).
      // Story v2: Family plan with relatives.
      expect(
        members.map((m) => m.callName),
        containsAll(['Mama', 'Papa', 'Bà nội', 'Bà ngoại', 'Ông ngoại']),
      );
      final partner = await c.read(familyServiceProvider).partner();
      expect(partner!.displayName, 'Minh');
      final children = await c.read(childServiceProvider).children();
      expect(children.map((child) => child.name), ['Hana', 'Haru', 'Bơ']);
      expect(children.last.isPregnancy, isTrue);
    });

    test(
      'care board: 4/8, my Hearts 5, partner Hearts hidden (BR-018)',
      () async {
        final c = _container();
        final board = await c.read(careServiceProvider).board();
        expect(board.mine.map((m) => m.title), [
          'Đọc sách tranh 10 phút',
          'Tắm cho Haru buổi tối',
          'Rửa và tiệt trùng bình sữa',
          'Hát cho Haru nghe một bài',
        ]);
        expect(board.partner, hasLength(3));
        expect(board.together, hasLength(1));
        expect((board.doneCount, board.totalCount), (4, 8));
        expect(board.heartsToday, 5);
        expect(board.partner.every((m) => m.hearts == null), isTrue);
        expect(board.swapsLeft, 2);
      },
    );

    test(
      'hearts and family tree (CARE-09: 5 / 86 / 742, level 4, 97%)',
      () async {
        final c = _container();
        final hearts = await c.read(careServiceProvider).myHearts();
        expect((hearts.today, hearts.week, hearts.total), (5, 86, 742));
        final tree = await c.read(careServiceProvider).tree();
        expect(
          (tree.level, tree.name, tree.progressPercent),
          (4, 'Cây xanh', 97),
        );
        expect(tree.nextName, 'Cây trổ hoa');
        expect((tree.todayLeaves, tree.todayTotal), (4, 8));
      },
    );

    test('swap options keep Hearts ±1 and count swaps (CARE-05)', () async {
      final c = _container();
      final care = c.read(careServiceProvider);
      final swap = await care.swapOptions('ms-read');
      expect(swap.options.map((o) => o.title), [
        'Hát cho Hana một bài',
        'Đi dạo cùng Hana 20 phút',
        'Quay video Hana đang cười',
      ]);
      expect(swap.options.every((o) => (o.hearts - 5).abs() <= 1), isTrue);
      await care.swapMission('ms-read', swap.options.first.id);
      final board = await care.board();
      expect(board.mine.first.title, 'Hát cho Hana một bài');
      expect(board.swapsLeft, 1);
    });

    test('missions: only ME/TOGETHER (BR-020), complete + undo', () async {
      final c = _container();
      final care = c.read(careServiceProvider);
      expect(
        () =>
            care.createMission(title: 'x', ownerKind: MissionOwnerKind.partner),
        throwsArgumentError,
      );
      final custom = await care.createMission(title: 'Gấp quần áo');
      expect(custom.hearts, 2);
      final done = await care.completeMission('ms-read');
      expect(done.heartsEarned, 5);
      expect((await care.myHearts()).today, 10);
      expect(() => care.completeMission('ms-tummy'), throwsStateError);
      await care.undoCompletion('ms-read');
      expect((await care.myHearts()).today, 5);
    });

    test(
      'memories: both tell, perspective once per parent, monthly photo',
      () async {
        final c = _container();
        final memory = c.read(memoryServiceProvider);
        final feed = await memory.memories(childId: 'haru');
        final first = feed.firstWhere((m) => m.id == 'm-hana-holds-haru');
        expect(first.bothTell, isTrue);
        expect(first.commentCount, 6);
        expect(first.reactionTotal, 5);
        await memory.savePerspective('m-keepsake-bracelet', body: 'A');
        await memory.savePerspective('m-keepsake-bracelet', body: 'B');
        final perspectives = await memory.perspectives('m-keepsake-bracelet');
        expect(perspectives.single.body, 'B');
        await memory.saveMonthlyPhoto('haru', asset: 'a.jpg', monthIndex: 5);
        final monthly = await memory.monthlyPhotos('haru');
        expect(monthly.where((p) => p.monthIndex == 5).single.asset, 'a.jpg');
        expect(monthly, hasLength(17));
      },
    );

    test('stats, chapters, prompt (BR-073) and stories', () async {
      final c = _container();
      final stats = await c.read(childServiceProvider).stats('haru');
      expect((stats.memories, stats.firsts, stats.voices), (186, 6, 9));
      final chapters = await c.read(childServiceProvider).chapters('haru');
      expect(chapters.first.monthIndex, 18);
      expect(chapters.first.memoryCount, 31);
      expect(chapters[1].hasMonthlyPhoto, isTrue);
      final memory = c.read(memoryServiceProvider);
      final prompt = await memory.todayPrompt();
      expect(prompt!.text, 'Câu nào của Hana hôm nay làm bạn bật cười?');
      await memory.dismissPrompt();
      expect(await memory.todayPrompt(), isNull);
      final stories = await memory.stories();
      expect(stories.where((s) => s.childId == 'hana'), hasLength(5));
      expect(
        stories.where((s) => !s.seen && s.childId == 'hana'),
        hasLength(3),
      );
      final week = await c.read(childServiceProvider).weekSummary();
      expect((week.moments, week.firsts, week.quotes), (24, 2, 1));
    });

    test('couple: check-ins, open request, request limit (BR-067)', () async {
      final c = _container();
      final us = c.read(usServiceProvider);
      final today = await us.coupleToday();
      expect(today.partnerCheckin!.mood, MoodCode.tired);
      expect(today.partnerCheckin!.needMinutes, 20);
      expect(
        today.openRequests.single.title,
        'Cần nghỉ 30 phút — trông Haru giúp',
      );
      expect(today.question!.text, 'Điều nhỏ nào hôm nay làm bạn mỉm cười?');
      for (var i = 0; i < 4; i++) {
        await us.sendRequest(title: 'Việc $i');
      }
      expect(() => us.sendRequest(title: 'Việc 5'), throwsStateError);
    });

    test('pregnancy: prep 12/30, names, birth conversion', () async {
      final c = _container();
      final pregnancy = c.read(pregnancyServiceProvider);
      final prep = await pregnancy.prep('bo');
      expect((prep.done, prep.total), (12, 30));
      final names = await pregnancy.names('bo');
      expect(names.map((n) => n.name), [
        'An Nhiên',
        'Bảo Châu',
        'Minh Anh',
        'Khánh Linh',
      ]);
      expect(names.first.bothLike, isTrue);
      final baby = await pregnancy.convertToBaby(
        'bo',
        name: 'An Nhiên',
        birthDate: DateTime(2027, 1, 20),
      );
      expect(baby.isPregnancy, isFalse);
    });

    test('notifications (NOTI-01) and actor switch to Papa', () async {
      final c = _container();
      final items = await c.read(notificationServiceProvider).notifications();
      expect(items.first.text, 'Mama đang cần một chút hỗ trợ. Xem nhé?');
      expect(items, hasLength(5));
      final papa = _container(actor: 'papa');
      final board = await papa.read(careServiceProvider).board();
      expect(board.mine, hasLength(3));
      expect(board.partner.map((m) => m.title).first, 'Đọc sách tranh 10 phút');
    });
  });

  group('session flows (pass-through, BR-050…056)', () {
    test(
      'fresh → sign in → role → family → waiting → activated → active',
      () async {
        final c = _container(seed: DemoSeed.fresh);
        final session = c.read(sessionServiceProvider);
        expect((await session.restore()).state, SessionState.signedOut);
        await session.signIn(AuthMethod.apple);
        expect(session.current.state, SessionState.needsProfile);
        await session.saveProfile(name: 'Thu');
        expect(session.current.state, SessionState.needsRole);
        await session.chooseRole(FamilyRole.mother);
        expect(session.current.state, SessionState.needsFamily);
        await session.createFamily(name: 'Nhà Thu');
        expect(session.current.state, SessionState.waitingPartner);
        expect((await session.partnerInvite())!.kind, InviteKind.partner);
        await session.simulatePartnerJoined();
        expect(session.current.state, SessionState.activatedSetup);
        final plan =
            (await c.read(familyServiceProvider).currentFamily())!.plan;
        expect(
          plan.endsAt!.difference(plan.startedAt!),
          const Duration(seconds: 604800),
        );
        await c.read(childServiceProvider).addChild(name: 'Bin');
        await session.completeSetup();
        expect(session.current.state, SessionState.active);
      },
    );

    test('partner invite before sign-in joins as Papa', () async {
      final c = _container(seed: DemoSeed.fresh);
      final session = c.read(sessionServiceProvider);
      final preview = await session.previewInvite('anything');
      expect(preview.invite.kind, InviteKind.partner);
      expect(preview.invite.inviterName, 'Lan');
      await session.acceptInvite('K7Q29MXA');
      expect(session.current.pendingInvite, isNotNull);
      await session.verifyOtp('000000');
      await session.saveProfile(name: 'Minh');
      expect(session.current.state, SessionState.activatedSetup);
      expect(session.current.role, FamilyRole.father);
    });

    test('relative invite → circle home with Hana and Haru', () async {
      // Story v2: Bà nội follows Hana and Haru; the archived duplicate Haru
      // (CHD-03) is never listed as hidden.
      final c = _container(seed: DemoSeed.fresh);
      final session = c.read(sessionServiceProvider);
      final preview = await session.previewInvite('B4N0I123');
      expect(preview.invite.callName, 'Bà nội');
      expect(preview.children.map((child) => child.name), ['Hana', 'Haru']);
      expect(preview.hiddenChildren, isEmpty);
      await session.acceptInvite('B4N0I123');
      await session.signIn(AuthMethod.google);
      await session.saveProfile(name: 'Bà nội');
      expect(session.current.state, SessionState.circleActive);
      final view = await c.read(circleServiceProvider).view();
      expect(view!.children.map((child) => child.name), ['Hana', 'Haru']);
      expect(
        view.memories.every(
          (memory) => memory.childIds.every(
            (id) => const {'hana', 'haru'}.contains(id),
          ),
        ),
        isTrue,
      );
    });

    test('relative role without invite waits (CIR-WAIT)', () async {
      final c = _container(seed: DemoSeed.fresh);
      final session = c.read(sessionServiceProvider);
      await session.signIn(AuthMethod.apple);
      await session.saveProfile(name: 'Ông');
      await session.chooseRole(FamilyRole.relative);
      expect(session.current.state, SessionState.circleWaiting);
    });

    test('seeds: circle, pregnant and expired', () async {
      final circle = _container(seed: DemoSeed.circle);
      expect(
        (await circle.read(sessionServiceProvider).restore()).state,
        SessionState.circleActive,
      );
      final view = await circle.read(circleServiceProvider).view();
      expect(view!.viewer.callName, 'Bà ngoại');
      expect(view.children.map((child) => child.name), ['Hana', 'Haru', 'Bơ']);
      expect(view.memories.any((m) => m.childIds.contains('bo')), isTrue);

      final pregnant = _container(seed: DemoSeed.pregnant);
      await pregnant.read(sessionServiceProvider).restore();
      final children = await pregnant.read(childServiceProvider).children();
      expect(children.single.name, 'Bơ');

      final expired = _container(seed: DemoSeed.expired);
      expect(
        (await expired.read(sessionServiceProvider).restore()).state,
        SessionState.expired,
      );
      await expired.read(familyServiceProvider).purchasePlan(PlanState.family);
      expect(
        expired.read(sessionServiceProvider).current.state,
        SessionState.active,
      );
    });
  });

  group('batch 2 data (33 Pencil frames)', () {
    test('albums, comments thread, milestone picker', () async {
      final c = _container();
      final memory = c.read(memoryServiceProvider);
      final albums = await memory.albums();
      expect(albums.where((a) => a.isAuto), hasLength(8));
      final trip = albums.firstWhere(
        (a) => a.title == 'Về quê ngoại · Tháng 9',
      );
      expect((trip.memoryCount, trip.items.length), (32, 12));
      final comments = await memory.comments('m-hana-holds-haru');
      expect(comments.where((x) => x.parentId == null), hasLength(3));
      final groups = await memory.milestoneGroups();
      expect(groups.first.title, 'Truyền thống Việt');
      final options = await memory.milestoneOptions('haru', group: 'tradition');
      expect(options, hasLength(9));
      expect(options.where((o) => o.recorded), hasLength(7));
      expect(
        options.firstWhere((o) => o.code == 'first_birthday').recordedAt,
        DateTime(2026, 4, 8),
      );
    });

    test('search, on this day, recap, drafts', () async {
      final c = _container();
      final memory = c.read(memoryServiceProvider);
      expect(await memory.searchRecents(), [
        '18 tháng',
        'Trung thu',
        'Bà ngoại',
      ]);
      final result = await memory.search('nha tre');
      expect((result.media.length, result.diaries.length), (9, 3));
      final groups = await memory.onThisDay();
      expect(groups.map((g) => g.yearsAgo), [1, 2]);
      expect(groups.first.memories, hasLength(2));
      final recap = await memory.weeklyRecap();
      expect((recap!.moments, recap.firsts, recap.quotes), (24, 2, 1));
      final diary = await memory.draft(MemoryKind.diary);
      expect(diary!.title, 'Ngày đầu Hana đi nhà trẻ');
      final letter = await memory.draft(MemoryKind.letter);
      expect(letter!.sealedUntil, DateTime(2043, 4, 8));
      expect(await memory.diaryPrompts('hana'), hasLength(3));
    });

    test('child profile, archived duplicate, calendar, care extras', () async {
      final c = _container();
      final child = c.read(childServiceProvider);
      final profile = await child.profile('haru');
      expect(profile!.fullName, 'Nguyễn Minh Khang');
      expect((await child.archivedChildren()).single.archivedAt, isNotNull);
      final care = c.read(careServiceProvider);
      final today = DateTime(2026, 10, 7);
      final events = await care.calendarEvents(today, today);
      expect(events.first.allDay, isTrue);
      expect(events, hasLength(5));
      expect((await care.eventDraft()).date, DateTime(2026, 11, 23));
      final history = await care.missionHistory();
      expect(
        history.first.entries
            .where((e) => e.ownerKind == MissionOwnerKind.partner)
            .every((e) => e.hearts == null),
        isTrue,
      );
      final badges = await care.badges();
      expect(badges.where((b) => b.achieved), hasLength(4));
      expect(badges, hasLength(10));
      final settings = await care.missionSettings();
      expect(settings.level, MissionLoadLevel.medium);
      expect(
        settings.categories.where((x) => !x.enabled).single.code,
        'chores',
      );
    });

    test('couple extras, family extras, settings', () async {
      final c = _container();
      final us = c.read(usServiceProvider);
      final wall = await us.thanksWall(month: DateTime(2026, 10));
      expect(wall.first.body, startsWith('Cảm ơn em đã dậy đêm'));
      expect(await us.journal(), hasLength(4));
      expect((await us.coupleSettings()).bridgeRetentionDays, 30);
      final family = c.read(familyServiceProvider);
      final grandma = await family.member('m-ba-ngoai');
      expect(grandma!.childPermissions['haru'], RelativePermission.contribute);
      expect(grandma.postedCount, 14);
      expect((await family.familySettings()).name, 'Nhà Lan');
      final settings = c.read(settingsServiceProvider);
      expect((await settings.profileSettings()).signInMethods, hasLength(3));
      expect((await settings.notificationSettings()).channels, hasLength(11));
      expect((await settings.securitySettings()).devices, hasLength(3));
      final info = await settings.deleteAccountInfo();
      expect((info.partnerName, info.onlyParent), ('Minh', false));
      expect(info.purgeDate, DateTime(2026, 11, 6));
      expect((await settings.help()).hotline, '1900 6868');
    });
  });

  test('MEM-13/18: a device draft is updated in place and reopened', () async {
    final memories = _container().read(memoryServiceProvider);
    final first = await memories.saveDraft(
      kind: MemoryKind.diary,
      title: 'Ngày đầu đi học',
      body: 'Con khóc một chút.',
    );
    final second = await memories.saveDraft(
      kind: MemoryKind.diary,
      title: 'Ngày đầu đi học',
      body: 'Con khóc một chút.\n\nRồi con cười.',
      draftId: first.id,
    );
    expect(second.id, first.id);
    final diaries = (await memories.drafts()).where(
      (draft) => draft.kind == MemoryKind.diary,
    );
    expect(diaries.where((draft) => draft.id == first.id), hasLength(1));
    final reopened = await memories.draft(MemoryKind.diary);
    expect(reopened?.id, first.id);
    expect(reopened?.body, 'Con khóc một chút.\n\nRồi con cười.');
    await memories.clearDraft(MemoryKind.diary);
    expect(
      (await memories.drafts()).where((draft) => draft.id == first.id),
      isEmpty,
    );
  });

  group('batch 3 data (Pencil frames)', () {
    test('bridge, safety, couple week (US-08…14)', () async {
      final us = _container().read(usServiceProvider);
      final draft = await us.bridgeDraft();
      expect(draft!.wizardStep, 3);
      final steps = await us.bridgeOptions('nextSteps');
      expect(steps.map((s) => s.title), contains('Papa trông con 30 phút'));
      final session = await us.bridgeSession('br-1');
      expect(session!.status, BridgeStatus.active);
      expect(session.shares, hasLength(2));
      expect((await us.rewriteSuggestion())!.options, hasLength(3));
      expect((await us.safetyHotlines()).map((h) => h.number), [
        '113',
        '115',
        '111',
      ]);
      final week = await us.coupleWeek();
      expect(week!.checkins, 9);
      await us.closeBridge('br-1');
      expect((await us.bridgeSession('br-1'))!.status, BridgeStatus.closed);
    });

    test('trash, drafts, pending review, report, recaps', () async {
      final memory = _container().read(memoryServiceProvider);
      final trash = await memory.trash();
      expect(trash, hasLength(3));
      await memory.restoreMemory(trash.first.id);
      expect(await memory.trash(), hasLength(2));
      final drafts = await memory.drafts();
      expect(drafts, hasLength(4));
      expect(drafts.first.location, DraftLocation.device);
      final pending = await memory.pendingPosts();
      expect(pending, hasLength(3));
      await memory.approvePost(pending.first.id);
      expect(await memory.pendingPosts(), hasLength(2));
      expect(await memory.reportReasons(), hasLength(7));
      final receipt = await memory.submitReport(
        targetId: 'x',
        reasonCode: 'child_safety',
      );
      expect(receipt.code, 'BC-261007-0482');
      expect(await memory.dayStory(childId: 'haru'), isNotNull);
      expect(await memory.monthRecap(childId: 'haru'), isNotNull);
    });

    test('care stats, child archive (CARE-11, CHD-05)', () async {
      final c = _container();
      final stats = await c.read(careServiceProvider).careStats();
      expect(stats!.total, 32);
      expect(stats.bloomed.where((b) => b), hasLength(5));
      final info = await c.read(childServiceProvider).archiveInfo('khang');
      expect(info.deletableFrom, DateTime(2026, 10, 9));
      expect(info.canDeleteAt(DateTime(2026, 10, 7)), isFalse);
      expect(info.canDeleteAt(DateTime(2026, 10, 9)), isTrue);
    });

    test('plan details, memberships, invites, settings', () async {
      final c = _container();
      final family = c.read(familyServiceProvider);
      final plan = await family.planDetails();
      expect(plan!.aiRemaining, 286);
      expect(plan.aiTotal, 300);
      expect(await family.relativeInvites(), isNotEmpty);
      final settings = c.read(settingsServiceProvider);
      expect(await settings.blockedPeople(), hasLength(1));
      final ai = await settings.aiSettings();
      expect(ai.features, hasLength(6));
      final lan = await family.memberships();
      expect(lan.map((m) => m.familyName), contains('Nhà anh Tuấn'));
    });

    test('circle extras for Bà ngoại (CIR-02…06)', () async {
      final c = _container(seed: DemoSeed.circle);
      final circle = c.read(circleServiceProvider);
      final memory = await circle.memory('c-haru-roll');
      expect(memory, isNotNull);
      expect(await circle.wishes('c-haru-roll'), hasLength(2));
      final prefs = await circle.preferences();
      expect(prefs.postedPhotos, 18);
      await circle.submitPost(await circle.postDraft());
    });

    test('new seeds route to their states', () async {
      for (final (seed, state) in [
        (DemoSeed.partnerLeft, SessionState.active),
        (DemoSeed.circlePaused, SessionState.circlePaused),
        (DemoSeed.paymentIssue, SessionState.active),
        (DemoSeed.house, SessionState.active),
      ]) {
        final c = _container(seed: seed);
        final session = await c.read(sessionServiceProvider).restore();
        expect(session.state, state, reason: seed.name);
      }
    });
  });
}
