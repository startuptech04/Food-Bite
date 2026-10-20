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
  static IconsURL iconsURL = const IconsURL();
  static LocalURL localURL = const LocalURL();
  static NotificationAssetSound notificationAssetSound = const NotificationAssetSound();
}

class ImageURL {
  const ImageURL();

  String get notificationPermission => 'assets/images/permission/notification.png';
  String get bluetoothPermission => 'assets/images/permission/bluetooth.png';
  String get cameraPermission => 'assets/images/permission/camera.png';
  String get locationPermission => 'assets/images/permission/location.png';

  String get googleSocialLogin => 'assets/images/other/google.png';
  String get appleSocialLogin => 'assets/images/other/apple.png';
  String get facebookSocialLogin => 'assets/images/other/facebook.png';
  String get placeholderImage => 'assets/images/other/placeholder.jpeg';

  String get bottomTabMenu => 'assets/images/tabs/menu.png';
  String get bottomTabBusiness => 'assets/images/tabs/business.png';
  String get bottomTabOrder => 'assets/images/tabs/order.png';
  String get bottomTabPos => 'assets/images/tabs/pos.png';
  String get bottomTabAccount => 'assets/images/tabs/account.png';

  String get foodVegType => 'assets/images/other/veg.png';
  String get foodNonVegType => 'assets/images/other/nonveg.png';
  String get foodVeganType => 'assets/images/other/vegan.png';

  String get errorNotFound => 'assets/images/error/404.png';
  String get errorInternet => 'assets/images/error/internetfailed.png';
  String get errorMaintenance => 'assets/images/error/maintenance.png';
  String get errorServer => 'assets/images/error/server.png';

  String get homeEmpty => 'assets/images/other/home-empty.png';
  String get cartEmpty => 'assets/images/other/empty-cart.png';

  String get foodInstruction => 'assets/images/other/food-instruction.png';

  String get normalErrorIcon => 'assets/images/other/normal-error-icon.png';
  String get unAuthorizedErrorIcon => 'assets/images/other/unauthorized-error-icon.png';

  String get successIcon => 'assets/images/other/success-icon.png';
  String get forceUpdateIcon => 'assets/images/other/force-update.png';

  String get locationPin => 'assets/images/other/location-pin.png';

  String get walletImage => 'assets/images/other/wallet.png';
  String get cashInHandImage => 'assets/images/other/cash_in_hand.png';

  String get moneyDeposite => 'assets/images/other/deposite.png';
  String get moneyWithdrawal => 'assets/images/other/withdrawal.png';

  String get withdrawalCreated => 'assets/images/other/withdrawal-created.png';
  String get withdrawalRejected => 'assets/images/other/withdrawal-rejected.png';
  String get withdrawalAccepted => 'assets/images/other/withdrawal-accepted.png';

  String get offerTag => 'assets/images/other/offer.png';

  String get posCashPayment => 'assets/images/other/pos-cash-payment.png';
  String get posOnlinePayment => 'assets/images/other/pos-online-payment.png';

  String get subscriptionPermission => 'assets/images/other/subscription-permission.png';
  String get subscriptionNoPermission => 'assets/images/other/subscription-no-permission.png';

  String get registerRequestSaved => 'assets/images/other/register-request-saved.png';

  String get invoicePrint => 'assets/images/other/invoice-logo.png';

  String get splashIcon => 'assets/images/other/splash_icon.png';
}

class IconsURL {
  const IconsURL();

  String get billDeliveryIcon => 'assets/images/other/bill-delivery.png';
  String get billDiscountIcon => 'assets/images/other/bill-discount.png';
  String get billItemTotalIcon => 'assets/images/other/bill-item-total.png';
  String get billPackageIcon => 'assets/images/other/bill-package.png';
  String get billTaxIcon => 'assets/images/other/bill-tax.png';
}

class NotificationAssetSound {
  const NotificationAssetSound();

  String get sound1 => 'assets/sounds/alert1.mp3';
  String get sound2 => 'assets/sounds/alert2.mp3';
  String get sound3 => 'assets/sounds/alert3.mp3';
  String get sound4 => 'assets/sounds/alert4.mp3';
  String get sound5 => 'assets/sounds/alert5.mp3';
  String get sound6 => 'assets/sounds/alert6.mp3';
  String get sound7 => 'assets/sounds/alert7.mp3';
  String get sound8 => 'assets/sounds/alert8.mp3';
  String get sound9 => 'assets/sounds/alert9.mp3';
  String get sound10 => 'assets/sounds/alert10.mp3';
  String get sound11 => 'assets/sounds/alert11.mp3';
  String get sound12 => 'assets/sounds/alert12.mp3';
  String get sound13 => 'assets/sounds/alert13.mp3';
  String get sound14 => 'assets/sounds/alert14.mp3';
  String get sound15 => 'assets/sounds/alert15.mp3';
  String get sound16 => 'assets/sounds/alert16.mp3';
}

class LocalURL {
  const LocalURL();
  String get countryCodeList => 'assets/jsons/countryCodes.json';
}

class SysFlags {
  static const String c1 = "RJ-FDR-LIB-9X7A-ECIT-VA";
  static const String c2 = "FDR-LIB-RJ-2025";
  static const int m1 = 0x2A + 0x19;
}
