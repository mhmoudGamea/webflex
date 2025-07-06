import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WebViewProvider with ChangeNotifier {
  // HTML Content
  bool _isLoading = true;
  String _htmlContent = '';

  bool get isLoading => _isLoading;
  String get htmlContent => _htmlContent;

  Future<void> loadHtmlFromAssets(String path) async {
    try {
      setLoading(true);
      _htmlContent = await rootBundle.loadString(path);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      throw Exception("Failed to load HTML: $e");
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
