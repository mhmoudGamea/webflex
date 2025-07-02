import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/style/app_colors.dart';
import '../../providers/web_view_provider.dart';
import '../../widgets/custom_app_bar.dart';
import 'splash_view_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<WebViewProvider>(context, listen: false);
      provider.loadAppOpenAd();
    });

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CustomAppBar(showToolBar: false),
      body: SafeArea(child: SplashViewBody()),
    );
  }
}
