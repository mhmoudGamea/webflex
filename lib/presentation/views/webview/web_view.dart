import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:webflex/core/constants.dart';
import 'package:webflex/core/style/app_colors.dart';
import 'package:webflex/presentation/providers/language_provider.dart';
import 'package:webflex/presentation/views/webview/web_view_body.dart';
import 'package:webflex/presentation/widgets/custom_app_bar.dart';

import '../../providers/rating_manager.dart';
import '../../providers/web_view_provider.dart';
import '../../widgets/rating_popup.dart';
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
            SizedBox(
              width: 50,
              child: CategorySelectionOption(
                onChanged: (category) {
                  provider.handleCategoryTapping(category, context);
                },
              ),
            ),
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (provider.canGoBack) {
              await provider.handleBack();
              return false;
            }

            final showRate = await RatingManager.shouldShowRating();
            if (showRate) {
              showRatingDialog(context);
              return false;
            }
            return true;
          },
          child: WebViewBody(),
        ),
      ),
    );
  }

  Future<void> showRatingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => RatingPopup(
        onRated: () async {
          await RatingManager.setRatingStatus('rated');
          final packageInfo = await PackageInfo.fromPlatform();
          context.read<WebViewProvider>().launchThirdPartyUrl(
            '${Constants.appRateUrl}${packageInfo.packageName}',
          );
          Navigator.pop(context);
        },
        onLater: () {
          RatingManager.setRatingStatus('later');
          Navigator.pop(context);
        },
        onNever: () async {
          await RatingManager.setRatingStatus('never');
          Navigator.pop(context);
        },
      ),
    );
  }
}
