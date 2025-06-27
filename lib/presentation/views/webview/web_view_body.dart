import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../providers/web_view_provider.dart';

class WebViewBody extends StatefulWidget {
  final String htmlPath; // تغيير من `url` إلى `htmlPath` للإشارة إلى مسار الملف
  const WebViewBody({super.key, required this.htmlPath});

  @override
  State<WebViewBody> createState() => _WebViewBodyState();
}

class _WebViewBodyState extends State<WebViewBody> {
  late final WebViewController _controller;
  late final WebViewProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<WebViewProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHtmlContent();
    });
  }

  Future<void> _loadHtmlContent() async {
    await _provider.loadHtmlFromAssets(widget.htmlPath);
    _initWebViewController();
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..loadHtmlString(_provider.htmlContent)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            _provider.setLoading(true);
          },
          onProgress: (int progress) {
            if (progress == 100) {
              _provider.setLoading(false);
            }
          },
          onPageFinished: (String url) {
            _provider.setLoading(false);
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WebViewProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            if (!provider.isLoading && provider.htmlContent.isNotEmpty)
              WebViewWidget(controller: _controller),
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
