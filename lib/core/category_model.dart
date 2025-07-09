import 'package:flutter/material.dart';

enum Category { moreApps, privacyPolicy, rateTheApp, changeLanguage }

class CategoryModel {
  final String title;
  final Category category;
  final IconData icon;
  final Color color;

  CategoryModel({
    required this.title,
    required this.category,
    required this.icon,
    this.color = Colors.white,
  });

  static List<CategoryModel> categories = [
    CategoryModel(
      title: 'category.changeLanguage',
      category: Category.changeLanguage,
      icon: Icons.language,
      color: Colors.black,
    ),
    CategoryModel(
      title: 'category.rateTheApp',
      category: Category.rateTheApp,
      icon: Icons.star,
      color: Colors.amber,
    ),
    CategoryModel(
      title: 'category.moreApps',
      category: Category.moreApps,
      icon: Icons.apps,
      color: Colors.green,
    ),
    CategoryModel(
      title: 'category.privacyPolicy',
      category: Category.privacyPolicy,
      icon: Icons.privacy_tip,
      color: Colors.blue,
    ),
  ];
}
