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

class TiffinSubscriptionInstructionModel {
  String? name;
  String? displayName;
  List<TiffinSubscriptionInstructionTranslationModel>? translations;
  final String locale;
  TiffinSubscriptionInstructionModel({this.name, this.displayName, this.translations, required this.locale});

  TiffinSubscriptionInstructionModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    displayName = '';
    if (json['translations'] != null) {
      translations = <TiffinSubscriptionInstructionTranslationModel>[];
      json['translations'].forEach((v) {
        translations!.add(TiffinSubscriptionInstructionTranslationModel.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].value!.isNotEmpty) {
            displayName = translations![localeIndex].value!;
          }
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['displayName'] = displayName;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
