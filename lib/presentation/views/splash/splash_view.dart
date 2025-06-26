import 'package:flutter/material.dart';
import 'package:webflex/core/widget_helper.dart';

class AnimatedScreen extends StatefulWidget {
  const AnimatedScreen({super.key});

  @override
  State<AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen>
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
      duration: const Duration(seconds: 3),
    );

    _lineAnimation = Tween<double>(
      begin: 0,
      end: 1000,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _smallCircleOpacity = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3D62),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // line between big circle and small circle
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 50,
              child: AnimatedBuilder(
                animation: _lineAnimation,
                builder: (context, child) {
                  return Container(
                    height: _lineAnimation.value,
                    width: 2,
                    color: Colors.white,
                  );
                },
              ),
            ),

            // big circle at middle of screen
            Column(
              children: [
                const Spacer(),
                Center(child: WidgetHelper.buildCircle(50, 'إشتري')),
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
        ),
      ),
    );
  }
}
