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
  String get introKey => '_intro';
  String get businessEmail => '_businessEmail';
  String get businessMobile => '_businessMobile';
  String get companyNameKey => '_companyName';
  String get currencySymbolKey => '_currencySymbol';
  String get currencySide => '_currencySide';
  String get mediaUrl => '_mediaUrl';
  String get defaultLanguage => '_defaultLanguage';
  String get defaultCountryCode => '_defaultCountryCode';
  String get isDark => '_isDark';
  String get driverLatitude => '_driverLatitude';
  String get driverLongitude => '_driverLongitude';
  String get driverLoginWith => '_driverLoginWith';
  String get driverResetPasswordWith => '_driverResetPasswordWith';
  String get selfRegistration => '_selfRegistration';
  String get socialAppleSignIn => '_socialAppleSignIn';
  String get socialGoogleSignIn => '_socialGoogleSignIn';
  String get googleOAuthClientId => '_googleOAuthClientId';
  String get googleOAuthServerId => '_googleOAuthServerId';
  String get socialFacebookSignIn => '_socialFacebookSignIn';
  String get isGoogleLoggedIn => '_isGoogleLoggedIn';
  String get isFacebookLoggedIn => '_isFacebookLoggedIn';

  //// Notification Keys ////
  String get notificationBell => '_notificationBell';
  // String get newOrderId => '_newOrderId';
  String get orderNotificationList => '_orderNotificationList';
  //// Notification Keys ////

  String get appLogo => '_appLogo';
}

class AuthKeys {
  const AuthKeys();
  String get uid => '_uid';
  String get authToken => '_authToken';
  String get authRefreshToken => '_authRefreshToken';
  String get driverFirstName => '_driverFirstName';
  String get driverLastName => '_driverLastName';
  String get driverCover => '_driverCover';
  String get driverEmail => '_driverEmail';
  String get driverRole => '_driverRole';
  String get userEmail => '_userEmail';
  String get userCountryCode => '_userCountryCode';
  String get userMobile => '_userMobile';
}
