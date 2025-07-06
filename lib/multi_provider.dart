import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/providers/ad_provider.dart';
import 'presentation/providers/web_view_provider.dart';

class GenerateMultiProviders extends StatelessWidget {
  final Widget child;
  const GenerateMultiProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WebViewProvider()),
        ChangeNotifierProvider(create: (_) => AdProvider()),
      ],
      child: child,
    );
  }
}
