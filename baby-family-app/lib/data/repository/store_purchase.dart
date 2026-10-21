import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/utils/helper/user_cancelled.dart';

/// Kết quả mua trên Store: [credential] là JWS giao dịch (App Store,
/// StoreKit 2) hoặc purchaseToken (Google Play) để server xác minh.
class StorePurchase {
  const StorePurchase({
    required this.store,
    required this.productId,
    required this.credential,
    this.handle,
  });

  /// `APP_STORE` | `PLAY` (khớp `store` của API).
  final String store;
  final String productId;
  final String credential;

  /// Đối tượng của plugin để hoàn tất giao dịch sau khi server xác minh.
  final Object? handle;
}

/// Người dùng huỷ ở sheet của Store — không phải lỗi.
class StorePurchaseCancelled implements UserCancelled {
  const StorePurchaseCancelled();
}

/// Store của máy (SUB-01/02/04). Giá và thanh toán do Store quản lý; app không
/// tự cấp gói — server xác minh rồi mới đổi quyền lợi.
abstract class IStorePurchaseRepository extends IBaseRepository {
  /// `APP_STORE` trên iOS, `PLAY` trên Android; null khi không bán được.
  String? get store;

  /// Mua gói [productId] gắn [accountToken] (appAccountToken /
  /// obfuscatedAccountId do server cấp cho lần mua này).
  Future<StorePurchase> buy({
    required String productId,
    required String accountToken,
  });

  /// Hoàn tất giao dịch với Store sau khi server đã ghi nhận.
  Future<void> complete(StorePurchase purchase);
}
