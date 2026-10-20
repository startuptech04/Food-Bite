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

class SaveDirectRestaurantReviewRequestModel {
  String? user;
  String? restaurant;
  int? restaurantRate;
  String? restaurantMessage;
  String? images;
  String? shortReview;

  SaveDirectRestaurantReviewRequestModel({this.user, this.restaurant, this.restaurantRate, this.restaurantMessage, this.images, this.shortReview});

  SaveDirectRestaurantReviewRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    restaurant = json['restaurant'];
    restaurantRate = json['restaurantRate'];
    restaurantMessage = json['restaurantMessage'];
    images = json['images'];
    shortReview = json['shortReview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['restaurant'] = restaurant;
    data['restaurantRate'] = restaurantRate;
    data['restaurantMessage'] = restaurantMessage;
    data['images'] = images;
    data['shortReview'] = shortReview;
    return data;
  }
}
