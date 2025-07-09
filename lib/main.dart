import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webflex/app.dart';
import 'package:webflex/multi_provider.dart';
import 'package:webflex/presentation/providers/ad_provider.dart';

import 'core/constants.dart';
import 'presentation/providers/rating_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await EasyLocalization.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedLanguage = prefs.getString(Constants.languageKey);
  RatingManager.resetSession();

  runApp(
    GenerateMultiProviders(
      child: EasyLocalization(
        supportedLocales: Constants.langs,
        path: 'assets/translations',
        fallbackLocale: Constants.langs[1],
        startLocale: savedLanguage != null
            ? Locale(savedLanguage)
            : Constants.langs.first,
        saveLocale: true,
        child: const WebFlexApp(),
      ),
    ),
  );
}

class WebFlexApp extends StatefulWidget {
  const WebFlexApp({super.key});

  @override
  State<WebFlexApp> createState() => _WebFlexAppState();
}

class _WebFlexAppState extends State<WebFlexApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final adProvider = Provider.of<AdProvider>(context, listen: false);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        adProvider.handleAppPaused();
        break;
      case AppLifecycleState.resumed:
        adProvider.handleAppResumed();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return App();
  }
}
