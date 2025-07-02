import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:webflex/core/style/app_theme.dart';
import 'package:webflex/multi_provider.dart';

import 'core/constants.dart';
import 'presentation/providers/web_view_provider.dart';
import 'presentation/views/splash/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  await MobileAds.instance.initialize();
  await EasyLocalization.ensureInitialized();
  runApp(
    GenerateMultiProviders(
      child: EasyLocalization(
        supportedLocales: Constants.langs,
        path: 'assets/translations',
        fallbackLocale: Constants.langs[1],
        startLocale: Constants.langs.first,
        child: WebFlex(),
      ),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class WebFlex extends StatefulWidget {
  const WebFlex({super.key});

  @override
  State<WebFlex> createState() => _WebFlexState();
}

class _WebFlexState extends State<WebFlex> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final provider = Provider.of<WebViewProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );
      if (provider.isAppOpenAdLoaded) {
        provider.showAppOpenAd();
      }
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
