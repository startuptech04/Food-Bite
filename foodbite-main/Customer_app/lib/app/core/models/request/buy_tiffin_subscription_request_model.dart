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

import 'package:user/app/core/models/request/tiffin_subscription_food_config_request_model.dart';

class BuyTiffinSubscriptionRequestModel {
  String? user;
  String? subscriptionPackage;
  String? payment;
  List<TiffinSubscriptionFoodConfigRequestModel>? food;
  String? slot;
  String? cookingInstruction;
  String? deliveryInstruction;
  String? deliveryAddress;
  String? receiverName;
  String? countryCode;
  String? receiverContact;

  BuyTiffinSubscriptionRequestModel({
    this.user,
    this.subscriptionPackage,
    this.payment,
    this.food,
    this.slot,
    this.cookingInstruction,
    this.deliveryInstruction,
    this.deliveryAddress,
    this.receiverName,
    this.countryCode,
    this.receiverContact,
  });

  BuyTiffinSubscriptionRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    subscriptionPackage = json['subscriptionPackage'];
    payment = json['payment'];
    if (json['food'] != null) {
      food = <TiffinSubscriptionFoodConfigRequestModel>[];
      json['food'].forEach((v) {
        food!.add(TiffinSubscriptionFoodConfigRequestModel.fromJson(v));
      });
    }
    slot = json['slot'];
    cookingInstruction = json['cookingInstruction'];
    deliveryInstruction = json['deliveryInstruction'];
    deliveryAddress = json['deliveryAddress'];
    receiverName = json['receiverName'];
    countryCode = json['countryCode'];
    receiverContact = json['receiverContact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['subscriptionPackage'] = subscriptionPackage;
    data['payment'] = payment;
    if (food != null) {
      data['food'] = food!.map((v) => v.toJson()).toList();
    }
    data['slot'] = slot;
    data['cookingInstruction'] = cookingInstruction;
    data['deliveryInstruction'] = deliveryInstruction;
    data['deliveryAddress'] = deliveryAddress;
    data['receiverName'] = receiverName;
    data['countryCode'] = countryCode;
    data['receiverContact'] = receiverContact;
    return data;
  }
}
