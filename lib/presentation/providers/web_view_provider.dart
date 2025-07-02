import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_manager.dart';

class WebViewProvider with ChangeNotifier {
  // html configuration
  bool _isLoading = true;
  String _htmlContent = '';

  bool get isLoading => _isLoading;
  String get htmlContent => _htmlContent;

  Future<void> loadHtmlFromAssets(String path) async {
    try {
      _isLoading = true;
      notifyListeners();

      _htmlContent = await rootBundle.loadString(path);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Failed to load HTML: $e");
    }
  }

  // banner configuration
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  BannerAd? get bannerAd => _bannerAd;
  bool get isBannerAdLoaded => _isBannerAdLoaded;

  Future<void> loadBannerAd() async {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isBannerAdLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerAdLoaded = false;
          ad.dispose();
          _bannerAd = null;
          notifyListeners();
        },
      ),
    );
    await _bannerAd?.load();
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  // interstitial configuration
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  bool get isInterstitialAdLoaded => _isInterstitialAdLoaded;

  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: AdManager.interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          notifyListeners();

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdLoaded = false;
              notifyListeners();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdLoaded = false;
              notifyListeners();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialAdLoaded = false;
          notifyListeners();
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      loadInterstitialAd();
    }
  }

  // App Open Ad configuration
  AppOpenAd? _appOpenAd;
  bool _isAppOpenAdLoaded = false;
  bool _isAppOpenAdShowing = false;

  bool get isAppOpenAdLoaded => _isAppOpenAdLoaded;
  bool get isAppOpenAdShowing => _isAppOpenAdShowing;

  Future<void> loadAppOpenAd() async {
    await AppOpenAd.load(
      adUnitId: AdManager.appOpenAdId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAppOpenAdLoaded = true;
          notifyListeners();

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _disposeAppOpenAd();
              loadAppOpenAd(); // إعادة تحميل إعلان جديد
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _disposeAppOpenAd();
              loadAppOpenAd(); // إعادة تحميل إعلان جديد
            },
          );
        },
        onAdFailedToLoad: (error) {
          _disposeAppOpenAd();
          Future.delayed(const Duration(minutes: 30), loadAppOpenAd);
        },
      ),
    );
  }

  void showAppOpenAd() {
    if (_appOpenAd != null && !_isAppOpenAdShowing) {
      _isAppOpenAdShowing = true;
      notifyListeners();
      _appOpenAd!.show();
    }
  }

  void _disposeAppOpenAd() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _isAppOpenAdLoaded = false;
    _isAppOpenAdShowing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _appOpenAd?.dispose();
    super.dispose();
  }
}
