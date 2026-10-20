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

class SaveUserCartRequestModel {
  String? user;
  String? foods;
  String? restaurants;
  String? cart;

  SaveUserCartRequestModel({this.user, this.foods, this.restaurants, this.cart});

  SaveUserCartRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    foods = json['foods'];
    restaurants = json['restaurants'];
    cart = json['cart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['foods'] = foods;
    data['restaurants'] = restaurants;
    data['cart'] = cart;
    return data;
  }
}
