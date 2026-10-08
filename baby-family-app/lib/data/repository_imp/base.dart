import 'package:baby_family/data/remote/app_client/app_client.dart';
import 'package:baby_family/data/remote/dio_config/app_service_dio.dart';
import 'package:baby_family/data/repository/base.dart';

/// Repository là nơi DUY NHẤT gọi [AppClient] (Skill 6).
class BaseRepositoryImp implements IBaseRepository {
  AppClient? get client => AppServiceDio.appClient;
}
