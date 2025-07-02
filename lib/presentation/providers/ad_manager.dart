class AdManager {
  AdManager._();
  static bool isTest = true;

  static String bannerId = isTest
      ? "ca-app-pub-3940256099942544/9214589741"
      : "ca-app-pub-1664480318651497/2154897148";

  static String interstitialId = isTest
      ? "ca-app-pub-3940256099942544/1033173712"
      : "ca-app-pub-1664480318651497/2625670434";

  static String appOpenAdId = isTest
      ? "ca-app-pub-3940256099942544/9257395921"
      : "ca-app-pub-1664480318651497/1674152049";
}
