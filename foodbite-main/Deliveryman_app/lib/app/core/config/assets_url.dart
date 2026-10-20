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
  static GifURL gifURL = const GifURL();
  static NotificationAssetSound notificationAssetSound = const NotificationAssetSound();
}

class ImageURL {
  const ImageURL();
  String get appNotificationPermission => 'assets/images/permission/notification.png';
  String get appCameraPermission => 'assets/images/permission/camera.png';
  String get appLocationPermission => 'assets/images/permission/location.png';

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

  String get referralModal => 'assets/images/other/referral.png';

  String get locationMap => 'assets/images/other/location-map.png';
  String get locationPermission => 'assets/images/other/location-permission.png';
  String get locationPin => 'assets/images/other/location-pin.png';
  String get unauthorized => 'assets/images/other/unauthorized.png';

  String get homeEmpty => 'assets/images/other/home-empty.png';
  String get cartEmpty => 'assets/images/other/empty-cart.png';

  String get offerTag => 'assets/images/other/offer.png';

  String get deliveryGratitude => 'assets/images/other/gratitude.png';

  String get addressHome => 'assets/images/other/address-home.png';
  String get addressHotel => 'assets/images/other/address-hotel.png';
  String get addressWork => 'assets/images/other/address-work.png';
  String get addressOther => 'assets/images/other/address-other.png';

  String get checkoutDelivery => 'assets/images/other/checkout-delivery.png';
  String get checkoutTakeaway => 'assets/images/other/checkout-takeaway.png';

  String get couponDefault => 'assets/images/other/coupon-percentage.png';
  String get couponRestaurant => 'assets/images/other/coupon-restaurant.png';
  String get couponFreeDelivery => 'assets/images/other/coupon-free-delivery.png';
  String get couponFirstOrder => 'assets/images/other/coupon-first-order.png';
  String get couponLoyality => 'assets/images/other/coupon-coin.png';
  String get couponBOGO => 'assets/images/other/coupon-buy-one-get-one-free.png';

  String get notDelivered => 'assets/images/other/not_delivered.png';

  String get orderPick => 'assets/images/other/order-pick.png';
  String get orderDrop => 'assets/images/other/order-drop.png';

  String get normalErrorIcon => 'assets/images/other/normal-error-icon.png';
  String get unAuthorizedErrorIcon => 'assets/images/other/unauthorized-error-icon.png';

  String get successIcon => 'assets/images/other/success-icon.png';
  String get forceUpdateIcon => 'assets/images/other/force-update.png';
  String get backgroundLocationIcon => 'assets/images/permission/background-location.png';

  String get walletImage => 'assets/images/other/wallet.png';
  String get cashInHandImage => 'assets/images/other/cash_in_hand.png';

  String get moneyDeposite => 'assets/images/other/deposite.png';
  String get moneyWithdrawal => 'assets/images/other/withdrawal.png';

  String get withdrawalCreated => 'assets/images/other/withdrawal-created.png';
  String get withdrawalRejected => 'assets/images/other/withdrawal-rejected.png';
  String get withdrawalAccepted => 'assets/images/other/withdrawal-accepted.png';

  String get registerRequestSaved => 'assets/images/other/register-request-saved.png';
  String get splashIcon => 'assets/images/other/splash_icon.png';
}

class LocalURL {
  const LocalURL();
  String get countryCodeList => 'assets/jsons/countryCodes.json';
}

class IconsURL {
  const IconsURL();
  String get bottomTabFeed => 'assets/images/tabs/feeds.png';
  String get bottomTabPayout => 'assets/images/tabs/payouts.png';
  String get bottomTabDeposite => 'assets/images/tabs/deposite.png';
  String get bottomTabAnalytics => 'assets/images/tabs/analysis.png';
  String get bottomTabAccount => 'assets/images/tabs/account.png';

  String get priceTag => 'assets/images/icons/cash.png';
  String get timeTag => 'assets/images/icons/clock.png';
  String get starTag => 'assets/images/icons/star.png';
  String get locationMarkerTag => 'assets/images/icons/location.png';

  String get favouriteFull => 'assets/images/icons/heart_full.png';
  String get favouriteEmpty => 'assets/images/icons/heart_empty.png';
  String get closeIcon => 'assets/images/icons/close.png';

  String get couponIcon => 'assets/images/icons/coupons.png';

  String get billIcon => 'assets/images/other/bill.png';
  String get phoneCallIcon => 'assets/images/other/phone-call.png';

  String get billDeliveryIcon => 'assets/images/other/bill-delivery.png';
  String get billDiscountIcon => 'assets/images/other/bill-discount.png';
  String get billItemTotalIcon => 'assets/images/other/bill-item-total.png';
  String get billPackageIcon => 'assets/images/other/bill-package.png';
  String get billTaxIcon => 'assets/images/other/bill-tax.png';

  String get driverMarker => 'assets/images/icons/driver_marker.png';
  String get restaurantMarker => 'assets/images/icons/restaurant_marker.png';
  String get userMarker => 'assets/images/icons/user_marker.png';
}

class GifURL {
  const GifURL();

  String get radarGif => 'assets/images/gif/radar.gif';
  String get offlineGif => 'assets/images/gif/offline.gif';
  String get blocked => 'assets/images/gif/blocked.gif';
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

class SysFlags {
  static const String c1 = "RJ-FDR-LIB-9X7A-ECIT-DA";
  static const String c2 = "FDR-LIB-RJ-2025";
  static const int m1 = 0x2A + 0x19;
}
