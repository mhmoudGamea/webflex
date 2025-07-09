import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app.dart';
import '../../core/style/app_colors.dart';
import '../../core/style/app_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double? fontSize;
  final Color? fontColor;
  final bool? showBackArrow;
  final bool? centerTitle;
  final List<Widget>? actions;
  final bool? showToolBar;
  final double? elevation;
  final Color? bgColor;
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  const CustomAppBar({
    super.key,
    this.title,
    this.fontSize,
    this.fontColor,
    this.showBackArrow,
    this.centerTitle,
    this.actions,
    this.showToolBar,
    this.elevation,
    this.bgColor,
    this.systemUiOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: bgColor ?? AppColors.primaryColor,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle:
          systemUiOverlayStyle ??
          SystemUiOverlayStyle(
            statusBarColor: AppColors.primaryColor,
            statusBarIconBrightness: Brightness.light,
          ),
      title: Text(
        title ?? '',
        style: AppStyles.lg16Bold.copyWith(color: fontColor ?? AppColors.white),
      ),
      centerTitle: centerTitle ?? false,
      actions: actions,
      automaticallyImplyLeading: showBackArrow ?? true,
    );
  }

  @override
  Size get preferredSize => Size(
    MediaQuery.of(navigatorKey.currentState!.context).size.width,
    showToolBar == true ? 60 : 0,
  );
}
