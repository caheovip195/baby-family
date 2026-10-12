import 'dart:convert';

import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

/// In-memory data source of the typed mock (thay cho DemoFamily/DemoEntry).
///
/// - Seeded from `assets/data/mock/*.json` (câu chuyện thiết kế Pencil).
/// - Catalog text is stored per locale as `{"vi": …, "en": …, "zh": …, "ja": …}`
///   and resolved with [localized]; user-entered text stays raw.
/// - Every mutation calls [commit] which bumps [revision] and notifies
///   listeners (`mockRevisionProvider` refreshes the UI).
/// - Only repositories (`lib/data/repository_imp`) read/write the store.
class MockStore extends ChangeNotifier {
  MockStore({
    required this.clock,
    this.seed = DemoSeed.fresh,
    this.actor = 'mama',
    AssetBundle? bundle,
  }) : _bundle = bundle ?? rootBundle;

  static const fixtureFiles = [
    'session',
    'family',
    'children',
    'memories',
    'care',
    'us',
    'pregnancy',
    'notifications',
    'catalog',
    'settings',
  ];

  /// Tables copied from fixtures (each row is a JSON map with an `id`).
  static const tableNames = {
    'family': ['users', 'families', 'members', 'invites'],
    'memories': [
      'memories',
      'comments',
      'perspectives',
      'stories',
      'collections',
      'albums',
      'searchMemories',
      'pastMemories',
      'trash',
      'drafts',
      'pendingPosts',
    ],
    'children': ['children', 'profiles', 'milestoneRecords'],
    'care': [
      'templates',
      'missions',
      'heartsLedger',
      'calendarEvents',
      'badges',
    ],
    'us': [
      'checkins',
      'requests',
      'thanks',
      'questionAnswers',
      'journal',
      'bridgeSessions',
    ],
    'pregnancy': ['prepItems', 'names'],
    'notifications': ['notifications'],
  };

  final AppClock clock;
  final AssetBundle _bundle;
  DemoSeed seed;

  /// `mama` (Lan) or `papa` (Minh) for parent seeds.
  String actor;

  /// Locale code used by [localized] (`vi`, `en`, `zh`, `ja`).
  String locale = 'vi';

  final Map<String, dynamic> _fixtures = {};
  final Map<String, List<Map<String, dynamic>>> _tables = {};
  final Map<String, dynamic> _meta = {};
  final Map<String, dynamic> _session = {};
  Future<void>? _loading;
  int _revision = 0;

  int get revision => _revision;
  bool get isLoaded => _fixtures.isNotEmpty;

  /// Current session row (userId, familyId, role, callName, profileDone…).
  Map<String, dynamic> get session => _session;

  /// Non-table fixture data: `stats`, `heartsBaseline`, `tree`, `treeLevels`,
  /// `swapsUsed`, `catalog`, `dailyQuestions`, `prepHiddenCounts`, `birthDrafts`,
  /// `config`.
  Map<String, dynamic> get meta => _meta;

  Future<void> ensureLoaded() => _loading ??= _load();

  Future<void> _load() async {
    for (final name in fixtureFiles) {
      final raw = await _bundle.loadString(
        'assets/data/mock/$name.json',
        cache: false,
      );
      _fixtures[name] = jsonDecode(raw);
    }
    _applySeed();
  }

  /// Bump revision so providers reload (call after every mutation).
  void commit() {
    _revision++;
    notifyListeners();
  }

  /// Rebuilds all tables from fixtures for [newSeed] (dev tools, sign out).
  Future<void> reseed(DemoSeed newSeed, {String? newActor}) async {
    await ensureLoaded();
    seed = newSeed;
    if (newActor != null) {
      actor = newActor;
    }
    _applySeed();
    commit();
  }

  // ------------------------------------------------------------------ tables

  List<Map<String, dynamic>> table(String name) =>
      _tables.putIfAbsent(name, () => []);

  Map<String, dynamic>? find(String name, String? id) {
    if (id == null) {
      return null;
    }
    for (final row in table(name)) {
      if (row['id'] == id) {
        return row;
      }
    }
    return null;
  }

