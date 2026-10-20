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

class PayoutMethodConfigModel {
  String? name;
  String? image;
  List<FormElementConfigModel>? formElement;
  List<PayoutTranslationConfigModel>? translations;
  bool? isDefault;
  bool? status;
  String? id;
  final String locale;
  PayoutMethodConfigModel({this.name, this.image, this.formElement, this.translations, this.isDefault, this.status, this.id, required this.locale});

  PayoutMethodConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    image = json['image'];
    if (json['formElement'] != null) {
      formElement = <FormElementConfigModel>[];
      json['formElement'].forEach((v) {
        formElement!.add(FormElementConfigModel.fromJson(v));
      });
    }
    if (json['translations'] != null) {
      translations = <PayoutTranslationConfigModel>[];
      json['translations'].forEach((v) {
        translations!.add(PayoutTranslationConfigModel.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].title!.isNotEmpty) {
            name = translations![localeIndex].title!;
          }
        }
      }
    } else {
      translations = [];
    }
    if (json['isDefault'] != null && json['isDefault'] != '') {
      if (json['isDefault'] == 'true' || json['isDefault'] == true) {
        isDefault = true;
      } else {
        isDefault = false;
      }
    } else {
      isDefault = false;
    }
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    if (formElement != null) {
      data['formElement'] = formElement!.map((v) => v.toJson()).toList();
    }
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['isDefault'] = isDefault;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class FormElementConfigModel {
  bool? isRequired;
  String? fieldType;
  String? fieldName;
  String? placeholder;

  FormElementConfigModel({this.isRequired, this.fieldType, this.fieldName, this.placeholder});

  FormElementConfigModel.fromJson(Map<String, dynamic> json) {
    if (json['isRequired'] != null && json['isRequired'] != '') {
      if (json['isRequired'] == true || json['isRequired'] == 'true') {
        isRequired = true;
      } else {
        isRequired = false;
      }
    } else {
      isRequired = false;
    }
    fieldType = json['fieldType'];
    fieldName = json['fieldName'];
    placeholder = json['placeholder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isRequired'] = isRequired;
    data['fieldType'] = fieldType;
    data['fieldName'] = fieldName;
    data['placeholder'] = placeholder;
    return data;
  }
}

class PayoutTranslationConfigModel {
  String? name;
  String? code;
  String? nativeName;
  String? title;

  PayoutTranslationConfigModel({this.name, this.code, this.nativeName, this.title});

  PayoutTranslationConfigModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['title'] = title;
    return data;
  }
}
