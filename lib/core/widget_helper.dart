import 'package:flutter/material.dart';
import 'package:webflex/core/style/app_colors.dart';
import 'package:webflex/core/style/app_styles.dart';

abstract class WidgetHelper {
  WidgetHelper._();
  static Widget buildCircle(double radius, String? text) {
    return CircleAvatar(
      radius: radius,

      backgroundColor: Colors.white,
      child: text != null
          ? Text(
              text,
              style: AppStyles.lg16Bold.copyWith(color: AppColors.primaryColor),
            )
          : null,
    );
  }
}
