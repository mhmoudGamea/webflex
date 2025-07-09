import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webflex/core/category_model.dart';
import 'package:webflex/core/constants.dart';
import 'package:webflex/core/style/app_colors.dart';
import 'package:webflex/presentation/providers/language_provider.dart';

import '../../../core/style/app_styles.dart';

class CategorySelectionOption extends StatelessWidget {
  final Function(CategoryModel? category) onChanged;
  const CategorySelectionOption({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, value, child) => DropdownButton(
        padding: EdgeInsets.symmetric(horizontal: 10),
        borderRadius: BorderRadius.circular(5),
        dropdownColor: AppColors.white,
        icon: const Icon(Icons.menu_rounded, color: AppColors.white, size: 25),
        underline: SizedBox.shrink(),

        items: List.generate(
          Constants.numberOfInitialHtml == 2 ? 4 : 3,
          (index) => DropdownMenuItem(
            value: CategoryModel.categories[index],
            child: Row(
              spacing: 5,
              children: [
                Icon(
                  CategoryModel.categories[index].icon,
                  color: CategoryModel.categories[index].color,
                  size: 20,
                ),
                Text(
                  CategoryModel.categories[index].title.tr(),
                  style: AppStyles.md14Regular.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
/*


CategoryModel.categories
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(e.icon, color: AppColors.primaryColor, size: 20),
                    Text(
                      e.title.tr(),
                      style: AppStyles.md14Regular.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList()
*/