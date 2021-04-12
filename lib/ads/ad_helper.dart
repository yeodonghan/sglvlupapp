import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6681122776256103/2194342285";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6681122776256103/8132246436";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6681122776256103/2549565505";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6681122776256103/9502180182";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

}