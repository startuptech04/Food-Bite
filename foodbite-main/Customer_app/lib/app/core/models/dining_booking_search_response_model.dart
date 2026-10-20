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

import 'package:user/app/core/models/dining_booking_list_response_model.dart';

class DiningBookingSearchResponseModel {
  List<DiningBookingDetailConfigModel>? bookings;
  int? totalResults;
  bool? success;
  final String locale;
  DiningBookingSearchResponseModel({this.bookings, this.totalResults, this.success, required this.locale});

  DiningBookingSearchResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['bookings'] != null) {
      bookings = <DiningBookingDetailConfigModel>[];
      json['bookings'].forEach((v) {
        bookings!.add(DiningBookingDetailConfigModel.fromJson(v, locale));
      });
    } else {
      bookings = [];
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
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    data['totalResults'] = totalResults;
    data['success'] = success;
    return data;
  }
}
