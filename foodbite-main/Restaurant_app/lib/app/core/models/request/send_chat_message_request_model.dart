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

class SendChatMessageRequestModel {
  String? room;
  String? sender;
  String? msg;
  String? msgType;

  SendChatMessageRequestModel({this.room, this.sender, this.msg, this.msgType});

  SendChatMessageRequestModel.fromJson(Map<String, dynamic> json) {
    room = json['room'];
    sender = json['sender'];
    msg = json['msg'];
    msgType = json['msgType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['room'] = room;
    data['sender'] = sender;
    data['msg'] = msg;
    data['msgType'] = msgType;
    return data;
  }
}
