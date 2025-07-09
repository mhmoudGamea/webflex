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
  String _currentPath = '';

  bool get isLoading => _isLoading;
  String get htmlContent => _htmlContent;
  String get currentPath => _currentPath;
  bool get canGoBack => _navigationStack.length > 1;

  Future<void> loadHtmlFromAssets(String path) async {
    log('Loading file from: $path');
    try {
      _isLoading = true;
      notifyListeners();

      _htmlContent = await rootBundle.loadString(path);
      _currentPath = path;

      if (_navigationStack.isEmpty || _navigationStack.last != path) {
        _navigationStack.add(path);
      }

      _isLoading = false;
      notifyListeners();
      log('File loaded successfully');
    } catch (e) {
      log('Error loading file: $e');
      _isLoading = false;
      notifyListeners();
      throw Exception("Failed to load file: $e");
    }
  }

  Future<void> loadInitialContent(String initialPath) async {
    _navigationStack.clear();
    await loadHtmlFromAssets(initialPath);
  }

  Future<void> handleBack() async {
    if (_navigationStack.length > 1) {
      _navigationStack.removeLast();
      final previousPath = _navigationStack.last;
      await loadHtmlFromAssets(previousPath);
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
        await _launchUrl(Constants.moreAppsUrl);
        break;
      case Category.privacyPolicy:
        await loadHtmlFromAssets(Constants.privacyAndPolicyUrl);
        break;
      case Category.rateTheApp:
        final packageInfo = await PackageInfo.fromPlatform();
        log('package name => ${packageInfo.packageName}');
        await _launchUrl('${Constants.appRateUrl}${packageInfo.packageName}');
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

  Future<void> _launchUrl(String url) async {
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
