import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app.dart';
import '../../core/constants.dart';

class LanguageProvider with ChangeNotifier {
  bool isArabic() => navigatorKey.currentContext?.locale.languageCode == 'ar';

  void changeLocalLanguage({required String languageCode}) async {
    navigatorKey.currentContext?.setLocale(Locale(languageCode));
    notifyListeners();
    await saveLanguage(languageCode: languageCode);
  }

  Future<void> saveLanguage({required String languageCode}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.languageKey, languageCode);
  }
}
