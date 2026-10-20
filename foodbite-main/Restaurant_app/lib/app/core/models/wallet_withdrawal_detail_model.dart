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

class WalletWithdrawalDetailModel {
  WalletInfoConfigModel? walletInfo;
  List<WalletPayoutMethodConfigModel>? methods;
  bool? success;
  final String locale;
  WalletWithdrawalDetailModel({this.walletInfo, this.methods, this.success, required this.locale});

  WalletWithdrawalDetailModel.fromJson(Map<String, dynamic> json, this.locale) {
    walletInfo = json['walletInfo'] != null ? WalletInfoConfigModel.fromJson(json['walletInfo']) : null;
    if (json['methods'] != null) {
      methods = <WalletPayoutMethodConfigModel>[];
      json['methods'].forEach((v) {
        methods!.add(WalletPayoutMethodConfigModel.fromJson(v, locale));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (walletInfo != null) {
      data['walletInfo'] = walletInfo!.toJson();
    }
    if (methods != null) {
      data['methods'] = methods!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class WalletInfoConfigModel {
  double? balance;
  int? decimalPlaces;
  String? uuid;
  String? id;

  WalletInfoConfigModel({this.balance, this.decimalPlaces, this.uuid, this.id});

  WalletInfoConfigModel.fromJson(Map<String, dynamic> json) {
    if (json['balance'] != null && json['balance'] != '') {
      balance = double.parse(json['balance'].toString());
    } else {
      balance = 0;
    }
    if (json['decimalPlaces'] != null && json['decimalPlaces'] != '') {
      decimalPlaces = int.parse(json['decimalPlaces'].toString());
    } else {
      decimalPlaces = 0;
    }
    uuid = json['uuid'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    data['decimalPlaces'] = decimalPlaces;
    data['uuid'] = uuid;
    data['id'] = id;
    return data;
  }
}

class WalletPayoutMethodConfigModel {
  PayoutMethodInfoConfigModel? method;
  List<PayoutFormElementConfigModel>? formElement;
  bool? status;
  String? id;
  final String locale;

  WalletPayoutMethodConfigModel({this.method, this.formElement, this.status, this.id, required this.locale});

  WalletPayoutMethodConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    method = json['method'] != null ? PayoutMethodInfoConfigModel.fromJson(json['method'], locale) : null;
    if (json['formElement'] != null) {
      formElement = <PayoutFormElementConfigModel>[];
      json['formElement'].forEach((v) {
        formElement!.add(PayoutFormElementConfigModel.fromJson(v));
      });
    }
    status = json['status'];
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
    data['id'] = id;
    return data;
  }
}

class PayoutMethodInfoConfigModel {
  String? id;
  String? name;
  List<Translations>? translations;
  final String locale;
  PayoutMethodInfoConfigModel({this.id, this.name, this.translations, required this.locale});

  PayoutMethodInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
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

class PayoutFormElementConfigModel {
  String? fieldName;
  String? fieldType;
  String? fieldValue;

  PayoutFormElementConfigModel({this.fieldName, this.fieldType, this.fieldValue});

  PayoutFormElementConfigModel.fromJson(Map<String, dynamic> json) {
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
