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

class RegisterRequestBasicDetailModel {
  List<RegisterRequestCitiesModel>? cities;
  List<RegisterRequestVehicleModel>? vehicles;
  JoiningFormSetupModel? joiningForm;
  bool? success;
  final String locale;

  RegisterRequestBasicDetailModel({this.cities, this.vehicles, this.joiningForm, this.success, required this.locale});

  RegisterRequestBasicDetailModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['cities'] != null) {
      cities = <RegisterRequestCitiesModel>[];
      json['cities'].forEach((v) {
        cities!.add(RegisterRequestCitiesModel.fromJson(v, locale));
      });
    } else {
      cities = [];
    }
    if (json['vehicles'] != null) {
      vehicles = <RegisterRequestVehicleModel>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(RegisterRequestVehicleModel.fromJson(v, locale));
      });
    } else {
      vehicles = [];
    }
    joiningForm = json['joiningForm'] != null ? JoiningFormSetupModel.fromJson(json['joiningForm']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cities != null) {
      data['cities'] = cities!.map((v) => v.toJson()).toList();
    }
    if (vehicles != null) {
      data['vehicles'] = vehicles!.map((v) => v.toJson()).toList();
    }
    if (joiningForm != null) {
      data['joiningForm'] = joiningForm!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class RegisterRequestCitiesModel {
  LocationCoordinatesModel? location;
  String? name;
  List<CommanTranslations>? translations;
  String? id;
  final String locale;

  RegisterRequestCitiesModel({this.location, this.name, this.translations, this.id, required this.locale});

  RegisterRequestCitiesModel.fromJson(Map<String, dynamic> json, this.locale) {
    location = json['location'] != null ? LocationCoordinatesModel.fromJson(json['location']) : null;
    name = json['name'];
    if (json['translations'] != null) {
      translations = <CommanTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(CommanTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].value!.isNotEmpty) {
            name = translations![localeIndex].value!;
          }
        }
      }
    } else {
      translations = [];
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['name'] = name;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class LocationCoordinatesModel {
  String? type;
  List<double>? coordinates;

  LocationCoordinatesModel({this.type, this.coordinates});

  LocationCoordinatesModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null && json['coordinates'] is List) {
      coordinates = List<double>.from(json['coordinates'].map((x) => x.toDouble()));
    } else {
      coordinates = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class CommanTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  CommanTranslations({this.name, this.code, this.nativeName, this.value});

  CommanTranslations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['value'] = value;
    return data;
  }
}

class RegisterRequestVehicleModel {
  String? name;
  List<CommanTranslations>? translations;
  String? id;
  final String locale;

  RegisterRequestVehicleModel({this.name, this.translations, this.id, required this.locale});

  RegisterRequestVehicleModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <CommanTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(CommanTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].value!.isNotEmpty) {
            name = translations![localeIndex].value!;
          }
        }
      }
    } else {
      translations = [];
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class JoiningFormSetupModel {
  JoiningFormResultConfig? result;
  bool? success;

  JoiningFormSetupModel({this.result, this.success});

  JoiningFormSetupModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? JoiningFormResultConfig.fromJson(json['result']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class JoiningFormResultConfig {
  List<DeliverymanFormConfigModel>? deliverymanForm;
  String? id;

  JoiningFormResultConfig({this.deliverymanForm, this.id});

  JoiningFormResultConfig.fromJson(Map<String, dynamic> json) {
    if (json['deliverymanForm'] != null) {
      deliverymanForm = <DeliverymanFormConfigModel>[];
      json['deliverymanForm'].forEach((v) {
        deliverymanForm!.add(DeliverymanFormConfigModel.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (deliverymanForm != null) {
      data['deliverymanForm'] = deliverymanForm!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class DeliverymanFormConfigModel {
  String? uuid;
  bool? isRequired;
  String? type;
  String? title;
  String? placeholder;
  List<JoiningFormCheckboxItemConfigModel>? items;

  DeliverymanFormConfigModel({this.uuid, this.isRequired, this.type, this.title, this.placeholder, this.items});

  DeliverymanFormConfigModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    if (json['isRequired'] != null && (json['isRequired'] == true || json['isRequired'] == 'true')) {
      isRequired = true;
    } else {
      isRequired = false;
    }
    type = json['type'];
    title = json['title'];
    placeholder = json['placeholder'];
    if (json['items'] != null) {
      items = <JoiningFormCheckboxItemConfigModel>[];
      json['items'].forEach((v) {
        items!.add(JoiningFormCheckboxItemConfigModel.fromJson(v));
      });
    } else {
      items = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['isRequired'] = isRequired;
    data['type'] = type;
    data['title'] = title;
    data['placeholder'] = placeholder;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JoiningFormCheckboxItemConfigModel {
  String? name;

  JoiningFormCheckboxItemConfigModel({this.name});

  JoiningFormCheckboxItemConfigModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
