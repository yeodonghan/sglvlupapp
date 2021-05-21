import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111"; //testing
      //return "ca-app-pub-6681122776256103/2194342285"; //release
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716"; //testing
      //return "ca-app-pub-6681122776256103/8132246436";   //release
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712"; //testing
      //return "ca-app-pub-6681122776256103/2549565505";  //release
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910"; //testing
      //return "ca-app-pub-6681122776256103/9502180182";  //release
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
