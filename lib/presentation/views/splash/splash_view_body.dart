import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webflex/core/constants.dart';
import 'package:webflex/core/navigator_handler.dart';
import 'package:webflex/presentation/views/webview/web_view.dart';

import '../../../core/widget_helper.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _lineAnimation;
  late Animation<double> _smallCircleOpacity;

  @override
  void initState() {
    super.initState();
    initAnimation();
  }

  void initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _lineAnimation = Tween<double>(
      begin: 0,
      end: 1000,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _smallCircleOpacity = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateAfterAnimation();
      }
    });

    _controller.forward();
  }

  Future<void> _navigateAfterAnimation() async {
    if (mounted) {
      NavigatorHandler.pushReplacement(WebView(url: Constants.baseUrl));
    }
  }

  @override
  void dispose() {
    _controller
      ..stop()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 50,
          child: AnimatedBuilder(
            animation: _lineAnimation,
            builder: (context, child) {
              return Container(
                height: _lineAnimation.value,
                width: 4,
                color: Colors.white,
              );
            },
          ),
        ),

        // big circle at middle of screen
        Column(
          children: [
            const Spacer(),
            Center(child: WidgetHelper.buildCircle(50, 'splash.title'.tr())),
            const Spacer(),
          ],
        ),

        // small circle at end of screen
        Positioned(
          bottom: -50,
          child: FadeTransition(
            opacity: _smallCircleOpacity,
            child: WidgetHelper.buildCircle(40, null),
          ),
        ),
      ],
    );
  }
}
