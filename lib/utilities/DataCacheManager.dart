import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Localization.dart';

class DataCacheManager {

  static SharedPreferences? prefs;

  static bool showingPopup = false;

  static InterstitialAd? interstitialAd;
  static Languages language = Languages();
}