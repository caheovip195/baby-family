import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository_imp/family.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service_imp/family.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final familyRepositoryProvider = Provider<IFamilyRepository>(
  (ref) => FamilyRepositoryImp(ref.watch(mockStoreProvider)),
);

final familyServiceProvider = Provider<IFamilyService>(
  (ref) => FamilyServiceImp(
    ref.watch(sessionRepositoryProvider),
    ref.watch(appClockProvider),
    ref.watch(familyRepositoryProvider),
  ),
);

final currentFamilyProvider = FutureProvider<Family?>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(familyServiceProvider).currentFamily();
});

final familyMembersProvider = FutureProvider<List<Member>>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(familyServiceProvider).members();
});

/// Thành viên của người đang đăng nhập (tên gọi, vai trò).
final meProvider = FutureProvider<Member?>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(familyServiceProvider).me();
});

/// Bạn đời — `callName` dùng cho “Của {callName}”, “Nhờ {callName}”.
final partnerProvider = FutureProvider<Member?>((ref) {
  ref.watch(mockRevisionProvider);
  return ref.watch(familyServiceProvider).partner();
});
