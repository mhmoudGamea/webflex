import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:webflex/presentation/providers/ad_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../providers/web_view_provider.dart';

class WebViewBody extends StatefulWidget {
  final String htmlPath;
  const WebViewBody({super.key, required this.htmlPath});

  @override
  State<WebViewBody> createState() => _WebViewBodyState();
}

class _WebViewBodyState extends State<WebViewBody> {
  late final WebViewController _controller;
  late final WebViewProvider _webProvider;
  late final AdProvider _adProvider;

  @override
  void initState() {
    super.initState();
    _webProvider = Provider.of<WebViewProvider>(context, listen: false);
    _adProvider = Provider.of<AdProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHtmlContent();
      _adProvider.loadBannerAd();
      _adProvider.loadInterstitialAd();
    });
  }

  Future<void> _loadHtmlContent() async {
    await _webProvider.loadHtmlFromAssets(widget.htmlPath);
    _initWebViewController();
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..loadHtmlString(_webProvider.htmlContent)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => _webProvider.setLoading(true),
          onProgress: (progress) {
            if (progress == 100) _webProvider.setLoading(false);
          },
          onPageFinished: (_) => _webProvider.setLoading(false),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebViewProvider, AdProvider>(
      builder: (context, webProvider, adProvider, child) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (!webProvider.isLoading &&
                        webProvider.htmlContent.isNotEmpty)
                      WebViewWidget(controller: _controller),
                    if (webProvider.isLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
              if (adProvider.isBannerAdLoaded && adProvider.bannerAd != null)
                SafeArea(
                  child: Container(
                    height: adProvider.bannerAd!.size.height.toDouble(),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: AdWidget(ad: adProvider.bannerAd!),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
