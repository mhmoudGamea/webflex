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
  String? _lastLoadedContent;
  bool _lastWasLocal = false;

  @override
  void initState() {
    super.initState();
    _adProvider = Provider.of<AdProvider>(context, listen: false);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => _updateLoading(true),
          onProgress: (progress) {
            if (progress == 100) _updateLoading(false);
          },
          onPageFinished: (_) => _updateLoading(false),
        ),
      );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadInitialWebView();
      _adProvider.loadBannerAd();
      _adProvider.loadInterstitialAd();
    });
  }

  Future<void> _loadInitialWebView() async {
    final webProvider = Provider.of<WebViewProvider>(context, listen: false);

    if (webProvider.isLocalContent && webProvider.htmlContent.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      await _loadInitialWebView();
      return;
    }

    await _loadWebViewContent(webProvider);
    _lastLoadedContent = webProvider.isLocalContent
        ? webProvider.htmlContent
        : webProvider.currentUrl;
    _lastWasLocal = webProvider.isLocalContent;

    if (mounted) {
      setState(() => _webViewInitialized = true);
    }
  }

  Future<void> _loadWebViewContent(WebViewProvider webProvider) async {
    if (webProvider.isLocalContent) {
      await _controller.loadHtmlString(webProvider.htmlContent);
    } else {
      await _controller.loadRequest(Uri.parse(webProvider.currentUrl));
    }
  }

  void _updateLoading(bool loading) {
    if (mounted) {
      Provider.of<WebViewProvider>(context, listen: false).setLoading(loading);
    }
  }

  @override
  Widget build(BuildContext context) {
    final webProvider = Provider.of<WebViewProvider>(context);

    if (_webViewInitialized) {
      final currentContent = webProvider.isLocalContent
          ? webProvider.htmlContent
          : webProvider.currentUrl;

      if (currentContent.isNotEmpty &&
          (_lastLoadedContent != currentContent ||
              _lastWasLocal != webProvider.isLocalContent)) {
        _lastLoadedContent = currentContent;
        _lastWasLocal = webProvider.isLocalContent;
        _loadWebViewContent(webProvider);
      }
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
