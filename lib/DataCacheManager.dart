class DataCacheManager {
  var showingPopup = false;
  static final DataCacheManager _singleton = DataCacheManager._internal();
  factory DataCacheManager() {
    return _singleton;
  }
  DataCacheManager._internal();
}