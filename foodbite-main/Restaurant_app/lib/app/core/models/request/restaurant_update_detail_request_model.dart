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

import 'package:vendor/app/core/models/translations/edit_restaurant_form_translation.dart';

class RestaurantDetailUpdateRequestModel {
  String? logo;
  String? cover;
  String? name;
  String? address;
  String? shortDescription;
  String? cuisine;
  String? type;
  String? facility;
  bool? homeDelivery;
  bool? takeaway;
  bool? scheduleOrder;
  String? license;
  String? licenseId;
  String? minOrderAmount;
  String? dishPriceForTwo;
  String? deliveryTime;
  String? socialFacebook;
  String? socialInstagram;
  String? socialX;
  String? socialYoutube;
  String? socialLinkedIn;
  String? socialPinterest;
  List<EditRestaurantFormTranslations>? translations;

  RestaurantDetailUpdateRequestModel({
    this.logo,
    this.cover,
    this.name,
    this.address,
    this.shortDescription,
    this.cuisine,
    this.type,
    this.facility,
    this.homeDelivery,
    this.takeaway,
    this.scheduleOrder,
    this.license,
    this.licenseId,
    this.minOrderAmount,
    this.dishPriceForTwo,
    this.deliveryTime,
    this.socialFacebook,
    this.socialInstagram,
    this.socialX,
    this.socialYoutube,
    this.socialLinkedIn,
    this.socialPinterest,
    this.translations,
  });

  RestaurantDetailUpdateRequestModel.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    cover = json['cover'];
    name = json['name'];
    address = json['address'];
    shortDescription = json['shortDescription'];
    cuisine = json['cuisine'];
    type = json['type'];
    facility = json['facility'];
    homeDelivery = json['homeDelivery'];
    takeaway = json['takeaway'];
    scheduleOrder = json['scheduleOrder'];
    license = json['license'];
    licenseId = json['licenseId'];
    minOrderAmount = json['minOrderAmount'];
    dishPriceForTwo = json['dishPriceForTwo'];
    deliveryTime = json['deliveryTime'];
    if (json['socialFacebook'] != null && json['socialFacebook'] != '') {
      socialFacebook = json['socialFacebook'];
    } else {
      socialFacebook = '';
    }
    if (json['socialInstagram'] != null && json['socialInstagram'] != '') {
      socialInstagram = json['socialInstagram'];
    } else {
      socialInstagram = '';
    }
    if (json['socialX'] != null && json['socialX'] != '') {
      socialX = json['socialX'];
    } else {
      socialX = '';
    }
    if (json['socialYoutube'] != null && json['socialYoutube'] != '') {
      socialYoutube = json['socialYoutube'];
    } else {
      socialYoutube = '';
    }
    if (json['socialLinkedIn'] != null && json['socialLinkedIn'] != '') {
      socialLinkedIn = json['socialLinkedIn'];
    } else {
      socialLinkedIn = '';
    }
    if (json['socialPinterest'] != null && json['socialPinterest'] != '') {
      socialPinterest = json['socialPinterest'];
    } else {
      socialPinterest = '';
    }
    if (json['translations'] != null) {
      translations = <EditRestaurantFormTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(EditRestaurantFormTranslations.fromJson(v));
      });
    } else {
      translations = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['logo'] = logo;
    data['cover'] = cover;
    data['name'] = name;
    data['address'] = address;
    data['shortDescription'] = shortDescription;
    data['cuisine'] = cuisine;
    data['type'] = type;
    data['facility'] = facility;
    data['homeDelivery'] = homeDelivery;
    data['takeaway'] = takeaway;
    data['scheduleOrder'] = scheduleOrder;
    data['license'] = license;
    data['licenseId'] = licenseId;
    data['minOrderAmount'] = minOrderAmount;
    data['dishPriceForTwo'] = dishPriceForTwo;
    data['deliveryTime'] = deliveryTime;
    data['socialFacebook'] = socialFacebook;
    data['socialInstagram'] = socialInstagram;
    data['socialX'] = socialX;
    data['socialYoutube'] = socialYoutube;
    data['socialLinkedIn'] = socialLinkedIn;
    data['socialPinterest'] = socialPinterest;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
