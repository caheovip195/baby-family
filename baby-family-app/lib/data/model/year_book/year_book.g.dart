// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YearBookPhoto _$YearBookPhotoFromJson(Map<String, dynamic> json) =>
    _YearBookPhoto(
      assetId: json['assetId'] as String,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$YearBookPhotoToJson(_YearBookPhoto instance) =>
    <String, dynamic>{'assetId': instance.assetId, 'url': instance.url};

_YearBookItem _$YearBookItemFromJson(Map<String, dynamic> json) =>
    _YearBookItem(
      memoryId: json['memoryId'] as String,
      kind: json['kind'] as String? ?? '',
      occurredAt: json['occurredAt'] as String?,
      caption: json['caption'] as String? ?? '',
      included: json['included'] as bool? ?? false,
      selectedAssetIds:
          (json['selectedAssetIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      photos: json['photos'] == null
          ? const <YearBookPhoto>[]
          : _yearBookPhotos(json['photos']),
    );

Map<String, dynamic> _$YearBookItemToJson(_YearBookItem instance) =>
    <String, dynamic>{
      'memoryId': instance.memoryId,
      'kind': instance.kind,
      'occurredAt': instance.occurredAt,
      'caption': instance.caption,
      'included': instance.included,
      'selectedAssetIds': instance.selectedAssetIds,
      'photos': instance.photos.map((e) => e.toJson()).toList(),
    };

_YearBookChapter _$YearBookChapterFromJson(Map<String, dynamic> json) =>
    _YearBookChapter(
      month: (json['month'] as num).toInt(),
      title: json['title'] as String?,
      items: json['items'] == null
          ? const <YearBookItem>[]
          : _yearBookItems(json['items']),
    );

Map<String, dynamic> _$YearBookChapterToJson(_YearBookChapter instance) =>
    <String, dynamic>{
      'month': instance.month,
      'title': instance.title,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

_YearBookRecord _$YearBookRecordFromJson(Map<String, dynamic> json) =>
    _YearBookRecord(
      childId: json['childId'] as String?,
      year: (json['year'] as num).toInt(),
      childName: json['childName'] as String? ?? '',
      title: json['title'] as String?,
      canExport: json['canExport'] as bool? ?? false,
      canShare: json['canShare'] as bool? ?? false,
      sharedWithCircle: json['sharedWithCircle'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      saved: json['saved'] as bool? ?? false,
      pending: json['pending'] as bool? ?? false,
      chapters: json['chapters'] == null
          ? const <YearBookChapter>[]
          : _yearBookChapters(json['chapters']),
    );

Map<String, dynamic> _$YearBookRecordToJson(_YearBookRecord instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'year': instance.year,
      'childName': instance.childName,
      'title': instance.title,
      'canExport': instance.canExport,
      'canShare': instance.canShare,
      'sharedWithCircle': instance.sharedWithCircle,
      'readOnly': instance.readOnly,
      'saved': instance.saved,
      'pending': instance.pending,
      'chapters': instance.chapters.map((e) => e.toJson()).toList(),
    };

_YearBookSummary _$YearBookSummaryFromJson(Map<String, dynamic> json) =>
    _YearBookSummary(
      scope: json['scope'] as String? ?? 'CHILD',
      childId: json['childId'] as String?,
      name: json['name'] as String? ?? '',
      year: (json['year'] as num).toInt(),
      title: json['title'] as String?,
      sharedWithCircle: json['sharedWithCircle'] as bool? ?? false,
    );

Map<String, dynamic> _$YearBookSummaryToJson(_YearBookSummary instance) =>
    <String, dynamic>{
      'scope': instance.scope,
      'childId': instance.childId,
      'name': instance.name,
      'year': instance.year,
      'title': instance.title,
      'sharedWithCircle': instance.sharedWithCircle,
    };

_YearBookList _$YearBookListFromJson(Map<String, dynamic> json) =>
    _YearBookList(
      items: json['items'] == null
          ? const <YearBookSummary>[]
          : _yearBookSummaries(json['items']),
    );

Map<String, dynamic> _$YearBookListToJson(_YearBookList instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
