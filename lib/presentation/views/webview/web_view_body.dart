import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
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
  late final WebViewProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<WebViewProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHtmlContent();
      _provider.loadBannerAd();
      _provider.loadInterstitialAd();
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
    log("WebViewBody build");
    return Consumer<WebViewProvider>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.isInterstitialAdLoaded && !provider.isLoading) {
            provider.showInterstitialAd();
          }
        });

        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (!provider.isLoading && provider.htmlContent.isNotEmpty)
                      WebViewWidget(controller: _controller),
                    if (provider.isLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
              if (provider.isBannerAdLoaded && provider.bannerAd != null)
                Container(
                  height: provider.bannerAd!.size.height.toDouble(),
                  width: provider.bannerAd!.size.width.toDouble(),
                  alignment: Alignment.center,
                  child: AdWidget(ad: provider.bannerAd!),
                ),
            ],
          ),
        );
      },
    );
  }
}
