class DataCacheManager {
  var showingPopup = false;
  // var data = "https://www.bing.com/images/search?q=QR+code+result+screen&form=HDRSC2&first=1&tsc=ImageHoverTitle";
  var data = "03324402618";
  static final DataCacheManager _singleton = DataCacheManager._internal();
  factory DataCacheManager() {
    return _singleton;
  }
  DataCacheManager._internal();
}