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

class SharedPreferencesKey {
  static PublicKeys publicKeys = const PublicKeys();
  static AuthKeys authKeys = const AuthKeys();
}

class PublicKeys {
  const PublicKeys();
  String get businessEmail => '_businessEmail';
  String get businessMobile => '_businessMobile';
  String get companyNameKey => '_companyName';
  String get currencySymbolKey => '_currencySymbol';
  String get currencySide => '_currencySide';
  String get mediaUrl => '_mediaUrl';
  String get defaultLanguage => '_defaultLanguage';
  String get defaultCountryCode => '_defaultCountryCode';
  String get isDark => '_isDark';
  String get ownerLoginWith => '_ownerLoginWith';
  String get ownerResetPasswordWith => '_ownerResetPasswordWith';
  String get socialAppleSignIn => '_socialAppleSignIn';
  String get socialGoogleSignIn => '_socialGoogleSignIn';
  String get googleOAuthClientId => '_googleOAuthClientId';
  String get googleOAuthServerId => '_googleOAuthServerId';
  String get socialFacebookSignIn => '_socialFacebookSignIn';
  String get isGoogleLoggedIn => '_isGoogleLoggedIn';
  String get isFacebookLoggedIn => '_isFacebookLoggedIn';
  String get androidUrl => '_androidUrl';
  String get androidVersion => '_androidVersion';
  String get iosUrl => '_iosUrl';
  String get iosVersion => '_iosVersion';
  String get appLogo => '_appLogo';

  //// Notification Keys ////
  String get notificationBell => '_notificationBell';
}

class AuthKeys {
  const AuthKeys();
  String get uid => '_uid';
  String get authToken => '_authToken';
  String get authRefreshToken => '_authRefreshToken';
  String get kitchenFirstName => '_kitchenFirstName';
  String get kitchenLastName => '_kitchenLastName';
  String get kitchenMobile => '_kitchenMobile';
  String get kitchenCover => '_kitchenCover';
  String get kitchenEmail => '_kitchenEmail';
  String get kitchenRole => '_kitchenRole';
  String get kitchenCountryCode => '_kitchenCountryCode';
  String get kitchenRestaurant => '_kitchenRestaurant';
}
