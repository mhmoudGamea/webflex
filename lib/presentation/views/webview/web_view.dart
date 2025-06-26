import 'package:flutter/material.dart';
import 'package:webflex/core/style/app_colors.dart';
import 'package:webflex/presentation/views/webview/web_view_body.dart';
import 'package:webflex/presentation/widgets/custom_app_bar.dart';

class WebView extends StatelessWidget {
  final String url;
  const WebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        bgColor: AppColors.primaryColor,
        centerTitle: true,
        showToolBar: false,
      ),

      body: WebViewBody(url: url),
    );
  }
}
