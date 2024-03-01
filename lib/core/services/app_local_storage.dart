import 'package:shared_preferences/shared_preferences.dart';

class AppLocal {
  static String isDoctorImgUploadedKey = 'ISDOCTORIMGUPLOADED';
  static String isOnBoardingScreenSkipedKey = 'ISONBOARDINGSCREENSKIPED';
  static String isOnBoaringScreenEndedKey = 'ISONBOARDINGSCREENENDED';

  static cacheDataX(String key, value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      prefs.setString(key, value);
    }
  }

  static Future<dynamic> getCachedDataX(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }
}
