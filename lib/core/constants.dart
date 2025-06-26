import 'package:flutter/material.dart';

abstract class Constants {
  Constants._();
  // language
  static const List<Locale> _langs = [Locale('ar'), Locale('en')];

  static List<Locale> get langs => _langs;

  // baseUrl
  static const String baseUrl = 'https://aldolartoday.com/';
}
