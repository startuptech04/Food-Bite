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

class VendorSettingsModel {
  Business? business;
  Vendor? vendor;
  Language? language;
  SocialLoginConfigModel? social;
  AppVersionConfigModel? versions;
  String? imagePath;

  VendorSettingsModel({this.business, this.vendor, this.language, this.social, this.versions, this.imagePath});

  VendorSettingsModel.fromJson(Map<String, dynamic> json) {
    business = json['business'] != null ? Business.fromJson(json['business']) : null;
    vendor = json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
    language = json['language'] != null ? Language.fromJson(json['language']) : null;
    social = json['social'] != null ? SocialLoginConfigModel.fromJson(json['social']) : null;
    versions = json['versions'] != null ? AppVersionConfigModel.fromJson(json['versions']) : null;
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (business != null) {
      data['business'] = business!.toJson();
    }
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    if (language != null) {
      data['language'] = language!.toJson();
    }
    if (social != null) {
      data['social'] = social!.toJson();
    }
    if (versions != null) {
      data['versions'] = versions!.toJson();
    }
    if (imagePath != null) {
      data['imagePath'] = '';
    }
    return data;
  }
}

class Business {
  String? email;
  String? mobile;
  String? companyName;
  Currency? currency;
  String? currencySide;
  AppDefaultCountryCodeConfigModel? defaultCountryCode;
  int? decimalPoint;
  String? logo;
  bool? maintenance;

  Business({this.email, this.mobile, this.companyName, this.currency, this.currencySide, this.defaultCountryCode, this.decimalPoint, this.logo, this.maintenance});

  Business.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    mobile = json['mobile'];
    companyName = json['companyName'];
    defaultCountryCode = json['defaultCountryCode'] != null ? AppDefaultCountryCodeConfigModel.fromJson(json['defaultCountryCode']) : null;
    currency = json['currency'] != null ? Currency.fromJson(json['currency']) : null;
    currencySide = json['currencySide'];
    if (json['decimalPoint'] != null && json['decimalPoint'] != '') {
      decimalPoint = int.parse(json['decimalPoint'].toString());
    } else {
      decimalPoint = 2;
    }
    logo = json['logo'];
    maintenance = json['maintenance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['mobile'] = mobile;
    data['companyName'] = companyName;
    if (defaultCountryCode != null) {
      data['defaultCountryCode'] = defaultCountryCode!.toJson();
    }
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    data['currencySide'] = currencySide;
    data['decimalPoint'] = decimalPoint;
    data['logo'] = logo;
    data['maintenance'] = maintenance;
    return data;
  }
}

class Currency {
  String? cc;
  String? symbol;
  String? name;

  Currency({this.cc, this.symbol, this.name});

  Currency.fromJson(Map<String, dynamic> json) {
    cc = json['cc'];
    symbol = json['symbol'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cc'] = cc;
    data['symbol'] = symbol;
    data['name'] = name;
    return data;
  }
}

class Vendor {
  String? restaurantLoginWith;
  String? restaurantResetPasswordWith;
  bool? selfRegistration;

  Vendor({this.restaurantLoginWith, this.restaurantResetPasswordWith, this.selfRegistration});

  Vendor.fromJson(Map<String, dynamic> json) {
    restaurantLoginWith = json['restaurantLoginWith'];
    restaurantResetPasswordWith = json['restaurantResetPasswordWith'];
    selfRegistration = json['selfRegistration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurantLoginWith'] = restaurantLoginWith;
    data['restaurantResetPasswordWith'] = restaurantResetPasswordWith;
    data['selfRegistration'] = selfRegistration;
    return data;
  }
}

class AppDefaultCountryCodeConfigModel {
  String? name;
  String? dialCode;
  String? code;
  String? preferred;
  String? flag;

  AppDefaultCountryCodeConfigModel({this.name, this.dialCode, this.code, this.preferred, this.flag});

  AppDefaultCountryCodeConfigModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dialCode = json['dial_code'];
    code = json['code'];
    preferred = json['preferred'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['dial_code'] = dialCode;
    data['code'] = code;
    data['preferred'] = preferred;
    data['flag'] = flag;
    return data;
  }
}

class Language {
  String? name;
  String? nativeName;
  String? code;
  String? direction;
  bool? isDefault;
  bool? status;
  String? image;

  Language({this.name, this.nativeName, this.code, this.direction, this.isDefault, this.status, this.image});

  Language.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nativeName = json['nativeName'];
    code = json['code'];
    direction = json['direction'];
    isDefault = json['isDefault'];
    status = json['status'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['nativeName'] = nativeName;
    data['code'] = code;
    data['direction'] = direction;
    data['isDefault'] = isDefault;
    data['status'] = status;
    data['image'] = image;
    return data;
  }
}

class SocialLoginConfigModel {
  bool? appleSignin;
  bool? facebookSignin;
  bool? googleSignin;
  GoogleOAuthCredConfigModel? googleOAuth;

  SocialLoginConfigModel({this.appleSignin, this.facebookSignin, this.googleSignin, this.googleOAuth});

  SocialLoginConfigModel.fromJson(Map<String, dynamic> json) {
    appleSignin = json['appleSignin'];
    facebookSignin = json['facebookSignin'];
    googleSignin = json['googleSignin'];
    googleOAuth = json['googleOAuth'] != null ? GoogleOAuthCredConfigModel.fromJson(json['googleOAuth']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appleSignin'] = appleSignin;
    data['facebookSignin'] = facebookSignin;
    data['googleSignin'] = googleSignin;
    if (googleOAuth != null) {
      data['googleOAuth'] = googleOAuth!.toJson();
    }
    return data;
  }
}

class GoogleOAuthCredConfigModel {
  String? googleClientId;
  String? googleServerId;

  GoogleOAuthCredConfigModel({this.googleClientId, this.googleServerId});

  GoogleOAuthCredConfigModel.fromJson(Map<String, dynamic> json) {
    googleClientId = json['google_client_id'];
    googleServerId = json['google_server_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['google_client_id'] = googleClientId;
    data['google_server_id'] = googleServerId;
    return data;
  }
}

class AppVersionConfigModel {
  String? androidVersion;
  String? androidUrl;
  String? iosVersion;
  String? iosUrl;
  bool? success;

  AppVersionConfigModel({this.androidVersion, this.androidUrl, this.iosVersion, this.iosUrl, this.success});

  AppVersionConfigModel.fromJson(Map<String, dynamic> json) {
    androidVersion = json['androidVersion'];
    androidUrl = json['androidUrl'];
    iosVersion = json['iosVersion'];
    iosUrl = json['iosUrl'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['androidVersion'] = androidVersion;
    data['androidUrl'] = androidUrl;
    data['iosVersion'] = iosVersion;
    data['iosUrl'] = iosUrl;
    data['success'] = success;
    return data;
  }
}
