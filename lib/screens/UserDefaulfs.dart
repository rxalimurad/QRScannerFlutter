import 'package:QR_Scanner/utilities/DataCacheManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDefaults {
  static String get email  {
    return DataCacheManager.prefs?.getString("emailUserDefault") ?? "";
  }
  static set email(String email)  {
    DataCacheManager.prefs?.setString("emailUserDefault", email);
  }

  static int get count  {
    return DataCacheManager.prefs?.getInt("countUserDefault") ?? 0;
  }
  static set count(int count)  {
    DataCacheManager.prefs?.setInt("countUserDefault", count);
  }

  static String get userName  {
    return DataCacheManager.prefs?.getString("userNameUserDefault") ?? "";
  }
  static set userName(String userName)  {
    DataCacheManager.prefs?.setString("userNameUserDefault", userName);
  }




}