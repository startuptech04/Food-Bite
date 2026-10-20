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

import 'package:vendor/app/core/models/outlet_cities_response_model.dart';
import 'package:vendor/app/core/models/outlet_license_response_model.dart';
import 'package:vendor/app/core/models/outlet_localities_response_model.dart';

class NewOutletBasicDetailModel {
  List<OutletCitiesResponseModel>? cities;
  List<OutletLicenseResponseModel>? licenses;
  List<OutletLocalitiesResponseModel>? localities;
  bool? success;
  final String locale;
  NewOutletBasicDetailModel({this.cities, this.localities, this.licenses, this.success, required this.locale});

  NewOutletBasicDetailModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['cities'] != null) {
      cities = <OutletCitiesResponseModel>[];
      json['cities'].forEach((v) {
        cities!.add(OutletCitiesResponseModel.fromJson(v, locale));
      });
    }
    if (json['licenses'] != null) {
      licenses = <OutletLicenseResponseModel>[];
      json['licenses'].forEach((v) {
        licenses!.add(OutletLicenseResponseModel.fromJson(v, locale));
      });
    }
    if (json['localities'] != null) {
      localities = <OutletLocalitiesResponseModel>[];
      json['localities'].forEach((v) {
        localities!.add(OutletLocalitiesResponseModel.fromJson(v, locale));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cities != null) {
      data['cities'] = cities!.map((v) => v.toJson()).toList();
    }
    if (localities != null) {
      data['localities'] = localities!.map((v) => v.toJson()).toList();
    }
    if (licenses != null) {
      data['licenses'] = licenses!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}
