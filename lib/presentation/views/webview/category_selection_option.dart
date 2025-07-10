import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webflex/core/category_model.dart';
import 'package:webflex/core/constants.dart';
import 'package:webflex/core/style/app_colors.dart';
import 'package:webflex/presentation/providers/language_provider.dart';

class CategorySelectionOption extends StatelessWidget {
  final Function(CategoryModel? category) onChanged;
  const CategorySelectionOption({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    log('kkk => ${Constants.shouldShowLanguage}');
    return Consumer<LanguageProvider>(
      builder: (context, value, child) {
        return DropdownMenu<CategoryModel>(
          width: 200,
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.white),
            elevation: WidgetStateProperty.all(2),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
          leadingIcon: null,
          trailingIcon: const Icon(Icons.menu_rounded, color: Colors.white),
          selectedTrailingIcon: const Icon(
            Icons.menu_rounded,
            color: Colors.white,
          ),

          onSelected: onChanged,
          dropdownMenuEntries: List.generate(
            Constants.shouldShowLanguage ? 4 : 3,
            (index) => DropdownMenuEntry<CategoryModel>(
              value: CategoryModel.categories[index],
              label: CategoryModel.categories[index].title.tr(),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                  AppColors.primaryColor,
                ),
              ),
              leadingIcon: Icon(
                CategoryModel.categories[index].icon,
                color: CategoryModel.categories[index].color,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}
