/*
 * FoodBite – Multi Restaurant Food Delivery App
 * (NodeJS, MongoDB, Angular & Flutter)
 *
 * Copyright © 2026 Elitecanyon InfoTech (https://www.elitecanyon.com/)
 * Licensed under the Envato Market License.
 *
 * Unauthorized redistribution, resale, or publication
 * of this source code on GitHub or any public repository
 * is strictly prohibited.
 *
 * This file may contain embedded identifiers and watermarks
 * for ownership verification and license enforcement.
 */

class AssetsUrl {
  static ImageURL imageURL = const ImageURL();
  static LocalURL localURL = const LocalURL();
  static IconsURL iconsURL = const IconsURL();
}

class ImageURL {
  const ImageURL();

  String get googleSocialLogin => 'assets/images/other/google.png';
  String get appleSocialLogin => 'assets/images/other/apple.png';
  String get facebookSocialLogin => 'assets/images/other/facebook.png';
  String get placeholderImage => 'assets/images/other/placeholder.jpeg';

  String get foodVegType => 'assets/images/other/veg.png';
  String get foodNonVegType => 'assets/images/other/nonveg.png';
  String get foodVeganType => 'assets/images/other/vegan.png';

  String get errorNotFound => 'assets/images/error/404.png';
  String get errorInternet => 'assets/images/error/internetfailed.png';
  String get errorMaintenance => 'assets/images/error/maintenance.png';
  String get errorServer => 'assets/images/error/server.png';

  String get unauthorized => 'assets/images/other/unauthorized.png';

  String get homeEmpty => 'assets/images/other/home-empty.png';
  String get cartEmpty => 'assets/images/other/empty-cart.png';
  String get pureVegImage => 'assets/images/other/pure-veg.png';

  String get normalErrorIcon => 'assets/images/other/normal-error-icon.png';
  String get unAuthorizedErrorIcon => 'assets/images/other/unauthorized-error-icon.png';

  String get successIcon => 'assets/images/other/success-icon.png';
  String get forceUpdateIcon => 'assets/images/other/force-update.png';

  String get offerTag => 'assets/images/other/offer.png';

  String get splashIcon => 'assets/images/other/splash_icon.png';
}

class LocalURL {
  const LocalURL();
  String get countryCodeList => 'assets/jsons/countryCodes.json';
}

class IconsURL {
  const IconsURL();
  String get bottomTabFood => 'assets/images/tabs/feeds.png';
  String get bottomTabOrders => 'assets/images/tabs/orders.png';
  String get bottomTabAccount => 'assets/images/tabs/account.png';
}

class SysFlags {
  static const String c1 = "RJ-FDR-LIB-9X7A-ECIT-WA";
  static const String c2 = "FDR-LIB-RJ-2025";
  static const int m1 = 0x2A + 0x19;
}
