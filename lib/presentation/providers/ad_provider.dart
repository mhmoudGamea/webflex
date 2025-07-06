import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webflex/presentation/providers/ad_manager.dart';

class AdProvider with ChangeNotifier {
  // Banner Ad
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
        onAdLoaded: (_) {
          _isBannerAdLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
          _isBannerAdLoaded = false;
          notifyListeners();
        },
      ),
    );
    await _bannerAd?.load();
  }

  // Interstitial & App Open Ads
  InterstitialAd? _interstitialAd;
  AppOpenAd? _appOpenAd;
  bool _isFirstLaunch = true;
  bool _isAppInBackground = false;
  bool _isInterstitialReady = false;
  bool _isAppOpenReady = false;

  bool get shouldShowInterstitial => _isFirstLaunch && _isInterstitialReady;
  bool get shouldShowAppOpen => _isAppInBackground && _isAppOpenReady;

  void initializeAdds() {
    _loadInterstitialAd();
    _loadAppOpenAd();
  }

  Future<void> _loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: AdManager.interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          _setupInterstitialCallbacks(ad);
          notifyListeners();

          log('is first launch inter => $_isFirstLaunch');

          if (_isFirstLaunch) {
            _showInterstitialAd();
            _isFirstLaunch = false;
          }
        },
        onAdFailedToLoad: (error) {
          _isInterstitialReady = false;
          _retryLoadInterstitial();
        },
      ),
    );
  }

  void _setupInterstitialCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isInterstitialReady = false;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _isInterstitialReady = false;
      },
    );
  }

  Future<void> _showInterstitialAd() async {
    if (_interstitialAd != null && _isInterstitialReady) {
      await _interstitialAd!.show();
      _isInterstitialReady = false;
    }
  }

  Future<void> _retryLoadInterstitial() async {
    await Future.delayed(const Duration(seconds: 10));
    _loadInterstitialAd();
  }

  // app open ad

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
          log('is first launch app => $_isFirstLaunch');

          if (!_isFirstLaunch) {
            showAppOpenAd();
          }
        },
        onAdFailedToLoad: (error) {
          _isAppOpenReady = false;
          _retryLoadAppOpen();
        },
      ),
    );
  }

  void _setupAppOpenCallbacks(AppOpenAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isAppOpenReady = false;
        // _loadAppOpenAd();
        _loadInterstitialAd().then((_) {
          if (_isInterstitialReady) {
            _showInterstitialAd();
          }
        });
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _isAppOpenReady = false;
        // _loadAppOpenAd();
      },
    );
  }

  Future<void> _retryLoadAppOpen() async {
    await Future.delayed(const Duration(seconds: 10));
    _loadAppOpenAd();
  }

  Future<void> showAppOpenAd() async {
    if (_appOpenAd != null && _isAppOpenReady) {
      await _appOpenAd!.show();
      _isAppOpenReady = false;
    }
  }

  // App Lifecycle
  void handleAppResumed() {
    if (_isAppInBackground) {
      _isAppInBackground = false;
      if (_isAppOpenReady) {
        showAppOpenAd();
      } else {
        _loadAppOpenAd();
      }
    }
  }

  void handleAppPaused() {
    _isAppInBackground = true;
    _loadAppOpenAd();
  }

  void handleAppClosed() {
    _isFirstLaunch = true;
    _isAppInBackground = false;
    _isInterstitialReady = false;
    _isAppOpenReady = false;
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
