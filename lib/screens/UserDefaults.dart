import 'package:QR_Scanner/utilities/DataCacheManager.dart';

class UserDefaults {
  static String get email  {
    return DataCacheManager.prefs?.getString("emailUserDefault") ?? "";
  }
  static set email(String email)  {
    DataCacheManager.prefs?.setString("emailUserDefault", email);
  }

  static int get count  {
    return DataCacheManager.prefs?.getInt("count") ?? 0;
  }
  static set count(int count)  {
    DataCacheManager.prefs?.setInt("count", count);
  }

  static String get picURL  {
    return DataCacheManager.prefs?.getString("picURL") ?? "";
  }
  static set primaryColor(String primaryColor)  {
    DataCacheManager.prefs?.setString("primaryColor", primaryColor);
  }

  static String get primaryColor  {
    return DataCacheManager.prefs?.getString("primaryColor") ?? "";
  }

  static set picURL(String picURL)  {
    DataCacheManager.prefs?.setString("picURL", picURL);
  }
  static String get userName  {
    return DataCacheManager.prefs?.getString("userNameUserDefault") ?? "";
  }
  static set userName(String userName)  {
    DataCacheManager.prefs?.setString("userNameUserDefault", userName);
  }
  static String get lastSyncAt  {
    return DataCacheManager.prefs?.getString("lastSyncAt") ?? "";
  }
  static set lastSyncAt(String lastSyncAt)  {
    DataCacheManager.prefs?.setString("lastSyncAt", lastSyncAt);
  }

  static bool get isSoundON  {
    return DataCacheManager.prefs?.getBool("isSoundON") ?? true;
  }
  static set isSoundON(bool isSoundON)  {
    DataCacheManager.prefs?.setBool("isSoundON", isSoundON);
  }

  static bool get isVibrationON  {
    return DataCacheManager.prefs?.getBool("isVibrationON") ?? true;
  }
  static set isVibrationON(bool isVibrationON)  {
    DataCacheManager.prefs?.setBool("isVibrationON", isVibrationON);
  }



}