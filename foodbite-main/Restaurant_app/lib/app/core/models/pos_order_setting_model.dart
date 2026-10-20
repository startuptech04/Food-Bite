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

class PosOrderSettingModel {
  PosOrderBusinessSettingConfigModel? business;
  PosPackagingSettingConfigModel? packaging;

  PosOrderSettingModel({this.business, this.packaging});

  PosOrderSettingModel.fromJson(Map<String, dynamic> json) {
    business = json['business'] != null ? PosOrderBusinessSettingConfigModel.fromJson(json['business']) : null;
    packaging = json['packaging'] != null ? PosPackagingSettingConfigModel.fromJson(json['packaging']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (business != null) {
      data['business'] = business!.toJson();
    }
    if (packaging != null) {
      data['packaging'] = packaging!.toJson();
    }
    return data;
  }
}

class PosOrderBusinessSettingConfigModel {
  bool? includeTaxOnFood;
  String? foodTaxName;
  double? foodTaxAmount;
  String? foodTaxType;
  bool? additionalServiceCharge;
  String? additionalServiceName;
  double? additionalServiceAmount;
  String? id;

  PosOrderBusinessSettingConfigModel({
    this.includeTaxOnFood,
    this.foodTaxName,
    this.foodTaxAmount,
    this.foodTaxType,
    this.additionalServiceCharge,
    this.additionalServiceName,
    this.additionalServiceAmount,
    this.id,
  });

  PosOrderBusinessSettingConfigModel.fromJson(Map<String, dynamic> json) {
    includeTaxOnFood = json['includeTaxOnFood'];
    foodTaxName = json['foodTaxName'];
    if (json['foodTaxAmount'] != null && json['foodTaxAmount'] != '') {
      foodTaxAmount = double.parse(json['foodTaxAmount'].toString());
    } else {
      foodTaxAmount = 0;
    }
    foodTaxType = json['foodTaxType'];
    additionalServiceCharge = json['additionalServiceCharge'];
    additionalServiceName = json['additionalServiceName'];
    if (json['additionalServiceAmount'] != null && json['additionalServiceAmount'] != '') {
      additionalServiceAmount = double.parse(json['additionalServiceAmount'].toString());
    } else {
      additionalServiceAmount = 0;
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['includeTaxOnFood'] = includeTaxOnFood;
    data['foodTaxName'] = foodTaxName;
    data['foodTaxAmount'] = foodTaxAmount;
    data['foodTaxType'] = foodTaxType;
    data['additionalServiceCharge'] = additionalServiceCharge;
    data['additionalServiceName'] = additionalServiceName;
    data['additionalServiceAmount'] = additionalServiceAmount;
    data['id'] = id;
    return data;
  }
}

class PosPackagingSettingConfigModel {
  bool? havePackagingCharges;
  double? packagingCharges;
  bool? includePackagesChargesInTax;
  double? packagingChargesTax;
  String? id;

  PosPackagingSettingConfigModel({
    this.havePackagingCharges,
    this.packagingCharges,
    this.includePackagesChargesInTax,
    this.packagingChargesTax,
    this.id,
  });

  PosPackagingSettingConfigModel.fromJson(Map<String, dynamic> json) {
    havePackagingCharges = json['havePackagingCharges'];
    if (json['packagingCharges'] != null && json['packagingCharges'] != '') {
      packagingCharges = double.parse(json['packagingCharges'].toString());
    } else {
      packagingCharges = 0;
    }
    includePackagesChargesInTax = json['includePackagesChargesInTax'];
    if (json['packagingChargesTax'] != null && json['packagingChargesTax'] != '') {
      packagingChargesTax = double.parse(json['packagingChargesTax'].toString());
    } else {
      packagingChargesTax = 0;
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['havePackagingCharges'] = havePackagingCharges;
    data['packagingCharges'] = packagingCharges;
    data['includePackagesChargesInTax'] = includePackagesChargesInTax;
    data['packagingChargesTax'] = packagingChargesTax;
    data['id'] = id;
    return data;
  }
}
