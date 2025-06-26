import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenerateMultiProviders extends StatelessWidget {
  final Widget child;
  const GenerateMultiProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [], child: child);
  }
}
