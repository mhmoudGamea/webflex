import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webflex/core/style/app_colors.dart';
import 'package:webflex/presentation/providers/language_provider.dart';

class RatingPopup extends StatelessWidget {
  final VoidCallback onRated;
  final VoidCallback onLater;
  final VoidCallback onNever;

  const RatingPopup({
    required this.onRated,
    required this.onLater,
    required this.onNever,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, value, child) {
        log(context.locale.languageCode.toString());
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 70),
          contentPadding: EdgeInsets.all(5),
          actionsPadding: EdgeInsets.only(right: 10, left: 10, top: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Text(
            'rate_app.title'.tr(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Icon(Icons.star, size: 25, color: Colors.amber),
                ),
              ),

              const SizedBox(height: 10),
              Text(
                'rate_app.message'.tr(),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: onLater,
                  child: Text(
                    'rate_app.later'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: onRated,
                  child: Text(
                    'rate_app.rate_now'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: onNever,
                child: Text(
                  'rate_app.never_show'.tr(),
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }
}
