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

class AddExpenseRequestModel {
  String? amount;
  String? restaurant;
  String? expenseType;

  AddExpenseRequestModel({this.amount, this.restaurant, this.expenseType});

  AddExpenseRequestModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    restaurant = json['restaurant'];
    expenseType = json['expenseType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['restaurant'] = restaurant;
    data['expenseType'] = expenseType;
    return data;
  }
}
