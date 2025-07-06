import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:webflex/core/style/app_theme.dart';
import 'package:webflex/multi_provider.dart';
import 'package:webflex/presentation/providers/ad_provider.dart';

import 'core/constants.dart';
import 'presentation/views/splash/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance.initialize();
  await EasyLocalization.ensureInitialized();

  runApp(
    GenerateMultiProviders(
      child: EasyLocalization(
        supportedLocales: Constants.langs,
        path: 'assets/translations',
        fallbackLocale: Constants.langs[1],
        startLocale: Constants.langs.first,
        child: const WebFlexApp(),
      ),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
    _initializeAds();
  }

  Future<void> _initializeAds() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final provider = Provider.of<AdProvider>(context, listen: false);
    provider.initializeAdds();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final provider = Provider.of<AdProvider>(context, listen: false);

    switch (state) {
      case AppLifecycleState.resumed:
        provider.handleAppResumed();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        provider.handleAppPaused();
        break;
      case AppLifecycleState.detached:
        provider.handleAppClosed();
        break;
      case AppLifecycleState.hidden:
        // Handle the new hidden state (added in Flutter 3.x)
        provider.handleAppPaused(); // Treat hidden same as paused
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      navigatorKey: navigatorKey,
      home: const SplashView(),
    );
  }
}
