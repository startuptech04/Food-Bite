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

import 'package:vendor/app/core/models/tiffin_subscription_instruction_list_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_timeslot_list_model.dart';
import 'package:vendor/app/core/models/translations/tiffin_subscription_form_translation.dart';

class TiffinSubscriptionRequestModel {
  String? name;
  String? shortDescription;
  String? image;
  String? restaurant;
  String? foods;
  String? interval;
  String? offDays;
  String? totalOrder;
  String? available;
  List<TiffinSubscriptionTimeSlotListModel>? timeSlots;
  String? orderTo;
  String? deliveryArea;
  bool? canSelectAddon;
  bool? canSelectVariation;
  String? price;
  String? discountType;
  String? discount;
  List<TiffinSubscriptionInstructionModel>? notice;
  List<TiffinSubscriptionFormTransation>? translations;

  TiffinSubscriptionRequestModel({
    this.name,
    this.shortDescription,
    this.image,
    this.restaurant,
    this.foods,
    this.interval,
    this.offDays,
    this.totalOrder,
    this.available,
    this.timeSlots,
    this.orderTo,
    this.deliveryArea,
    this.canSelectAddon,
    this.canSelectVariation,
    this.price,
    this.discountType,
    this.discount,
    this.notice,
    this.translations,
  });

  TiffinSubscriptionRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    shortDescription = json['shortDescription'];
    image = json['image'];
    restaurant = json['restaurant'];
    foods = json['foods'];
    interval = json['interval'];
    offDays = json['offDays'];
    totalOrder = json['totalOrder'];
    available = json['available'];
    if (json['timeSlots'] != null) {
      timeSlots = <TiffinSubscriptionTimeSlotListModel>[];
      json['timeSlots'].forEach((v) {
        timeSlots!.add(TiffinSubscriptionTimeSlotListModel.fromJson(v));
      });
    }
    orderTo = json['orderTo'];
    deliveryArea = json['deliveryArea'];
    canSelectAddon = json['canSelectAddon'];
    canSelectVariation = json['canSelectVariation'];
    price = json['price'];
    discountType = json['discountType'];
    discount = json['discount'];
    if (json['notice'] != null) {
      notice = <TiffinSubscriptionInstructionModel>[];
      json['notice'].forEach((v) {
        notice!.add(TiffinSubscriptionInstructionModel.fromJson(v, ''));
      });
    }
    if (json['translations'] != null) {
      translations = <TiffinSubscriptionFormTransation>[];
      json['translations'].forEach((v) {
        translations!.add(TiffinSubscriptionFormTransation.fromJson(v));
      });
    } else {
      translations = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['shortDescription'] = shortDescription;
    data['image'] = image;
    data['restaurant'] = restaurant;
    data['foods'] = foods;
    data['interval'] = interval;
    data['offDays'] = offDays;
    data['totalOrder'] = totalOrder;
    data['available'] = available;
    if (timeSlots != null) {
      data['timeSlots'] = timeSlots!.map((v) => v.toJson()).toList();
    }
    data['orderTo'] = orderTo;
    data['deliveryArea'] = deliveryArea;
    data['canSelectAddon'] = canSelectAddon;
    data['canSelectVariation'] = canSelectVariation;
    data['price'] = price;
    data['discountType'] = discountType;
    data['discount'] = discount;
    if (notice != null) {
      data['notice'] = notice!.map((v) => v.toJson()).toList();
    }
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
