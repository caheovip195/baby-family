import 'package:baby_family/data/model/settings/data_export_info.dart';
import 'package:baby_family/data/model/settings/data_export_job.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:hooks_riverpod/legacy.dart';

/// SET-08 — Dữ liệu của tôi: xuất dữ liệu cá nhân / gia đình, trạng thái
/// xuất, bộ nhớ đệm trên máy.
final myDataControllerProvider =
    ChangeNotifierProvider.autoDispose<MyDataController>(MyDataController.new);

class MyDataController extends BaseNotifier {
  MyDataController(super.ref) {
    load();
  }

  ISettingsService get settingsService => ref.read(settingsServiceProvider);

  DataExportInfo? info;
  bool hasError = false;

  Future<void> load() async {
    hasError = false;
    try {
      final result = await settingsService.dataExport();
      if (isDisposed) {
        return;
      }
      info = result;
    } catch (_) {
      if (isDisposed) {
        return;
      }
      hasError = true;
    }
    notifyListeners();
  }

  DataExportJob? jobOf(DataExportKind kind) {
    for (final job in info?.jobs ?? const <DataExportJob>[]) {
      if (job.kind == kind) {
        return job;
      }
    }
    return null;
  }

  bool isPreparing(DataExportKind kind) =>
      jobOf(kind)?.status == DataExportStatus.preparing;

  /// Bản xuất đang chạy trước, bản sẵn sàng sau (Pencil “Trạng thái xuất”).
  List<DataExportJob> get activeJobs => [
    for (final status in [DataExportStatus.preparing, DataExportStatus.ready])
      ...?info?.jobs.where((job) => job.status == status),
  ];

  Future<void> startExport(DataExportKind kind) async {
    await settingsService.startExport(kind);
    await load();
  }

  /// Link tải mới của bản đã sẵn sàng (null ở bản mock).
  Future<String?> downloadUrl(DataExportKind kind) =>
      settingsService.exportDownloadUrl(kind);

  Future<void> clearCache() async {
    await settingsService.clearCache();
    await load();
  }
}
