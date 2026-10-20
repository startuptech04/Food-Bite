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

class LoadMoreChatConversionRequestModel {
  String? roomId;
  int? limit;
  int? page;

  LoadMoreChatConversionRequestModel({this.roomId, this.limit, this.page});

  LoadMoreChatConversionRequestModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    limit = json['limit'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomId'] = roomId;
    data['limit'] = limit;
    data['page'] = page;
    return data;
  }
}
