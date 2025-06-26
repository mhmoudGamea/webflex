import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewBody extends StatefulWidget {
  final String url;
  const WebViewBody({super.key, required this.url});

  @override
  State<WebViewBody> createState() => _WebViewBodyState();
}

class _WebViewBodyState extends State<WebViewBody> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // عرض مؤشر التقدم إذا أردت
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
