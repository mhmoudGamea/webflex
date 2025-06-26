import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webflex/core/style/app_theme.dart';

import 'core/constants.dart';
import 'presentation/views/splash/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: Constants.langs,
      path: 'assets/translations',
      fallbackLocale: Constants.langs[1],
      startLocale: Constants.langs.first,
      child: WebFlex(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class WebFlex extends StatelessWidget {
  const WebFlex({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      navigatorKey: navigatorKey,
      home: SplashView(),
    );
  }
}
