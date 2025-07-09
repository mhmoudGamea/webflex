import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webflex/core/constants.dart';
import 'package:webflex/core/style/app_colors.dart';
import 'package:webflex/presentation/providers/language_provider.dart';
import 'package:webflex/presentation/views/webview/web_view_body.dart';
import 'package:webflex/presentation/widgets/custom_app_bar.dart';

import '../../providers/web_view_provider.dart';
import 'category_selection_option.dart';

class WebView extends StatelessWidget {
  const WebView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WebViewProvider>(context, listen: false);
    final lang = Provider.of<LanguageProvider>(context).isArabic();

    // Load initial content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadInitialContent(
        lang ? Constants.initialArUrl : Constants.initialEnUrl,
      );
    });

    return Consumer2<LanguageProvider, WebViewProvider>(
      builder: (context, lang, web, child) => Scaffold(
        appBar: CustomAppBar(
          bgColor: AppColors.primaryColor,
          centerTitle: true,
          title: 'app.title'.tr(),
          showToolBar: true,
          fontColor: AppColors.white,
          actions: [
            CategorySelectionOption(
              onChanged: (category) {
                provider.handleCategoryTapping(category, context);
              },
            ),
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (provider.canGoBack) {
              await provider.handleBack();
              return false;
            }
            return true;
          },
          child: WebViewBody(),
        ),
      ),
    );
  }
}
