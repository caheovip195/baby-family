import 'package:baby_family/data/dto/mission_series_info.dart';
import 'package:baby_family/data/model/care/mission_settings.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// CARE-12 “Cài đặt nhiệm vụ” (mục 9.7, Pencil `PY4Zg`): mức nhiệm vụ hằng
/// ngày của cả nhà (Nhẹ 2 / Vừa 3 / Nhiều 4 — áp dụng cho cả hai, báo bạn
/// đời), loại việc tôi muốn nhận, giờ nhận bảng, hỏi lúc 21:00, nhắc mặc
/// định. Mỗi thay đổi lưu ngay. Cuối màn: chuỗi lặp lại tự thêm (CARE-03,
/// mục 7.13.6) — tạm dừng 1 tuần hoặc dừng hẳn.
final missionSettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<MissionSettingsController>(
      MissionSettingsController.new,
    );

class MissionSettingsController extends BaseNotifier {
  MissionSettingsController(super.ref) {
    load();
  }

  ICareService get careService => ref.read(careServiceProvider);

  bool loaded = false;
  bool hasError = false;
  MissionSettings settings = const MissionSettings();
  Member? me;
  Member? partner;
  List<MissionSeriesInfo> series = const [];

  Future<void> load() async {
    hasError = false;
    try {
      final loadedSettings = await careService.missionSettings();
      final family = ref.read(familyServiceProvider);
      final loadedMe = await family.me();
      final loadedPartner = await family.partner();
      final loadedSeries = await careService.missionSeries();
      if (isDisposed) {
        return;
      }
      settings = loadedSettings;
      me = loadedMe;
      partner = loadedPartner;
      series = loadedSeries;
    } on Object {
      hasError = true;
    }
    loaded = true;
    notifyListeners();
  }

  Future<void> _save(MissionSettings value) async {
    settings = value;
    notifyListeners();
    await careService.saveMissionSettings(value);
  }

  Future<void> setLevel(MissionLoadLevel level) =>
      _save(settings.copyWith(level: level));

  Future<void> toggleCategory(String code, bool enabled) => _save(
    settings.copyWith(
      categories: [
        for (final category in settings.categories)
          category.code == code
              ? category.copyWith(enabled: enabled)
              : category,
      ],
    ),
  );

  Future<void> setBoardTime(String value) =>
      _save(settings.copyWith(boardTime: value));

  Future<void> setAskAtNight(bool value) =>
      _save(settings.copyWith(askAtNight: value));

  Future<void> setDefaultReminder(MissionReminder value) =>
      _save(settings.copyWith(defaultReminder: value));

  Future<void> _reloadSeries() async {
    final loadedSeries = await careService.missionSeries();
    if (isDisposed) {
      return;
    }
    series = loadedSeries;
    notifyListeners();
  }

  Future<void> pauseSeriesWeek(String seriesId) async {
    await careService.pauseSeries(seriesId);
    await _reloadSeries();
  }

  Future<void> endSeries(String seriesId) async {
    await careService.endSeries(seriesId);
    await _reloadSeries();
  }
}
