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

class RejectDiningBookingRequestModel {
  String? bookingId;
  String? vendorId;
  String? reasonId;

  RejectDiningBookingRequestModel({this.bookingId, this.vendorId, this.reasonId});

  RejectDiningBookingRequestModel.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    vendorId = json['vendorId'];
    reasonId = json['reasonId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookingId'] = bookingId;
    data['vendorId'] = vendorId;
    data['reasonId'] = reasonId;
    return data;
  }
}
