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

part of 'account_bloc.dart';

enum AccountStatus { initial, logoutStart, logoutSuccess, logoutFailed }

extension AccountStatusX on AccountStatus {
  bool get isInitial => this == AccountStatus.initial;
  bool get isLogoutStart => this == AccountStatus.logoutStart;
  bool get isLogoutSuccess => this == AccountStatus.logoutSuccess;
  bool get isLogoutFailed => this == AccountStatus.logoutFailed;
}

final class AccountState {
  final String appLogo;
  final String currentVersion;
  final String name;
  final String address;
  final String logo;
  final bool haveSubscriptionPackage;
  final bool haveDeliveryMan;
  final bool havePreBookingPermission;
  final bool haveTiffinSubscription;
  final bool haveWaiterPermission;
  final bool haveKitchenPermission;
  final bool haveOutletPermission;
  final bool tableOrderPermission;
  final String locale;
  final bool lightMode;
  final bool isGoogleLoggedIn;
  final bool isFacebookLoggedIn;
  final AccountStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const AccountState({
    this.appLogo = '',
    this.currentVersion = '',
    this.name = '',
    this.address = '',
    this.logo = '',
    this.haveSubscriptionPackage = false,
    this.haveDeliveryMan = false,
    this.havePreBookingPermission = false,
    this.haveTiffinSubscription = false,
    this.haveWaiterPermission = false,
    this.haveKitchenPermission = false,
    this.haveOutletPermission = false,
    this.tableOrderPermission = false,
    this.locale = '',
    this.lightMode = false,
    this.isGoogleLoggedIn = false,
    this.isFacebookLoggedIn = false,
    this.status = AccountStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  AccountState copyWith({
    String? appLogo,
    String? currentVersion,
    String? name,
    String? address,
    String? logo,
    bool? haveSubscriptionPackage,
    bool? haveDeliveryMan,
    bool? havePreBookingPermission,
    bool? haveTiffinSubscription,
    bool? haveWaiterPermission,
    bool? haveKitchenPermission,
    bool? haveOutletPermission,
    bool? tableOrderPermission,
    String? locale,
    bool? lightMode,
    bool? isGoogleLoggedIn,
    bool? isFacebookLoggedIn,
    AccountStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return AccountState(
      appLogo: appLogo ?? this.appLogo,
      currentVersion: currentVersion ?? this.currentVersion,
      name: name ?? this.name,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      haveSubscriptionPackage: haveSubscriptionPackage ?? this.haveSubscriptionPackage,
      haveDeliveryMan: haveDeliveryMan ?? this.haveDeliveryMan,
      havePreBookingPermission: havePreBookingPermission ?? this.havePreBookingPermission,
      haveTiffinSubscription: haveTiffinSubscription ?? this.haveTiffinSubscription,
      haveWaiterPermission: haveWaiterPermission ?? this.haveWaiterPermission,
      haveKitchenPermission: haveKitchenPermission ?? this.haveKitchenPermission,
      haveOutletPermission: haveOutletPermission ?? this.haveOutletPermission,
      tableOrderPermission: tableOrderPermission ?? this.tableOrderPermission,
      locale: locale ?? this.locale,
      lightMode: lightMode ?? this.lightMode,
      isGoogleLoggedIn: isGoogleLoggedIn ?? this.isGoogleLoggedIn,
      isFacebookLoggedIn: isFacebookLoggedIn ?? this.isFacebookLoggedIn,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
