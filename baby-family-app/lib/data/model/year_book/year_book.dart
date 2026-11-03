import 'package:baby_family/utils/helper/lenient_json.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'year_book.freezed.dart';
part 'year_book.g.dart';

/// Một ảnh của ký ức trong sách; [url] là URL xem có hạn (bản ~1080px).
@Freezed(when: FreezedWhenOptions.none)
abstract class YearBookPhoto with _$YearBookPhoto {
  @JsonSerializable(explicitToJson: true)
  const factory YearBookPhoto({
    @JsonKey(name: 'assetId') required String assetId,
    @JsonKey(name: 'url') String? url,
  }) = _YearBookPhoto;

  factory YearBookPhoto.fromJson(Map<String, dynamic> json) =>
      _$YearBookPhotoFromJson(json);
}

/// Một ký ức của chương: [included] = có trong sách, [selectedAssetIds] = ảnh
/// đang chọn (theo thứ tự in).
@Freezed(when: FreezedWhenOptions.none)
abstract class YearBookItem with _$YearBookItem {
  @JsonSerializable(explicitToJson: true)
  const factory YearBookItem({
    @JsonKey(name: 'memoryId') required String memoryId,
    @JsonKey(name: 'kind') @Default('') String kind,
    @JsonKey(name: 'occurredAt') String? occurredAt,
    @JsonKey(name: 'caption') @Default('') String caption,
    @JsonKey(name: 'included') @Default(false) bool included,
    @JsonKey(name: 'selectedAssetIds')
    @Default(<String>[])
    List<String> selectedAssetIds,
    @JsonKey(name: 'photos', fromJson: _yearBookPhotos)
    @Default(<YearBookPhoto>[])
    List<YearBookPhoto> photos,
  }) = _YearBookItem;

  factory YearBookItem.fromJson(Map<String, dynamic> json) =>
      _$YearBookItemFromJson(json);
}

/// Chương = một tháng trong năm (1–12); [title] null = tên tháng mặc định.
@Freezed(when: FreezedWhenOptions.none)
abstract class YearBookChapter with _$YearBookChapter {
  @JsonSerializable(explicitToJson: true)
  const factory YearBookChapter({
    @JsonKey(name: 'month') required int month,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'items', fromJson: _yearBookItems)
    @Default(<YearBookItem>[])
    List<YearBookItem> items,
  }) = _YearBookChapter;

  factory YearBookChapter.fromJson(Map<String, dynamic> json) =>
      _$YearBookChapterFromJson(json);
}

