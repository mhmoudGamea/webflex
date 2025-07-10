import 'package:flutter/material.dart';

abstract class Constants {
  Constants._();
  // language
  static const List<Locale> _langs = [Locale('ar'), Locale('en')];

  static List<Locale> get langs => _langs;

  // safed language
  static const String languageKey = 'language';

  // initial html url
  static const String initialArUrl = 'assets/html/law_firm_intro_ar.html';
  static const String initialEnUrl = ''; //assets/html/law_firm_intro_en.html
  // initial url
  static const String initialUrl = 'https://aldolartoday.com/';

  // is Locale file [true if html]? or [false if url]?
  static const bool isLocale = true;

  static const bool shouldShowLanguage =
      initialArUrl != '' && initialEnUrl != '' && initialUrl == '';

  // more apps url
  static const String moreAppsUrl =
      'https://play.google.com/store/apps/developer?id=EmyPro';

  // privacy and policy url
  static const String privacyAndPolicyUrlAr =
      'assets/html/privacy_policy_ar.html';
  static const String privacyAndPolicyUrlEn =
      ''; //assets/html/privacy_policy_en.html

  // current app url in app store
  static const String appRateUrl =
      'https://play.google.com/store/apps/details?id=';
}
