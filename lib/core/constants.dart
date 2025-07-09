import 'package:flutter/material.dart';

abstract class Constants {
  Constants._();
  // language
  static const List<Locale> _langs = [Locale('ar'), Locale('en')];

  static List<Locale> get langs => _langs;

  // safed language
  static const String languageKey = 'language';

  // initial url
  static const String initialArUrl = 'assets/html/law_firm_intro_ar.html';
  static const String initialEnUrl = 'assets/html/law_firm_intro_en.html';

  // just change this variable
  // if i have 1 html [en or ar] = 1
  // if you have both = 2
  static const int numberOfInitialHtml = 2;

  // more apps url
  static const String moreAppsUrl =
      'https://play.google.com/store/apps/developer?id=EmyPro';

  // privacy and policy url
  static const String privacyAndPolicyUrl = 'assets/html/privacy_policy.html';

  // current app url in app store
  static const String appRateUrl =
      'https://play.google.com/store/apps/details?id=';
}
