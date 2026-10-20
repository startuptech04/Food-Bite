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

class DiningBookingCancellationReasonListModel {
  List<DiningBookingCancellationReasonModel>? reasons;
  final String locale;
  DiningBookingCancellationReasonListModel({this.reasons, required this.locale});

  DiningBookingCancellationReasonListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['reasons'] != null) {
      reasons = <DiningBookingCancellationReasonModel>[];
      json['reasons'].forEach((v) {
        reasons!.add(DiningBookingCancellationReasonModel.fromJson(v, locale));
      });
    } else {
      reasons = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (reasons != null) {
      data['reasons'] = reasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DiningBookingCancellationReasonModel {
  String? name;
  List<DiningBookingCancellationReasonTranslations>? translations;
  String? id;
  final String locale;
  DiningBookingCancellationReasonModel({this.name, this.translations, this.id, required this.locale});

  DiningBookingCancellationReasonModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <DiningBookingCancellationReasonTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(DiningBookingCancellationReasonTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].value!.isNotEmpty) {
            name = translations![localeIndex].value!;
          }
        }
      }
    } else {
      translations = [];
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class DiningBookingCancellationReasonTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  DiningBookingCancellationReasonTranslations({this.name, this.code, this.nativeName, this.value});

  DiningBookingCancellationReasonTranslations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['value'] = value;
    return data;
  }
}