  Iterable<Map<String, dynamic>> where(
    String name,
    bool Function(Map<String, dynamic> row) test,
  ) => table(name).where(test);

  Map<String, dynamic> insert(String name, Map<String, dynamic> row) {
    final value = {'id': row['id'] ?? newId(name), ...row};
    table(name).insert(0, value);
    return value;
  }

  Map<String, dynamic>? update(
    String name,
    String id,
    Map<String, dynamic> patch,
  ) {
    final row = find(name, id);
    if (row == null) {
      return null;
    }
    row.addAll(patch);
    return row;
  }

  void remove(String name, String id) =>
      table(name).removeWhere((row) => row['id'] == id);

  String newId(String prefix) => '$prefix-${const Uuid().v4().substring(0, 8)}';

  /// Deep copy with every `{"vi":…,"en":…}` map replaced by the text of
  /// [locale] (fallback vi). Repositories call this before `fromJson`.
  Map<String, dynamic> localized(Map<String, dynamic> row) =>
      _resolve(row)! as Map<String, dynamic>;

  /// Single localized catalog value (`{"vi":…}` map or raw string).
  String text(Object? value) => (_resolve(value) as String?) ?? '';

  Object? _resolve(Object? value) {
    if (value is Map<String, dynamic>) {
      if (_isLocalized(value)) {
        return (value[locale] ?? value['vi']) as String?;
      }
      return <String, dynamic>{
        for (final entry in value.entries) entry.key: _resolve(entry.value),
      };
    }
    if (value is List) {
      return value.map(_resolve).toList();
    }
    return value;
  }

  static bool _isLocalized(Map<String, dynamic> value) =>
      value.containsKey('vi') &&
      value.containsKey('en') &&
      value.values.every((item) => item is String);

  // -------------------------------------------------------------------- seed

