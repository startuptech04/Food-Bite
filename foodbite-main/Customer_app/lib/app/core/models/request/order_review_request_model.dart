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

import 'package:user/app/core/models/request/product_review_param_request_model.dart';

class OrderReviewRequestModel {
  String? user;
  String? orders;
  String? driver;
  String? restaurant;
  int? driverRate;
  int? restaurantRate;
  String? driverMessage;
  String? restaurantMessage;
  List<ProductReviewParamRequestModel>? product;
  String? images;
  String? shortReview;

  OrderReviewRequestModel({this.user, this.orders, this.driver, this.restaurant, this.driverRate, this.restaurantRate, this.driverMessage, this.restaurantMessage, this.product, this.images, this.shortReview});

  OrderReviewRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    orders = json['orders'];
    driver = json['driver'];
    restaurant = json['restaurant'];
    driverRate = json['driverRate'];
    restaurantRate = json['restaurantRate'];
    driverMessage = json['driverMessage'];
    restaurantMessage = json['restaurantMessage'];
    if (json['product'] != null) {
      product = <ProductReviewParamRequestModel>[];
      json['product'].forEach((v) {
        product!.add(ProductReviewParamRequestModel.fromJson(v));
      });
    } else {
      product = [];
    }
    images = json['images'];
    shortReview = json['shortReview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['orders'] = orders;
    data['driver'] = driver;
    data['restaurant'] = restaurant;
    data['driverRate'] = driverRate;
    data['restaurantRate'] = restaurantRate;
    data['driverMessage'] = driverMessage;
    data['restaurantMessage'] = restaurantMessage;
    if (product != null) {
      data['product'] = product!.map((v) => v.toJson()).toList();
    }
    data['images'] = images;
    data['shortReview'] = shortReview;
    return data;
  }
}
