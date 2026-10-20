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

import 'package:intl/intl.dart';

class WithdrawalHistoryModel {
  List<WithdrawalHistoryConfigModel>? results;
  int? createdRequest;
  int? acceptedRequest;
  int? rejectedRequest;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;
  final String locale;

  WithdrawalHistoryModel({this.results, this.createdRequest, this.acceptedRequest, this.rejectedRequest, this.page, this.limit, this.totalPages, this.totalResults, this.success, required this.locale});

  WithdrawalHistoryModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['results'] != null) {
      results = <WithdrawalHistoryConfigModel>[];
      json['results'].forEach((v) {
        results!.add(WithdrawalHistoryConfigModel.fromJson(v, locale));
      });
    }
    if (json['createdRequest'] != null && json['createdRequest'] != '') {
      createdRequest = int.parse(json['createdRequest'].toString());
    } else {
      createdRequest = 0;
    }
    if (json['acceptedRequest'] != null && json['acceptedRequest'] != '') {
      acceptedRequest = int.parse(json['acceptedRequest'].toString());
    } else {
      acceptedRequest = 0;
    }
    if (json['rejectedRequest'] != null && json['rejectedRequest'] != '') {
      rejectedRequest = int.parse(json['rejectedRequest'].toString());
    } else {
      rejectedRequest = 0;
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
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['success'] = success;
    return data;
  }
}

class WithdrawalHistoryConfigModel {
  String? rejectedBy;
  String? rejectedReason;
  String? approvedNotes;
  String? proof;
  List<WithdrawalFormElementConfigModel>? formElement;
  String? status;
  String? createdAt;
  String? id;
  double? amount;
  WithdrawalMethodDetailConfigModel? withdrawalMethodDetail;
  DeliverymanPayoutMethodDetailConfigModel? deliverymanPayoutMethod;
  final String locale;

  WithdrawalHistoryConfigModel({
    this.rejectedBy,
    this.rejectedReason,
    this.approvedNotes,
    this.proof,
    this.formElement,
    this.status,
    this.createdAt,
    this.id,
    this.amount,
    this.withdrawalMethodDetail,
    this.deliverymanPayoutMethod,
    required this.locale,
  });

  WithdrawalHistoryConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    rejectedBy = json['rejectedBy'];
    rejectedReason = json['rejectedReason'];
    approvedNotes = json['approvedNotes'];
    proof = json['proof'];
    if (json['formElement'] != null) {
      formElement = <WithdrawalFormElementConfigModel>[];
      json['formElement'].forEach((v) {
        formElement!.add(WithdrawalFormElementConfigModel.fromJson(v));
      });
    }
    status = json['status'];
    if (json['createdAt'] != null && json['createdAt'].toString().isNotEmpty) {
      DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['createdAt']);
      var inputDate = DateTime.parse(parseDate.toString());
      createdAt = DateFormat.yMMMMd(locale).format(inputDate);
    } else {
      createdAt = '-';
    }
    id = json['id'];
    if (json['amount'] != null && json['amount'] != '') {
      amount = double.parse(json['amount'].toString());
    } else {
      amount = 0;
    }
    withdrawalMethodDetail = json['withdrawalMethodDetail'] != null ? WithdrawalMethodDetailConfigModel.fromJson(json['withdrawalMethodDetail'], locale) : null;
    deliverymanPayoutMethod = json['deliverymanPayoutMethod'] != null ? DeliverymanPayoutMethodDetailConfigModel.fromJson(json['deliverymanPayoutMethod']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rejectedBy'] = rejectedBy;
    data['rejectedReason'] = rejectedReason;
    data['approvedNotes'] = approvedNotes;
    data['proof'] = proof;
    if (formElement != null) {
      data['formElement'] = formElement!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['amount'] = amount;
    if (withdrawalMethodDetail != null) {
      data['withdrawalMethodDetail'] = withdrawalMethodDetail!.toJson();
    }
    if (deliverymanPayoutMethod != null) {
      data['deliverymanPayoutMethod'] = deliverymanPayoutMethod!.toJson();
    }
    return data;
  }
}

class WithdrawalFormElementConfigModel {
  String? fieldName;
  String? fieldType;
  String? fieldValue;

  WithdrawalFormElementConfigModel({this.fieldName, this.fieldType, this.fieldValue});

  WithdrawalFormElementConfigModel.fromJson(Map<String, dynamic> json) {
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

class WithdrawalMethodDetailConfigModel {
  String? id;
  String? name;
  List<WithdrawalMethodDetailTranslations>? translations;
  final String locale;

  WithdrawalMethodDetailConfigModel({this.id, this.name, this.translations, required this.locale});

  WithdrawalMethodDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    if (json['translations'] != null) {
      translations = <WithdrawalMethodDetailTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(WithdrawalMethodDetailTranslations.fromJson(v));
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

class WithdrawalMethodDetailTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? title;

  WithdrawalMethodDetailTranslations({this.name, this.code, this.nativeName, this.title});

  WithdrawalMethodDetailTranslations.fromJson(Map<String, dynamic> json) {
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

class DeliverymanPayoutMethodDetailConfigModel {
  String? id;
  List<WithdrawalFormElementConfigModel>? credential;

  DeliverymanPayoutMethodDetailConfigModel({this.id, this.credential});

  DeliverymanPayoutMethodDetailConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['credential'] != null) {
      credential = <WithdrawalFormElementConfigModel>[];
      json['credential'].forEach((v) {
        credential!.add(WithdrawalFormElementConfigModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (credential != null) {
      data['credential'] = credential!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
