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

import 'package:driver/app/services/uuid_generator.dart';

class SupportChatMessageResponseModel {
  String? roomID;
  List<ChatMessageConfigModel>? chats;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  bool? success;

  SupportChatMessageResponseModel({this.roomID, this.chats, this.page, this.limit, this.totalPages, this.totalResults, this.success});

  SupportChatMessageResponseModel.fromJson(Map<String, dynamic> json) {
    roomID = json['roomID'];
    if (json['chats'] != null) {
      chats = <ChatMessageConfigModel>[];
      json['chats'].forEach((v) {
        chats!.add(ChatMessageConfigModel.fromJson(v));
      });
    } else {
      chats = [];
    }
    if (json['page'] != null && json['page'] != '') {
      page = int.parse(json['page'].toString());
    } else {
      page = 0;
    }
    if (json['limit'] != null && json['limit'] != '') {
      limit = int.parse(json['limit'].toString());
    } else {
      limit = 0;
    }
    if (json['totalPages'] != null && json['totalPages'] != '') {
      totalPages = int.parse(json['totalPages'].toString());
    } else {
      totalPages = 0;
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
    data['roomID'] = roomID;
    if (chats != null) {
      data['chats'] = chats!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['success'] = success;
    return data;
  }
}

class ChatMessageConfigModel {
  String? roomId;
  String? senderId;
  String? message;
  String? messageType;
  String? createdAt;
  String? id;
  MessageSenderConfigModel? sender;
  String? randomId;

  ChatMessageConfigModel({this.roomId, this.senderId, this.message, this.messageType, this.createdAt, this.id, this.sender, this.randomId});

  ChatMessageConfigModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    senderId = json['senderId'];
    message = json['message'];
    messageType = json['messageType'];
    createdAt = json['createdAt'];
    id = json['id'];
    sender = json['sender'] != null ? MessageSenderConfigModel.fromJson(json['sender']) : null;
    if (json['randomId'] != null && json['randomId'] != '') {
      randomId = json['randomId'];
    } else {
      randomId = Uuid().generateV4();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomId'] = roomId;
    data['senderId'] = senderId;
    data['message'] = message;
    data['messageType'] = messageType;
    data['createdAt'] = createdAt;
    data['id'] = id;
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    data['randomId'] = randomId;
    return data;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatMessageConfigModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class MessageSenderConfigModel {
  String? id;
  String? image;
  String? firstName;
  String? lastName;

  MessageSenderConfigModel({this.id, this.image, this.firstName, this.lastName});

  MessageSenderConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    return data;
  }
}
