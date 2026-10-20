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

class CreateDiningBookingRequestModel {
  String? user;
  String? payment;
  String? restaurant;
  String? coupon;
  String? bookingDate;
  String? bookingSlot;
  int? guest;
  String? userName;
  int? userCountryCode;
  String? userContact;
  String? userEmail;
  String? specialRequest;
  String? campaignId;

  CreateDiningBookingRequestModel({
    this.user,
    this.payment,
    this.restaurant,
    this.coupon,
    this.bookingDate,
    this.bookingSlot,
    this.guest,
    this.userName,
    this.userCountryCode,
    this.userContact,
    this.userEmail,
    this.specialRequest,
    this.campaignId,
  });

  CreateDiningBookingRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    payment = json['payment'];
    restaurant = json['restaurant'];
    coupon = json['coupon'];
    bookingDate = json['bookingDate'];
    bookingSlot = json['bookingSlot'];
    guest = json['guest'];
    userName = json['userName'];
    userCountryCode = json['userCountryCode'];
    userContact = json['userContact'];
    userEmail = json['userEmail'];
    specialRequest = json['specialRequest'];
    campaignId = json['campaignId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['payment'] = payment;
    data['restaurant'] = restaurant;
    data['coupon'] = coupon;
    data['bookingDate'] = bookingDate;
    data['bookingSlot'] = bookingSlot;
    data['guest'] = guest;
    data['userName'] = userName;
    data['userCountryCode'] = userCountryCode;
    data['userContact'] = userContact;
    data['userEmail'] = userEmail;
    data['specialRequest'] = specialRequest;
    data['campaignId'] = campaignId;
    return data;
  }
}
