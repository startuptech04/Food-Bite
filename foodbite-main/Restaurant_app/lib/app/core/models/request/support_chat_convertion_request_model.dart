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

class SupportChatConvertionRequestModel {
  String? user;
  String? type;
  String? typeId;
  int? limit;
  int? page;

  SupportChatConvertionRequestModel({this.user, this.type, this.typeId, this.limit, this.page});

  SupportChatConvertionRequestModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    type = json['type'];
    typeId = json['typeId'];
    limit = json['limit'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['type'] = type;
    data['typeId'] = typeId;
    data['limit'] = limit;
    data['page'] = page;
    return data;
  }
}
