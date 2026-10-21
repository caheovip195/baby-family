import 'dart:async';
import 'dart:io';

import 'package:baby_family/data/repository/store_purchase.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class StorePurchaseRepositoryImp extends BaseRepositoryImp
    implements IStorePurchaseRepository {
  StorePurchaseRepositoryImp([InAppPurchase? iap])
    : _iap = iap ?? InAppPurchase.instance;

  final InAppPurchase _iap;

  @override
  String? get store => Platform.isIOS
      ? 'APP_STORE'
      : Platform.isAndroid
      ? 'PLAY'
      : null;

  @override
  Future<StorePurchase> buy({
    required String productId,
    required String accountToken,
  }) async {
    final store = this.store;
    if (store == null || !await _iap.isAvailable()) {
      throw StateError('Store is not available');
    }
    // iOS dùng StoreKit 2 (mặc định của plugin): serverVerificationData là
    // JWS giao dịch mà server xác minh.
    final response = await _iap.queryProductDetails({productId});
    final product = response.productDetails.firstOrNull;
    if (product == null) {
      throw StateError('Store product $productId not found');
    }
    final completer = Completer<StorePurchase>();
    late final StreamSubscription<List<PurchaseDetails>> subscription;
    subscription = _iap.purchaseStream.listen(
      (updates) {
        for (final update in updates) {
          if (update.productID != productId || completer.isCompleted) {
            continue;
          }
          switch (update.status) {
            case PurchaseStatus.purchased || PurchaseStatus.restored:
              completer.complete(
                StorePurchase(
                  store: store,
                  productId: productId,
                  credential: update.verificationData.serverVerificationData,
                  handle: update,
                ),
              );
            case PurchaseStatus.canceled:
              completer.completeError(const StorePurchaseCancelled());
            case PurchaseStatus.error:
              completer.completeError(
                StateError(update.error?.message ?? 'Store purchase failed'),
              );
            case PurchaseStatus.pending:
              break;
          }
        }
      },
      onError: (Object error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
    );
    try {
      await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(
          productDetails: product,
          applicationUserName: accountToken,
        ),
      );
      return await completer.future;
    } finally {
      await subscription.cancel();
    }
  }

  @override
  Future<void> complete(StorePurchase purchase) async {
    final handle = purchase.handle;
    if (handle is PurchaseDetails && handle.pendingCompletePurchase) {
      await _iap.completePurchase(handle);
    }
  }
}
