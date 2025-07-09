import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webflex/presentation/providers/ad_provider.dart';
import 'package:webflex/presentation/providers/web_view_provider.dart';

class WebViewBody extends StatefulWidget {
  const WebViewBody({super.key});

  @override
  State<WebViewBody> createState() => _WebViewBodyState();
}

class _WebViewBodyState extends State<WebViewBody> {
  late final WebViewController _controller;
  late final AdProvider _adProvider;
  bool _webViewInitialized = false;
  String? _lastLoadedHtml;

  @override
  void initState() {
    super.initState();
    _adProvider = Provider.of<AdProvider>(context, listen: false);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadInitialWebView();
      _adProvider.loadBannerAd();
      _adProvider.loadInterstitialAd();
    });
  }

  Future<void> _loadInitialWebView() async {
    final webProvider = Provider.of<WebViewProvider>(context, listen: false);

    if (webProvider.htmlContent.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      await _loadInitialWebView();
      return;
    }

    await _controller.loadHtmlString(webProvider.htmlContent);
    _lastLoadedHtml = webProvider.htmlContent;

    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (_) => _updateLoading(true),
        onProgress: (progress) {
          if (progress == 100) _updateLoading(false);
        },
        onPageFinished: (_) => _updateLoading(false),
        onNavigationRequest: (request) => NavigationDecision.prevent,
      ),
    );

    if (mounted) {
      setState(() => _webViewInitialized = true);
    }
  }

  void _updateLoading(bool loading) {
    if (mounted) {
      Provider.of<WebViewProvider>(context, listen: false).setLoading(loading);
    }
  }

  @override
  Widget build(BuildContext context) {
    final webProvider = Provider.of<WebViewProvider>(context, listen: false);

    if (_webViewInitialized &&
        webProvider.htmlContent.isNotEmpty &&
        _lastLoadedHtml != webProvider.htmlContent) {
      _lastLoadedHtml = webProvider.htmlContent;
      _controller.loadHtmlString(webProvider.htmlContent);
    }

    if (!_webViewInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<AdProvider>(
      builder: (context, adProvider, child) {
        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (webProvider.isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
            if (adProvider.isBannerAdLoaded && adProvider.bannerAd != null)
              SafeArea(
                child: SizedBox(
                  height: adProvider.bannerAd!.size.height.toDouble(),
                  width: double.infinity,
                  child: AdWidget(ad: adProvider.bannerAd!),
                ),
              ),
          ],
        );
      },
    );
  }
}
