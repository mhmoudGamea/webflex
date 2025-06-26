import 'package:flutter/material.dart';
import 'package:webflex/core/style/app_theme.dart';
import 'package:webflex/presentation/views/splash/splash_view.dart';

void main() {
  runApp(const WebView());
}

class WebView extends StatelessWidget {
  const WebView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,

      debugShowCheckedModeBanner: false,
      home: AnimatedScreen(),
    );
  }
}
