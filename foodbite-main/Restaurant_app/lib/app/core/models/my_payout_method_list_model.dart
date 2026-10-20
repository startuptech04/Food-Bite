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

class MyPayoutMethodListModel {
  List<PayoutMethodDetailConfigModel>? methods;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;
  final String locale;
  MyPayoutMethodListModel({this.methods, this.page, this.limit, this.totalPages, this.totalResults, this.success, required this.locale});

  MyPayoutMethodListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['methods'] != null) {
      methods = <PayoutMethodDetailConfigModel>[];
      json['methods'].forEach((v) {
        methods!.add(PayoutMethodDetailConfigModel.fromJson(v, locale));
      });
    }
    if (json['page'] != null && json['page'] != '') {
      page = int.parse(json['page'].toString());
    } else {
      page = 0;
    }
    if (json['limit'] != null && json['limit'] != '') {
      limit = int.parse(json['limit'].toString());
    } else {
      limit = 0;
    }
    if (json['totalPages'] != null && json['totalPages'] != '') {
      totalPages = int.parse(json['totalPages'].toString());
    } else {
      totalPages = 0;
    }
    if (json['totalResults'] != null && json['totalResults'] != '') {
      totalResults = int.parse(json['totalResults'].toString());
    } else {
      totalResults = 0;
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (methods != null) {
      data['methods'] = methods!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['success'] = success;
    return data;
  }
}

class PayoutMethodDetailConfigModel {
  SelectedPayoutMethodConfigModel? method;
  List<PayoutSavedFormValueConfigModel>? formElement;
  bool? status;
  bool? isDefault;
  String? id;
  final String locale;

  PayoutMethodDetailConfigModel({this.method, this.formElement, this.status, this.isDefault, this.id, required this.locale});

  PayoutMethodDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    method = json['method'] != null ? SelectedPayoutMethodConfigModel.fromJson(json['method'], locale) : null;
    if (json['formElement'] != null) {
      formElement = <PayoutSavedFormValueConfigModel>[];
      json['formElement'].forEach((v) {
        formElement!.add(PayoutSavedFormValueConfigModel.fromJson(v));
      });
    }
    status = json['status'];
    isDefault = json['isDefault'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (method != null) {
      data['method'] = method!.toJson();
    }
    if (formElement != null) {
      data['formElement'] = formElement!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['isDefault'] = isDefault;
    data['id'] = id;
    return data;
  }
}

class SelectedPayoutMethodConfigModel {
  String? id;
  String? name;
  List<Translations>? translations;
  final String locale;
  SelectedPayoutMethodConfigModel({this.id, this.name, this.translations, required this.locale});

  SelectedPayoutMethodConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Translations {
  String? name;
  String? code;
  String? nativeName;
  String? title;

  Translations({this.name, this.code, this.nativeName, this.title});

  Translations.fromJson(Map<String, dynamic> json) {
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

class PayoutSavedFormValueConfigModel {
  String? fieldName;
  String? fieldType;
  String? fieldValue;

  PayoutSavedFormValueConfigModel({this.fieldName, this.fieldType, this.fieldValue});

  PayoutSavedFormValueConfigModel.fromJson(Map<String, dynamic> json) {
    fieldName = json['fieldName'];
    fieldType = json['fieldType'];
    fieldValue = json['fieldValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fieldName'] = fieldName;
    data['fieldType'] = fieldType;
    data['fieldValue'] = fieldValue;
    return data;
  }
}
