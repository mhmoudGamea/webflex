import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webflex/presentation/providers/ad_manager.dart';

class AdProvider with ChangeNotifier {
  // Banner Ad
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  BannerAd? get bannerAd => _bannerAd;
  bool get isBannerAdLoaded => _isBannerAdLoaded;

  // Interstitial Ad
  InterstitialAd? _interstitialAd;
  bool _isInterstitialReady = false;
  DateTime? _lastInterstitialShowTime;

  // App Open Ad
  AppOpenAd? _appOpenAd;
  bool _isAppOpenReady = false;
  bool _isAppInBackground = false;

  // Banner Ad Logic
  Future<void> loadBannerAd() async {
    if (_isBannerAdLoaded) return;

    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isBannerAdLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
          _isBannerAdLoaded = false;
          notifyListeners();
          Future.delayed(const Duration(seconds: 30), loadBannerAd);
        },
      ),
    );
    await _bannerAd?.load();
  }

  // Interstitial Ad Logic
  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: AdManager.interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          _setupInterstitialCallbacks(ad);
          notifyListeners();
          _showInterstitialAd();
        },
        onAdFailedToLoad: (error) {
          _isInterstitialReady = false;
          Future.delayed(const Duration(minutes: 1), loadInterstitialAd);
        },
      ),
    );
  }

  void _setupInterstitialCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isInterstitialReady = false;
        _lastInterstitialShowTime = DateTime.now();
        // loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _isInterstitialReady = false;
        loadInterstitialAd();
      },
    );
  }

  Future<void> _showInterstitialAd() async {
    // Don't show if already showing or not ready
    if (!_isInterstitialReady) {
      await loadInterstitialAd();
      return;
    }

    // Prevent too frequent shows
    if (_lastInterstitialShowTime != null &&
        DateTime.now().difference(_lastInterstitialShowTime!) <
            const Duration(minutes: 1)) {
      return;
    }

    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _isInterstitialReady = false;
      _lastInterstitialShowTime = DateTime.now();
    }
  }

  // App Open Ad Logic
  Future<void> _loadAppOpenAd() async {
    await AppOpenAd.load(
      adUnitId: AdManager.appOpenAdId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAppOpenReady = true;
          _setupAppOpenCallbacks(ad);
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          _isAppOpenReady = false;
          Future.delayed(const Duration(minutes: 1), _loadAppOpenAd);
        },
      ),
    );
  }

  void _setupAppOpenCallbacks(AppOpenAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isAppOpenReady = false;
        _loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _isAppOpenReady = false;
        _loadAppOpenAd();
      },
    );
  }

  Future<void> showAppOpenAd() async {
    if (!_isAppOpenReady) {
      await _loadAppOpenAd();
      return;
    }

    if (_appOpenAd != null) {
      _appOpenAd!.show();
      _isAppOpenReady = false;
    }
  }

  // Lifecycle Handling
  void handleAppPaused() {
    _isAppInBackground = true;
    _loadAppOpenAd(); // Prepare for next resume
  }

  Future<void> handleAppResumed() async {
    if (_isAppInBackground) {
      _isAppInBackground = false;
      await showAppOpenAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _appOpenAd?.dispose();
    super.dispose();
  }
}
