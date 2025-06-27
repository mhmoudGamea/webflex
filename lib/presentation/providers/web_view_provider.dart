import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WebViewProvider with ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _htmlContent = '';

  String get htmlContent => _htmlContent;

  Future<void> loadHtmlFromAssets(String path) async {
    try {
      _isLoading = true;
      notifyListeners();

      _htmlContent = await rootBundle.loadString(path);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("Failed to load HTML: $e");
    }
  }
}
