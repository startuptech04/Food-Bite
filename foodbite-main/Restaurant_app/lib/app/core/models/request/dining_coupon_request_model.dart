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

import 'package:vendor/app/core/models/translations/dining_coupon_translation_form.dart';

class DiningCouponRequestModel {
  String? name;
  String? code;
  String? limitSameUser;
  String? start;
  String? expires;
  String? discountType;
  String? minDiscount;
  String? maxDiscount;
  String? restaurantId;
  String? createdById;
  String? availability;
  String? preBookingChargeRequired;
  String? preBookingChargeAmount;
  List<DiningCouponFormTranslations>? translations;

  DiningCouponRequestModel({
    this.name,
    this.code,
    this.limitSameUser,
    this.start,
    this.expires,
    this.discountType,
    this.minDiscount,
    this.maxDiscount,
    this.restaurantId,
    this.createdById,
    this.availability,
    this.preBookingChargeRequired,
    this.preBookingChargeAmount,
    this.translations,
  });

  DiningCouponRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    limitSameUser = json['limitSameUser'];
    start = json['start'];
    expires = json['expires'];
    discountType = json['discountType'];
    minDiscount = json['minDiscount'];
    maxDiscount = json['maxDiscount'];
    restaurantId = json['restaurantId'];
    createdById = json['createdById'];
    availability = json['availability'];
    preBookingChargeRequired = json['preBookingChargeRequired'];
    preBookingChargeAmount = json['preBookingChargeAmount'];
    if (json['translations'] != null) {
      translations = <DiningCouponFormTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(DiningCouponFormTranslations.fromJson(v));
      });
    } else {
      translations = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['limitSameUser'] = limitSameUser;
    data['start'] = start;
    data['expires'] = expires;
    data['discountType'] = discountType;
    data['minDiscount'] = minDiscount;
    data['maxDiscount'] = maxDiscount;
    data['restaurantId'] = restaurantId;
    data['createdById'] = createdById;
    data['availability'] = availability;
    data['preBookingChargeRequired'] = preBookingChargeRequired;
    data['preBookingChargeAmount'] = preBookingChargeAmount;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
