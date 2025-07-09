import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class RatingManager {
  static const String _keyRatingStatus =
      'rating_status'; // 'rated', 'later', 'never'
  // static const String _keySessionStartTime = 'session_start_time';

  // static Future<void> startNewSession() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt(
  //     _keySessionStartTime,
  //     DateTime.now().millisecondsSinceEpoch,
  //   );
  // }

  static Future<bool> shouldShowRating() async {
    final prefs = await SharedPreferences.getInstance();
    log('1');

    if (prefs.containsKey(_keyRatingStatus) == false) return true;

    log('2');

    // الحالات اللي ميظهرش فيها التقييم
    if (prefs.getString(_keyRatingStatus) == 'rated') return false;
    log('3');
    if (prefs.getString(_keyRatingStatus) == 'never') return false;
    log('4');
    return true;
  }

  static Future<void> setRatingStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRatingStatus, status);
  }
}
