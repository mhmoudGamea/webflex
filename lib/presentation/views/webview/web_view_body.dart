import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/style/app_colors.dart';
import '../../providers/web_view_provider.dart';

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
    final provider = Provider.of<WebViewProvider>(context, listen: false);

    _controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            provider.setLoading(true);
          },
          onProgress: (int progress) {
            if (progress == 100) {
              provider.setLoading(false);
            }
          },
          onPageFinished: (String url) {
            provider.setLoading(false);
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
            WebViewWidget(controller: _controller),
            if (provider.isLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
          ],
        );
      },
    );
  }
}
