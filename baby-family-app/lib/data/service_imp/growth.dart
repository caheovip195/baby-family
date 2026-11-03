import 'package:baby_family/data/model/growth/growth_entry.dart';
import 'package:baby_family/data/service/growth.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';
import 'package:intl/intl.dart';

/// Bản mock: lần đo chỉ trong bộ nhớ của phiên app.
class GrowthServiceImp extends MockServiceImp implements IGrowthService {
  GrowthServiceImp(super.sessionRepository, super.clock);

  static final day = DateFormat('yyyy-MM-dd');

  final _entries = <String, Map<String, GrowthEntry>>{};

  @override
  Future<List<GrowthEntry>> entries(String childId) async =>
      sorted(_entries[childId]?.values ?? const []);

  @override
  Future<GrowthEntry> save(
    String childId, {
    required DateTime day,
    int? weightGrams,
    int? heightMm,
    String? note,
  }) async {
    final entry = entryOf(day, weightGrams, heightMm, note);
    (_entries[childId] ??= {})[entry.measuredOn] = entry;
    return entry;
  }

  @override
  Future<void> remove(String childId, DateTime day) async =>
      _entries[childId]?.remove(GrowthServiceImp.day.format(day));

  @override
  Future<void> syncPending() async {}

  static GrowthEntry entryOf(
    DateTime date,
    int? weightGrams,
    int? heightMm,
    String? note,
  ) {
    if (weightGrams == null && heightMm == null) {
      throw ArgumentError('weightGrams or heightMm is required');
    }
    final trimmed = note?.trim();
    return GrowthEntry(
      measuredOn: day.format(date),
      weightGrams: weightGrams,
      heightMm: heightMm,
      note: trimmed == null || trimmed.isEmpty ? null : trimmed,
    );
  }

  static List<GrowthEntry> sorted(Iterable<GrowthEntry> items) =>
      [...items]..sort((a, b) => a.measuredOn.compareTo(b.measuredOn));
}
