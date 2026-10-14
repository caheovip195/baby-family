import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:intl/intl.dart';

const _mbPerGb = 1024;

/// Dung lượng MB → số GB một chữ số thập phân theo ngôn ngữ (“3,2”, “200”) —
/// FAM-01 thẻ gói, SUB-03 dung lượng, SUB-02/04.
String storageGbText(int mb, String locale) =>
    NumberFormat('#,##0.#', locale).format(mb / _mbPerGb);

/// Giá catalog “599.000đ / năm” → “599.000đ/năm” (FAM-01, SUB-02/03/04).
String compactPriceText(String priceText) => priceText.replaceAll(' / ', '/');

/// Tên ngắn của gói bán trên Store: “House” / “Family” (SUB-01/02/04).
String planShortName(AppLocalizations l10n, PlanState plan) =>
    plan == PlanState.house ? l10n.billingHouse : l10n.billingFamily;

/// “Gói House” / “Gói Family” (SUB-03/05/06, SET-05).
String planTitle(AppLocalizations l10n, PlanState plan) =>
    plan == PlanState.house ? l10n.famPlanHouse : l10n.famPlanFamily;
