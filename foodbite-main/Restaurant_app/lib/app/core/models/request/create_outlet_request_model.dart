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

import 'package:vendor/app/core/models/translations/outlet_form_translation.dart';

class CreateOutletRequestModel {
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? countryCode;
  String? mobile;
  String? managerId;
  String? name;
  String? shortDescription;
  String? address;
  String? cuisine;
  String? logo;
  String? cover;
  String? city;
  String? locality;
  String? latitude;
  String? longitude;
  String? approxDeliveryTime;
  String? dishPriceForTwo;
  bool? takeAway;
  String? restaurantType;
  String? restaurantFacility;
  bool? acceptScheduleDelivery;
  bool? acceptHomeDelivery;
  String? minOrderAmount;
  String? license;
  String? licenseId;
  String? socialFacebook;
  String? socialInstagram;
  String? socialX;
  String? socialYoutube;
  String? socialLinkedIn;
  String? socialPinterest;
  List<OutletFormTranslations>? translations;
  CreateOutletRequestModel({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.countryCode,
    this.mobile,
    this.managerId,
    this.name,
    this.shortDescription,
    this.address,
    this.cuisine,
    this.logo,
    this.cover,
    this.city,
    this.locality,
    this.latitude,
    this.longitude,
    this.approxDeliveryTime,
    this.dishPriceForTwo,
    this.takeAway,
    this.restaurantType,
    this.restaurantFacility,
    this.acceptScheduleDelivery,
    this.acceptHomeDelivery,
    this.minOrderAmount,
    this.license,
    this.licenseId,
    this.socialFacebook,
    this.socialInstagram,
    this.socialX,
    this.socialYoutube,
    this.socialLinkedIn,
    this.socialPinterest,
    this.translations,
  });

  CreateOutletRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
    managerId = json['managerId'];
    name = json['name'];
    shortDescription = json['shortDescription'];
    address = json['address'];
    cuisine = json['cuisine'];
    logo = json['logo'];
    cover = json['cover'];
    city = json['city'];
    locality = json['locality'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    approxDeliveryTime = json['approxDeliveryTime'];
    dishPriceForTwo = json['dishPriceForTwo'];
    takeAway = json['takeAway'];
    restaurantType = json['restaurantType'];
    restaurantFacility = json['restaurantFacility'];
    acceptScheduleDelivery = json['acceptScheduleDelivery'];
    acceptHomeDelivery = json['acceptHomeDelivery'];
    minOrderAmount = json['minOrderAmount'];
    license = json['license'];
    licenseId = json['licenseId'];
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
      translations = <OutletFormTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(OutletFormTranslations.fromJson(v));
      });
    } else {
      translations = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    data['managerId'] = managerId;
    data['name'] = name;
    data['shortDescription'] = shortDescription;
    data['address'] = address;
    data['cuisine'] = cuisine;
    data['logo'] = logo;
    data['cover'] = cover;
    data['city'] = city;
    data['locality'] = locality;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['approxDeliveryTime'] = approxDeliveryTime;
    data['dishPriceForTwo'] = dishPriceForTwo;
    data['takeAway'] = takeAway;
    data['restaurantType'] = restaurantType;
    data['restaurantFacility'] = restaurantFacility;
    data['acceptScheduleDelivery'] = acceptScheduleDelivery;
    data['acceptHomeDelivery'] = acceptHomeDelivery;
    data['minOrderAmount'] = minOrderAmount;
    data['license'] = license;
    data['licenseId'] = licenseId;
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
