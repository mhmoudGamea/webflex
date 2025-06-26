import 'package:flutter/material.dart';

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

  Widget buildCircle(double radius, String? text) {
    return CircleAvatar(
      radius: radius,

      backgroundColor: Colors.white,
      child: text != null
          ? Text(
              text,
              style: TextStyle(
                color: const Color(0xFF0A3D62),
                fontSize: radius / 2,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3D62),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // الخط الواصل من الدايرة الكبيرة لآخر الشاشة
            Positioned(
              top:
                  MediaQuery.of(context).size.height / 2 -
                  50, // نص الشاشة - نص قطر الدايرة الكبيرة
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

            // العمود اللي فيه الدايرتين
            Column(
              children: [
                const Spacer(),
                Center(child: buildCircle(50, 'إشتري')),
                const Spacer(),
              ],
            ),

            // الدايرة الصغيرة فوق نهاية الشاشة بنصها
            Positioned(
              bottom: -50,
              child: FadeTransition(
                opacity: _smallCircleOpacity,
                child: buildCircle(40, null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