/// REC-04 Sách của con (`/children/{id}/year-book/{year}`, BF-20261028-013).
/// [canExport] theo gói (dùng thử chỉ xem trước); [pending] = bản chỉnh sửa
/// lưu trên máy, chờ gửi.
@Freezed(when: FreezedWhenOptions.none)
abstract class YearBookRecord with _$YearBookRecord {
  @JsonSerializable(explicitToJson: true)
  const factory YearBookRecord({
    /// null = sách cả nhà (BF-20261030-001).
    @JsonKey(name: 'childId') String? childId,
    @JsonKey(name: 'year') required int year,
    @JsonKey(name: 'childName') @Default('') String childName,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'canExport') @Default(false) bool canExport,

    /// Bản cho ông bà (BF-20261030-002): gói cho phép chia sẻ / đang chia sẻ
    /// / người thân đang đọc (chỉ đọc).
    @JsonKey(name: 'canShare') @Default(false) bool canShare,
    @JsonKey(name: 'sharedWithCircle') @Default(false) bool sharedWithCircle,
    @JsonKey(name: 'readOnly') @Default(false) bool readOnly,
    @JsonKey(name: 'saved') @Default(false) bool saved,
    @JsonKey(name: 'pending') @Default(false) bool pending,
    @JsonKey(name: 'chapters', fromJson: _yearBookChapters)
    @Default(<YearBookChapter>[])
    List<YearBookChapter> chapters,
  }) = _YearBookRecord;

  factory YearBookRecord.fromJson(Map<String, dynamic> json) =>
      _$YearBookRecordFromJson(json);

  const YearBookRecord._();

  /// Sách cả nhà: mọi ký ức của gia đình ([childName] là tên gia đình).
  bool get isFamily => childId == null;

  /// Ký ức đang có trong sách.
  int get includedCount => chapters.fold(
    0,
    (sum, chapter) => sum + chapter.items.where((item) => item.included).length,
  );

  /// Body `PUT`: chỉ ký ức đang chọn.
  Map<String, dynamic> saveBody() => {
    'title': title,
    'sharedWithCircle': sharedWithCircle,
    'chapters': [
      for (final chapter in chapters)
        {
          'month': chapter.month,
          'title': chapter.title,
          'items': [
            for (final item in chapter.items)
              if (item.included)
                {
                  'memoryId': item.memoryId,
                  'assetIds': item.selectedAssetIds,
                  'caption': item.caption,
                },
          ],
        },
    ],
  };

  /// Áp bản chỉnh sửa [body] (dạng [saveBody]) lên bản đọc từ server.
  YearBookRecord withDraft(Map<String, dynamic> body) {
    final picks = <String, Map>{};
    final titles = <int, String?>{};
    for (final chapter in (body['chapters'] as List? ?? const [])) {
      if (chapter is! Map || chapter['month'] is! int) {
        continue;
      }
      titles[chapter['month'] as int] = chapter['title'] as String?;
      for (final item in (chapter['items'] as List? ?? const [])) {
        if (item is Map && item['memoryId'] is String) {
          picks[item['memoryId'] as String] = item;
        }
      }
    }
    return copyWith(
      title: body['title'] as String?,
      sharedWithCircle: body['sharedWithCircle'] is bool
          ? body['sharedWithCircle'] as bool
          : sharedWithCircle,
      saved: true,
      chapters: [
        for (final chapter in chapters)
          chapter.copyWith(
            title: titles[chapter.month],
            items: [
              for (final item in chapter.items)
                if (picks[item.memoryId] case final pick?)
                  item.copyWith(
                    included: true,
                    caption: pick['caption'] as String? ?? item.caption,
                    selectedAssetIds: [
                      for (final id in (pick['assetIds'] as List? ?? const []))
                        if (id is String &&
                            item.photos.any((photo) => photo.assetId == id))
                          id,
                    ],
                  )
                else
                  item.copyWith(included: false, selectedAssetIds: const []),
            ],
          ),
      ],
    );
  }
}

List<YearBookPhoto> _yearBookPhotos(Object? json) =>
    lenientList(json, YearBookPhoto.fromJson, label: 'ảnh sách');

List<YearBookItem> _yearBookItems(Object? json) =>
    lenientList(json, YearBookItem.fromJson, label: 'ký ức sách');

List<YearBookChapter> _yearBookChapters(Object? json) =>
    lenientList(json, YearBookChapter.fromJson, label: 'chương sách');

/// Sách đã lưu trong danh sách (`GET /families/{id}/year-books`,
/// BF-20261030-002): người thân chỉ thấy bản đã chia sẻ.
@Freezed(when: FreezedWhenOptions.none)
abstract class YearBookSummary with _$YearBookSummary {
  @JsonSerializable(explicitToJson: true)
  const factory YearBookSummary({
    @JsonKey(name: 'scope') @Default('CHILD') String scope,
    @JsonKey(name: 'childId') String? childId,
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'year') required int year,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'sharedWithCircle') @Default(false) bool sharedWithCircle,
  }) = _YearBookSummary;

  factory YearBookSummary.fromJson(Map<String, dynamic> json) =>
      _$YearBookSummaryFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none)
abstract class YearBookList with _$YearBookList {
  @JsonSerializable(explicitToJson: true)
  const factory YearBookList({
    @JsonKey(name: 'items', fromJson: _yearBookSummaries)
    @Default(<YearBookSummary>[])
    List<YearBookSummary> items,
  }) = _YearBookList;

  factory YearBookList.fromJson(Map<String, dynamic> json) =>
      _$YearBookListFromJson(json);
}

List<YearBookSummary> _yearBookSummaries(Object? json) =>
    lenientList(json, YearBookSummary.fromJson, label: 'sách năm');