  void _applySeed() {
    _tables.clear();
    _meta.clear();
    _session.clear();
    for (final entry in tableNames.entries) {
      final fixture = _fixtures[entry.key] as Map<String, dynamic>;
      for (final name in entry.value) {
        _tables[name] = _copyRows(fixture[name]);
      }
    }
    final children = _fixtures['children'] as Map<String, dynamic>;
    final care = _fixtures['care'] as Map<String, dynamic>;
    final us = _fixtures['us'] as Map<String, dynamic>;
    final pregnancy = _fixtures['pregnancy'] as Map<String, dynamic>;
    final memories = _fixtures['memories'] as Map<String, dynamic>;
    final family = _fixtures['family'] as Map<String, dynamic>;
    _meta
      ..['config'] = _copy(_fixtures['session'])
      ..['catalog'] = _copy(_fixtures['catalog'])
      ..['stats'] = _copy(children['stats'])
      ..['heartsBaseline'] = _copy(care['heartsBaseline'])
      ..['tree'] = _copy(care['tree'])
      ..['treeLevels'] = _copy(care['treeLevels'])
      ..['swapsUsed'] = _copy(care['swapsUsed'])
      ..['createDraft'] = _copy(care['createDraft'])
      ..['dailyQuestions'] = _copy(us['dailyQuestions'])
      ..['prepHiddenCounts'] = _copy(pregnancy['prepHiddenCounts'])
      ..['birthDrafts'] = _copy(pregnancy['birthDrafts'])
      // Batch 2 (33 Pencil frames): screen data that is not a table.
      ..['searchRecents'] = _copy(memories['searchRecents'])
      ..['weeklyRecap'] = _copy(memories['weeklyRecap'])
      ..['eventDraft'] = _copy(care['eventDraft'])
      ..['missionHistory'] = _copy(care['missionHistory'])
      ..['missionSettings'] = _copy(care['missionSettings'])
      ..['coupleSettings'] = _copy(us['coupleSettings'])
      ..['familySettings'] = _copy(family['familySettings'])
      ..['settings'] = _copy(_fixtures['settings'])
      // Batch 3.
      ..['dayStory'] = _copy(memories['dayStory'])
      ..['monthRecap'] = _copy(memories['monthRecap'])
      ..['circlePostDraft'] = _copy(memories['circlePostDraft'])
      ..['careStats'] = _copy(care['careStats'])
      ..['bridgeRewrite'] = _copy(us['bridgeRewrite'])
      ..['coupleWeek'] = _copy(us['coupleWeek'])
      ..['memberships'] = _copy(family['memberships'])
      ..['planDetails'] = _copy(family['planDetails'])
      ..['circlePreferences'] = _copy(family['circlePreferences']);

    final actorUserId = actor == 'papa' ? 'u-minh' : 'u-lan';
    final actorMemberId = actor == 'papa' ? 'm-minh' : 'm-lan';
    switch (seed) {
      case DemoSeed.fresh:
        // Design family on the Family plan (relative code B4N0I123 joins as
        // Bà nội) + “Nhà Lan” waiting for Papa (partner code K7Q29MXA).
        _setPlan('f-lan', PlanState.family, slotsUsed: 2, slotsMax: 12);
      case DemoSeed.active:
        // Story v2: Family plan (fixture) with Bà nội, Bà ngoại, Ông ngoại.
        _activateRelatives();
        _signIn(actorUserId, 'f-lan', actorMemberId);
      case DemoSeed.trial:
        _setPlan('f-lan', PlanState.trial);
        _removeRelatives();
        _signIn(actorUserId, 'f-lan', actorMemberId);
      case DemoSeed.pregnant:
        _setPlan('f-lan', PlanState.trial);
        _removeRelatives();
        _keepOnlyChildren({'bo'});
        _signIn(actorUserId, 'f-lan', actorMemberId);
      case DemoSeed.partnerLeft:
        // US-00 / FAM-02: Papa deleted his account — view & download only.
        _activateRelatives();
        _tables['members']!.removeWhere((row) => row['id'] == 'm-minh');
        _family('f-lan')['partnerLeftAt'] = DateTime(
          2026,
          10,
          5,
          9,
        ).toIso8601String();
        _signIn('u-lan', 'f-lan', 'm-lan');
      case DemoSeed.paymentIssue:
        _activateRelatives();
        (_family('f-lan')['plan'] as Map<String, dynamic>)['paymentIssue'] =
            true;
        _signIn(actorUserId, 'f-lan', actorMemberId);
      case DemoSeed.house:
        _setPlan('f-lan', PlanState.house);
        _removeRelatives();
        _signIn(actorUserId, 'f-lan', actorMemberId);
      case DemoSeed.circlePaused:
        _setPlan('f-lan', PlanState.family, slotsUsed: 2, slotsMax: 12);
        find('members', 'm-ba-ngoai')?['paused'] = true;
        _signIn('u-ba-ngoai', 'f-lan', 'm-ba-ngoai');
        _tables['memories'] = _copyRows(memories['circleMemories']);
      case DemoSeed.circle:
        _setPlan('f-lan', PlanState.family, slotsUsed: 2, slotsMax: 12);
        _signIn('u-ba-ngoai', 'f-lan', 'm-ba-ngoai');
        // CIR-01 (Pencil zO5Oq) tells its own story: Haru's hero photo and
        // “Ảnh mới tuần này” — parent feeds keep their own fixture rows.
        _tables['memories'] = _copyRows(memories['circleMemories']);
      case DemoSeed.expired:
        _removeRelatives();
        final plan = _family('f-lan')['plan'] as Map<String, dynamic>;
        plan
          ..['state'] = PlanState.expired.name
          ..['endsAt'] = DateTime(2026, 10, 6, 23, 59).toIso8601String();
        _signIn(actorUserId, 'f-lan', actorMemberId);
    }
    if (seed != DemoSeed.fresh) {
      _tables['families']!.removeWhere((row) => row['id'] == 'f-lan-waiting');
      _tables['members']!.removeWhere(
        (row) => row['familyId'] == 'f-lan-waiting',
      );
      // Partner invites only exist for the fresh flow, except the mock codes
      // of INV-02/03/04 (`mock: true`).
      _tables['invites']!.removeWhere(
        (row) => row['kind'] == 'partner' && row['mock'] != true,
      );
    }
    // FAM-02's new partner invite exists only after Papa left.
    if (seed == DemoSeed.partnerLeft) {
      final fixture = (_fixtures['family'] as Map<String, dynamic>)['invites'];
      _tables['invites']!.addAll(
        _copyRows(fixture).where((row) => row['seed'] == 'partnerLeft'),
      );
    } else {
      _tables['invites']!.removeWhere((row) => row['seed'] == 'partnerLeft');
    }
  }

