import 'package:flutter/material.dart';
import '../../../core/style/app_colors.dart';
import '../../widgets/custom_app_bar.dart';
import 'splash_view_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CustomAppBar(showToolBar: false),
      body: SafeArea(child: SplashViewBody()),
    );
  }
}
