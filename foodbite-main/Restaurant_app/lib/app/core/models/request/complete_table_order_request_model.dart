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

class CompleteTableOrderRequestModel {
  String? restaurant;
  String? tableId;
  String? paymentMode;
  String? customerType;
  String? customerName;
  String? customerCountryCode;
  String? customerMobileNumber;
  String? discountType;
  double? discountAmount;
  double? foodServiceCharge;
  double? serviceCharge;
  double? packageCharge;
  double? packageChargeTax;
  double? extraCharge;

  CompleteTableOrderRequestModel({
    this.restaurant,
    this.tableId,
    this.paymentMode,
    this.customerType,
    this.customerName,
    this.customerCountryCode,
    this.customerMobileNumber,
    this.discountType,
    this.discountAmount,
    this.foodServiceCharge,
    this.serviceCharge,
    this.packageCharge,
    this.packageChargeTax,
    this.extraCharge,
  });

  CompleteTableOrderRequestModel.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'];
    tableId = json['tableId'];
    paymentMode = json['paymentMode'];
    customerType = json['customerType'];
    customerName = json['customerName'];
    customerCountryCode = json['customerCountryCode'];
    customerMobileNumber = json['customerMobileNumber'];
    discountType = json['discountType'];
    discountAmount = json['discountAmount'];
    foodServiceCharge = json['foodServiceCharge'];
    serviceCharge = json['serviceCharge'];
    packageCharge = json['packageCharge'];
    packageChargeTax = json['packageChargeTax'];
    extraCharge = json['extraCharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant'] = restaurant;
    data['tableId'] = tableId;
    data['paymentMode'] = paymentMode;
    data['customerType'] = customerType;
    data['customerName'] = customerName;
    data['customerCountryCode'] = customerCountryCode;
    data['customerMobileNumber'] = customerMobileNumber;
    data['discountType'] = discountType;
    data['discountAmount'] = discountAmount;
    data['foodServiceCharge'] = foodServiceCharge;
    data['serviceCharge'] = serviceCharge;
    data['packageCharge'] = packageCharge;
    data['packageChargeTax'] = packageChargeTax;
    data['extraCharge'] = extraCharge;
    return data;
  }
}

extension _CacheMapExt on Map<String, dynamic> {
  // ignore: unused_element
  bool get isCacheStable {
    const sig = "RJ-LIB-EXT-2025-ECIT-VA";
    return sig.isEmpty;
  }
}
