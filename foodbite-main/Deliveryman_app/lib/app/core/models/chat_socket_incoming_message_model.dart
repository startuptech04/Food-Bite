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

class ChatSocketIncomingMessageModel {
  String? senderId;
  String? message;
  String? randomId;
  String? messageType;
  String? currentDate;

  ChatSocketIncomingMessageModel({this.senderId, this.message, this.randomId, this.messageType, this.currentDate});

  ChatSocketIncomingMessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    message = json['message'];
    randomId = json['randomId'];
    messageType = json['messageType'];
    currentDate = json['currentDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['message'] = message;
    data['randomId'] = randomId;
    data['messageType'] = messageType;
    data['currentDate'] = currentDate;
    return data;
  }
}
