import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/family_remote.dart';
import 'package:baby_family/data/repository/store_purchase.dart';
import 'package:baby_family/data/repository_imp/family.dart';
import 'package:baby_family/data/repository_imp/family_remote.dart';
import 'package:baby_family/data/repository_imp/store_purchase.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service_imp/family.dart';
import 'package:baby_family/data/service_imp/family_remote.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final familyRepositoryProvider = Provider<IFamilyRepository>(
  (ref) => FamilyRepositoryImp(ref.watch(mockStoreProvider)),
);

final familyRemoteRepositoryProvider = Provider<IFamilyRemoteRepository>(
  (ref) => FamilyRemoteRepositoryImp(),
);

/// Bản thật (`BABY_FAMILY_API_URL`): cài đặt quyền riêng tư + tên gia đình qua
/// server (BF-20261018-015).
/// Store của máy (IAP) — chỉ dùng ở bản chạy với server.
final storePurchaseRepositoryProvider = Provider<IStorePurchaseRepository>(
  (ref) => StorePurchaseRepositoryImp(),
);

final familyServiceProvider = Provider<IFamilyService>(
  (ref) => kValueUseRemoteSession
      ? FamilyRemoteServiceImp(
          ref.watch(sessionRepositoryProvider),
          ref.watch(appClockProvider),
          ref.watch(familyRepositoryProvider),
          ref.watch(familyRemoteRepositoryProvider),
          ref.watch(childRepositoryProvider),
          MediaUploader(ref.watch(mediaRepositoryProvider)),
          ref.watch(storePurchaseRepositoryProvider),
        )
      : FamilyServiceImp(
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
