import 'package:shared_preferences/shared_preferences.dart';

class RatingManager {
  static const String _keyRatingStatus = 'rating_status'; // 'rated', 'never'
  static bool _showLater = true;

  static Future<bool> shouldShowRating() async {
    if (!_showLater) return false;

    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_keyRatingStatus)) return true;
    if (prefs.getString(_keyRatingStatus) == 'rated') return false;
    if (prefs.getString(_keyRatingStatus) == 'never') return false;

    return true;
  }

  static Future<void> setRatingStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRatingStatus, status);

    if (status == 'later') {
      _showLater = false;
    }
  }

  static void resetSession() {
    _showLater = true;
  }
}
