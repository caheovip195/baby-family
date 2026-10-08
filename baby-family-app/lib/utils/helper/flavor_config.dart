import 'package:baby_family/utils/constants/enum.dart';

class FlavorConfig {
  FlavorConfig._({required this.endPoint, required this.flavor});

  factory FlavorConfig.of(Flavor flavor) {
    return instance = FlavorConfig._(endPoint: flavor.endPoint, flavor: flavor);
  }

  static late FlavorConfig instance;

  final String endPoint;

  final Flavor flavor;

  bool get isProduct => flavor == Flavor.pro;
}
