import 'package:baby_family/data/service/auth.dart';
import 'package:baby_family/data/service_imp/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authProvider = Provider<IAuthService>((ref) => AuthServiceImp());
