import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webflex/core/category_model.dart';
import 'package:webflex/core/constants.dart';
import 'package:webflex/presentation/providers/language_provider.dart';

class WebViewProvider with ChangeNotifier {
  bool _isLoading = true;
  String _htmlContent = '';
  final List<String> _navigationStack = [];
  String _currentUrl = '';
  bool _isLocalContent = false;

  bool get isLoading => _isLoading;
  String get htmlContent => _htmlContent;
  String get currentUrl => _currentUrl;
  bool get canGoBack => _navigationStack.length > 1;
  bool get isLocalContent => _isLocalContent;

  Future<void> loadContent(String content, {bool isLocal = false}) async {
    try {
      _isLoading = true;
      _isLocalContent = isLocal;
      notifyListeners();

      if (isLocal) {
        // Load from assets
        _htmlContent = await rootBundle.loadString(content);
        log('Loaded local HTML file: $content');
      } else {
        // Set as URL
        _htmlContent = '';
        _currentUrl = content;
        log('Set URL: $content');
      }

      if (_navigationStack.isEmpty || _navigationStack.last != content) {
        _navigationStack.add(content);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log('Error loading content: $e');
      _isLoading = false;
      notifyListeners();
      throw Exception("Failed to load content: $e");
    }
  }

  Future<void> loadInitialContent(
    String initialContent, {
    bool isLocal = false,
  }) async {
    _navigationStack.clear();
    await loadContent(initialContent, isLocal: isLocal);
  }

  Future<void> handleBack() async {
    if (_navigationStack.length > 1) {
      _navigationStack.removeLast();
      final previousContent = _navigationStack.last;
      await loadContent(previousContent, isLocal: _isLocalContent);
    }
  }

  Future<void> handleCategoryTapping(
    CategoryModel? category,
    BuildContext context,
  ) async {
    if (category == null) return;
    log('Selected: ${category.title}');

    switch (category.category) {
      case Category.moreApps:
        await launchThirdPartyUrl(Constants.moreAppsUrl);
        break;
      case Category.privacyPolicy:
        final isArabic = context.read<LanguageProvider>().isArabic();
        await loadContent(
          isArabic
              ? Constants.privacyAndPolicyUrlAr
              : Constants.privacyAndPolicyUrlEn,
          isLocal: true,
        );
        break;
      case Category.rateTheApp:
        final packageInfo = await PackageInfo.fromPlatform();
        log('package name => ${packageInfo.packageName}');
        await launchThirdPartyUrl(
          '${Constants.appRateUrl}${packageInfo.packageName}',
        );
        break;
      case Category.changeLanguage:
        final prefs = await SharedPreferences.getInstance();
        final lang = prefs.getString(Constants.languageKey) ?? 'ar';
        log('my lang => $lang');
        context.read<LanguageProvider>().changeLocalLanguage(
          languageCode: lang == 'ar' ? 'en' : 'ar',
        );
        break;
    }
  }

  Future<void> launchThirdPartyUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
