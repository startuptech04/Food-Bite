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

class WalletModel {
  WalletDetailConfigModel? walletInfo;
  double? inHandAmount;
  double? totalEarning;

  WalletModel({this.walletInfo, this.inHandAmount, this.totalEarning});

  WalletModel.fromJson(Map<String, dynamic> json) {
    walletInfo = json['walletInfo'] != null ? WalletDetailConfigModel.fromJson(json['walletInfo']) : null;
    if (json['inHandAmount'] != null && json['inHandAmount'] != '') {
      inHandAmount = double.parse(json['inHandAmount'].toString());
    } else {
      inHandAmount = 0;
    }
    if (json['totalEarning'] != null && json['totalEarning'] != '') {
      totalEarning = double.parse(json['totalEarning'].toString());
    } else {
      totalEarning = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (walletInfo != null) {
      data['walletInfo'] = walletInfo!.toJson();
    }
    data['inHandAmount'] = inHandAmount;
    data['totalEarning'] = totalEarning;
    return data;
  }
}

class WalletDetailConfigModel {
  double? balance;
  int? decimalPlaces;
  String? uuid;
  String? id;

  WalletDetailConfigModel({this.balance, this.decimalPlaces, this.uuid, this.id});

  WalletDetailConfigModel.fromJson(Map<String, dynamic> json) {
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
