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

import 'package:vendor/app/core/models/tiffin_subscription_instruction_translation_model.dart';

class TiffinSubscriptionInstructionModalResponseModel {
  bool? action;
  String? name;
  List<TiffinSubscriptionInstructionTranslationModel>? translation;

  TiffinSubscriptionInstructionModalResponseModel({this.action, this.name, this.translation});

  TiffinSubscriptionInstructionModalResponseModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    name = json['name'];
    if (json['translation'] != null) {
      translation = <TiffinSubscriptionInstructionTranslationModel>[];
      json['translation'].forEach((v) {
        translation!.add(TiffinSubscriptionInstructionTranslationModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    data['name'] = name;
    if (translation != null) {
      data['translation'] = translation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