  void _signIn(String userId, String familyId, String memberId) {
    _session
      ..['userId'] = userId
      ..['familyId'] = familyId
      ..['memberId'] = memberId
      ..['profileDone'] = true;
  }

  Map<String, dynamic> _family(String id) => find('families', id)!;

  void _setPlan(
    String familyId,
    PlanState state, {
    int slotsUsed = 0,
    int slotsMax = 0,
  }) {
    final plan = _family(familyId)['plan'] as Map<String, dynamic>;
    plan
      ..['state'] = state.name
      ..['storageQuotaMb'] = state == PlanState.family ? 204800 : 10240
      ..['relativeSlotsUsed'] = slotsUsed
      ..['relativeSlotsMax'] = slotsMax;
    if (state == PlanState.trial) {
      // Trial seeds match the fresh flow: 3 months from “today” (FAM-01
      // `XwXfH` “Còn 90 ngày · hết hạn 05/01/2027”, SUB-01, ONB-ACT).
      final today = clock.today;
      plan
        ..['startedAt'] = today.toIso8601String()
        ..['endsAt'] = DateTime(
          today.year,
          today.month,
          today.day + kValueTrialDays,
          23,
          59,
        ).toIso8601String();
    }
  }

  /// Every invited relative has joined (no pending relative invite left).
  /// Story v2 (FAM-01 `r8l6e`): once joined, Bà nội follows Hana and Haru
  /// (the INV-01 invite itself only shares Hana).
  void _activateRelatives() {
    for (final row in _tables['members']!) {
      if (row['role'] == 'relative') {
        row['status'] = 'active';
        row['joinedAt'] ??= DateTime(2026, 9, 12, 10).toIso8601String();
      }
      if (row['id'] == 'm-ba-noi') {
        row
          ..['grantedChildIds'] = ['hana', 'haru']
          ..['childPermissions'] = {'hana': 'comment', 'haru': 'comment'};
      }
    }
    // Bà nội's invite is used up; FAM-05 keeps Ông nội (pending) & Dì Mai.
    _tables['invites']!.removeWhere(
      (row) => row['kind'] == 'relative' && row['keep'] != true,
    );
  }

  /// C-07: the trial has no relatives (their old comments keep the author name).
  void _removeRelatives() {
    _tables['members']!.removeWhere((row) => row['role'] == 'relative');
    _tables['invites']!.removeWhere((row) => row['kind'] == 'relative');
  }

  void _keepOnlyChildren(Set<String> ids) {
    bool keep(Object? childIds) =>
        (childIds as List?)?.every((id) => ids.contains(id)) ?? true;
    _tables['children']!.removeWhere((row) => !ids.contains(row['id']));
    for (final name in ['memories', 'stories', 'missions']) {
      _tables[name]!.removeWhere(
        (row) => !keep(row['childIds'] ?? [row['childId']]),
      );
    }
    final memoryIds = _tables['memories']!.map((row) => row['id']).toSet();
    for (final name in ['comments', 'perspectives']) {
      _tables[name]!.removeWhere((row) => !memoryIds.contains(row['memoryId']));
    }
  }

  static List<Map<String, dynamic>> _copyRows(Object? rows) => [
    for (final row in (rows as List?) ?? const [])
      Map<String, dynamic>.from(_copy(row)! as Map),
  ];

  static Object? _copy(Object? value) =>
      value == null ? null : jsonDecode(jsonEncode(value));
}
