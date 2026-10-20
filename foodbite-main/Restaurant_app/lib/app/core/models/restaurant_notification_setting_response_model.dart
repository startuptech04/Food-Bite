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

class RestaurantNotificationSettingResponseModel {
  RestaurantNotificationSettingConfigModel? setting;
  bool? success;

  RestaurantNotificationSettingResponseModel({this.setting, this.success});

  RestaurantNotificationSettingResponseModel.fromJson(Map<String, dynamic> json) {
    setting = json['setting'] != null ? RestaurantNotificationSettingConfigModel.fromJson(json['setting']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (setting != null) {
      data['setting'] = setting!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class RestaurantNotificationSettingConfigModel {
  String? user;
  bool? newsletters;
  bool? promoEmail;
  bool? promoNotification;
  bool? promoWhatsApp;
  bool? socialEmail;
  bool? socialNotification;
  bool? orderEmail;
  bool? orderNotification;
  bool? orderWhatsApp;
  bool? importantUpdate;
  String? id;

  RestaurantNotificationSettingConfigModel({
    this.user,
    this.newsletters,
    this.promoEmail,
    this.promoNotification,
    this.promoWhatsApp,
    this.socialEmail,
    this.socialNotification,
    this.orderEmail,
    this.orderNotification,
    this.orderWhatsApp,
    this.importantUpdate,
    this.id,
  });

  RestaurantNotificationSettingConfigModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    newsletters = json['newsletters'];
    promoEmail = json['promoEmail'];
    promoNotification = json['promoNotification'];
    promoWhatsApp = json['promoWhatsApp'];
    socialEmail = json['socialEmail'];
    socialNotification = json['socialNotification'];
    orderEmail = json['orderEmail'];
    orderNotification = json['orderNotification'];
    orderWhatsApp = json['orderWhatsApp'];
    importantUpdate = json['importantUpdate'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['newsletters'] = newsletters;
    data['promoEmail'] = promoEmail;
    data['promoNotification'] = promoNotification;
    data['promoWhatsApp'] = promoWhatsApp;
    data['socialEmail'] = socialEmail;
    data['socialNotification'] = socialNotification;
    data['orderEmail'] = orderEmail;
    data['orderNotification'] = orderNotification;
    data['orderWhatsApp'] = orderWhatsApp;
    data['importantUpdate'] = importantUpdate;
    data['id'] = id;
    return data;
  }
}
