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

class PosPlaceOrderRequestModel {
  String? restaurant;
  String? paymentMode;
  String? customerType;
  String? customerName;
  String? customerCountryCode;
  String? customerMobileNumber;
  String? cartItemRaw;
  String? discountType;
  double? discountAmount;
  double? foodServiceCharge;
  double? serviceCharge;
  double? packageCharge;
  double? packageChargeTax;
  double? extraCharge;

  PosPlaceOrderRequestModel({
    this.restaurant,
    this.paymentMode,
    this.customerType,
    this.customerName,
    this.customerCountryCode,
    this.customerMobileNumber,
    this.cartItemRaw,
    this.discountType,
    this.discountAmount,
    this.foodServiceCharge,
    this.serviceCharge,
    this.packageCharge,
    this.packageChargeTax,
    this.extraCharge,
  });

  PosPlaceOrderRequestModel.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'];
    paymentMode = json['paymentMode'];
    customerType = json['customerType'];
    customerName = json['customerName'];
    customerCountryCode = json['customerCountryCode'];
    customerMobileNumber = json['customerMobileNumber'];
    cartItemRaw = json['cartItemRaw'];
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
    data['paymentMode'] = paymentMode;
    data['customerType'] = customerType;
    data['customerName'] = customerName;
    data['customerCountryCode'] = customerCountryCode;
    data['customerMobileNumber'] = customerMobileNumber;
    data['cartItemRaw'] = cartItemRaw;
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
