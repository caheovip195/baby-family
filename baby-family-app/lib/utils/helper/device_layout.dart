import 'dart:ui' as ui;

import 'package:baby_family/utils/constants/enum.dart';
import 'package:flutter/widgets.dart';

bool isMobileLayout(BuildContext context) {
  return DeviceLayoutHelper.fromContext(context).isMobile;
}

bool isTabletLayout(BuildContext context) {
  return DeviceLayoutHelper.fromContext(context).isTablet;
}

bool isTabletOrLargerLayout(BuildContext context) {
  return DeviceLayoutHelper.fromContext(context).isTabletOrLarger;
}

class DeviceLayout {
  const DeviceLayout({
    required this.logicalSize,
    required this.devicePixelRatio,
    required this.layoutClass,
  });

  final Size logicalSize;
  final double devicePixelRatio;
  final DeviceLayoutClass layoutClass;

  double get shortestSide =>
      logicalSize.shortestSide.isFinite ? logicalSize.shortestSide : 0;

  double get longestSide =>
      logicalSize.longestSide.isFinite ? logicalSize.longestSide : 0;

  bool get isMobile => layoutClass == DeviceLayoutClass.mobile;

  bool get isTablet => layoutClass == DeviceLayoutClass.tablet;

  bool get isDesktop => layoutClass == DeviceLayoutClass.desktop;

  bool get isTabletOrLarger => !isMobile;
}

class DeviceLayoutHelper {
  const DeviceLayoutHelper._();

  static const double mobileMaxShortestSide = 599;
  static const double tabletMaxShortestSide = 899;

  static DeviceLayout fromContext(BuildContext context) {
    return current(logicalSize: MediaQuery.sizeOf(context));
  }

  static DeviceLayout current({ui.FlutterView? view, Size? logicalSize}) {
    final resolvedSize = logicalSize ?? _logicalSizeFromView(view);
    final dpr = logicalSize != null
        ? 1.0
        : view?.devicePixelRatio ?? _currentView()?.devicePixelRatio ?? 1;
    return DeviceLayout(
      logicalSize: resolvedSize,
      devicePixelRatio: dpr <= 0 ? 1 : dpr,
      layoutClass: classify(resolvedSize),
    );
  }

  static DeviceLayoutClass classify(Size logicalSize) {
    final shortestSide = logicalSize.shortestSide;
    if (shortestSide <= mobileMaxShortestSide) {
      return DeviceLayoutClass.mobile;
    }
    if (shortestSide <= tabletMaxShortestSide) {
      return DeviceLayoutClass.tablet;
    }
    return DeviceLayoutClass.desktop;
  }

  static Size _logicalSizeFromView(ui.FlutterView? view) {
    final resolvedView = view ?? _currentView();
    if (resolvedView == null) {
      return ui.PlatformDispatcher.instance.views.isEmpty
          ? Size.zero
          : ui.PlatformDispatcher.instance.views.first.physicalSize;
    }
    final dpr = resolvedView.devicePixelRatio <= 0
        ? 1.0
        : resolvedView.devicePixelRatio;
    return resolvedView.physicalSize / dpr;
  }

  static ui.FlutterView? _currentView() {
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    if (dispatcher.views.isEmpty) {
      return null;
    }
    return dispatcher.views.first;
  }
}
