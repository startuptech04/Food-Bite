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

class CompleteDiningBookingRequestModel {
  String? bookingId;
  String? vendorId;
  double? itemTotal;
  double? itemDiscount;
  double? couponDiscount;
  double? billTotal;

  CompleteDiningBookingRequestModel({
    this.bookingId,
    this.vendorId,
    this.itemTotal,
    this.itemDiscount,
    this.couponDiscount,
    this.billTotal,
  });

  CompleteDiningBookingRequestModel.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    vendorId = json['vendorId'];
    itemTotal = json['itemTotal'];
    itemDiscount = json['itemDiscount'];
    couponDiscount = json['couponDiscount'];
    billTotal = json['billTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookingId'] = bookingId;
    data['vendorId'] = vendorId;
    data['itemTotal'] = itemTotal;
    data['itemDiscount'] = itemDiscount;
    data['couponDiscount'] = couponDiscount;
    data['billTotal'] = billTotal;
    return data;
  }
}
