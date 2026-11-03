import 'dart:typed_data';

import 'package:baby_family/data/model/year_book/year_book.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/year_book_remote.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:dio/dio.dart';

class YearBookRemoteRepositoryImp extends BaseRepositoryImp
    implements IYearBookRemoteRepository {
  /// Dio riêng: URL đã ký, không đi qua interceptor xác thực.
  static final _media = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 60),
      responseType: ResponseType.bytes,
    ),
  );

  @override
  Future<YearBookRecord?> get(
    String familyId,
    String? childId,
    int year,
  ) async =>
      (childId == null
              ? await client!.getFamilyYearBook(familyId, year)
              : await client!.getYearBook(childId, year))
          .book;

  @override
  Future<YearBookRecord?> put(
    String familyId,
    String? childId,
    int year,
    JsonMap body,
  ) async =>
      (childId == null
              ? await client!.putFamilyYearBook(familyId, year, body)
              : await client!.putYearBook(childId, year, body))
          .book;

  @override
  Future<List<YearBookSummary>> list(String familyId) async =>
      (await client!.getYearBooks(familyId)).books?.items ?? const [];

  @override
  Future<Uint8List> download(String url) async {
    final response = await _media.get<List<int>>(url);
    return Uint8List.fromList(response.data ?? const []);
  }
}
