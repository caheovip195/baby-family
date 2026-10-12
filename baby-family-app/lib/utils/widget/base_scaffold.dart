import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

import 'loading_progress.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    this.isLoading = false,
    this.appBar,
    this.bottomNavigationBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.useSafeArea = false,
    this.onAreaTap,
    this.backgroundColor,
    this.canPop = true,
    this.banner,
    this.extendBody = false,
    this.onPopInvokedWithResult,
  });

  final PreferredSizeWidget? appBar;
  final bool isLoading;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool useSafeArea;
  final VoidCallback? onAreaTap;

  /// Mặc định nền kem `kColorBgFFFBF7`; màn Papa & Mama dùng `kColorUs50F6F2FC`.
  final Color? backgroundColor;
  final bool canPop;
  final Widget? banner;
  final bool extendBody;
  final PopInvokedWithResultCallback<Object?>? onPopInvokedWithResult;

  @override
  Widget build(BuildContext context) {
    if (useSafeArea) {
      return SafeArea(child: _buildBody(context));
    }
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: onAreaTap ?? () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                body: body,
                appBar: appBar,
                backgroundColor: AppColors.resolve(
                  context,
                  backgroundColor ?? kColorBgFFFBF7,
                ),
                extendBody: extendBody,
                bottomNavigationBar: bottomNavigationBar,
                floatingActionButton: floatingActionButton,
                floatingActionButtonLocation: floatingActionButtonLocation,
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: ColoredBox(
                color: AppColors.resolve(context, kColorOverlay2E2A27Alpha48),
                child: const Center(
                  child: CircleLoadingProgress(
                    color: kColorWhite,
                    width: 3,
                    size: 32,
                  ),
                ),
              ),
            ),
          ?banner,
        ],
      ),
    );
  }
}
