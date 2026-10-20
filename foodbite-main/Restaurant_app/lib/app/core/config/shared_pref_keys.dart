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
  String get defaultCountryCode => '_defaultCountryCode';
  String get mediaUrl => '_mediaUrl';
  String get restaurantLoginWith => '_restaurantLoginWith';
  String get restaurantResetPasswordWith => '_restaurantResetPasswordWith';
  String get selfRegistration => '_selfRegistration';
  String get socialAppleSignIn => '_socialAppleSignIn';
  String get socialGoogleSignIn => '_socialGoogleSignIn';
  String get googleOAuthClientId => '_googleOAuthClientId';
  String get googleOAuthServerId => '_googleOAuthServerId';
  String get socialFacebookSignIn => '_socialFacebookSignIn';
  String get isGoogleLoggedIn => '_isGoogleLoggedIn';
  String get isFacebookLoggedIn => '_isFacebookLoggedIn';
  String get defaultLanguage => '_defaultLanguage';
  String get isDark => '_isDark';

  //// Notification Keys ////
  String get notificationBell => '_notificationBell';
  String get newOrderId => '_newOrderId';
  String get orderNotificationList => '_orderNotificationList';
  //// Notification Keys ////

  //// POS Keys ////
  String get savedInCart => '_posCart';
  //// POS Keys ////
  String get appLogo => '_appLogo';
}

class AuthKeys {
  const AuthKeys();
  String get uid => '_uid';
  String get authToken => '_authToken';
  String get authRefreshToken => '_authRefreshToken';
  String get userFirstName => '_userFirstName';
  String get userLastName => '_userLastName';
  String get userCover => '_userCover';
  String get authRole => '_authRole';
  String get vendorBusinessType => '_vendorBusinessType';
  String get vendorId => '_vendorId';
  String get vendorPOS => '_vendorPOS';
  String get vendorOwnDriver => '_vendorOwnDriver';
  String get vendorPromote => '_vendorPromote';
  String get vendorCustomCategory => '_vendorCustomCategory';
  String get vendorMultiOutlet => '_vendorMultiOutlet';
  String get vendorPreBooking => '_vendorPreBooking';
  String get vendorTableOrder => '_vendorTableOrder';
  String get vendorTiffinSubscription => '_vendorTiffinSubscription';
  String get vendorOwnWaiter => '_vendorOwnWaiter';
  String get vendorOwnKitchen => '_vendorOwnKitchen';
  String get vendorName => '_vendorName';
  String get vendorAddress => '_vendorAddress';
  String get vendorRating => '_vendorRating';
  String get vendorLogo => '_vendorLogo';
  String get userEmail => '_userEmail';
  String get userCountryCode => '_userCountryCode';
  String get userMobile => '_userMobile';
}
