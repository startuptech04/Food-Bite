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

class DriverSettingsModel {
  List<ServerLocalesModel>? locales;
  SettingsConfigModel? settings;
  DefaultLocaleConfigModel? defaultLocale;
  SocialLoginConfigModel? social;
  DriverConfigModel? driver;
  AppVersionConfigModel? versions;
  String? imagePath;

  DriverSettingsModel({this.locales, this.settings, this.defaultLocale, this.social, this.driver, this.versions, this.imagePath});

  DriverSettingsModel.fromJson(Map<String, dynamic> json) {
    if (json['locales'] != null) {
      locales = <ServerLocalesModel>[];
      json['locales'].forEach((v) {
        locales!.add(ServerLocalesModel.fromJson(v));
      });
    }
    settings = json['settings'] != null ? SettingsConfigModel.fromJson(json['settings']) : null;
    defaultLocale = json['defaultLocale'] != null ? DefaultLocaleConfigModel.fromJson(json['defaultLocale']) : null;
    social = json['social'] != null ? SocialLoginConfigModel.fromJson(json['social']) : null;
    driver = json['driver'] != null ? DriverConfigModel.fromJson(json['driver']) : null;
    versions = json['versions'] != null ? AppVersionConfigModel.fromJson(json['versions']) : null;
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (locales != null) {
      data['locales'] = locales!.map((v) => v.toJson()).toList();
    }
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    if (defaultLocale != null) {
      data['defaultLocale'] = defaultLocale!.toJson();
    }
    if (social != null) {
      data['social'] = social!.toJson();
    }
    if (driver != null) {
      data['driver'] = driver!.toJson();
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

class ServerLocalesModel {
  String? name;
  String? nativeName;
  String? code;
  String? direction;
  bool? isDefault;
  bool? status;
  String? image;
  String? id;

  ServerLocalesModel({this.name, this.nativeName, this.code, this.direction, this.isDefault, this.status, this.image, this.id});

  ServerLocalesModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nativeName = json['nativeName'];
    code = json['code'];
    direction = json['direction'];
    isDefault = json['isDefault'];
    status = json['status'];
    image = json['image'];
    id = json['id'];
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
    data['id'] = id;
    return data;
  }
}

class SettingsConfigModel {
  String? companyName;
  String? email;
  String? mobile;
  String? country;
  String? address;
  Timezone? timezone;
  String? timeFormat;
  Currency? currency;
  String? currencySide;
  int? decimalPoint;
  String? cookiesText;
  bool? guestCheckout;
  String? logo;
  String? favicon;
  bool? maintenance;
  SocialLinks? socialLinks;
  AppDefaultCountryCodeConfigModel? defaultCountryCode;
  String? websiteUrl;

  SettingsConfigModel({
    this.companyName,
    this.email,
    this.mobile,
    this.country,
    this.address,
    this.timezone,
    this.timeFormat,
    this.currency,
    this.currencySide,
    this.decimalPoint,
    this.cookiesText,
    this.guestCheckout,
    this.logo,
    this.favicon,
    this.maintenance,
    this.socialLinks,
    this.defaultCountryCode,
    this.websiteUrl,
  });

  SettingsConfigModel.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    email = json['email'];
    mobile = json['mobile'];
    country = json['country'];
    address = json['address'];
    timezone = json['timezone'] != null ? Timezone.fromJson(json['timezone']) : null;
    timeFormat = json['timeFormat'];
    currency = json['currency'] != null ? Currency.fromJson(json['currency']) : null;
    currencySide = json['currencySide'];
    if (json['decimalPoint'] != null && json['decimalPoint'] != '') {
      decimalPoint = int.parse(json['decimalPoint'].toString());
    } else {
      decimalPoint = 2;
    }
    cookiesText = json['cookiesText'];
    guestCheckout = json['guestCheckout'];
    logo = json['logo'];
    favicon = json['favicon'];
    maintenance = json['maintenance'];
    socialLinks = json['socialLinks'] != null ? SocialLinks.fromJson(json['socialLinks']) : null;
    defaultCountryCode = json['defaultCountryCode'] != null ? AppDefaultCountryCodeConfigModel.fromJson(json['defaultCountryCode']) : null;
    websiteUrl = json['websiteUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyName'] = companyName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['country'] = country;
    data['address'] = address;
    if (timezone != null) {
      data['timezone'] = timezone!.toJson();
    }
    data['timeFormat'] = timeFormat;
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    data['currencySide'] = currencySide;
    data['decimalPoint'] = decimalPoint;
    data['cookiesText'] = cookiesText;
    data['guestCheckout'] = guestCheckout;
    data['logo'] = logo;
    data['favicon'] = favicon;
    data['maintenance'] = maintenance;
    if (socialLinks != null) {
      data['socialLinks'] = socialLinks!.toJson();
    }
    if (defaultCountryCode != null) {
      data['defaultCountryCode'] = defaultCountryCode!.toJson();
    }
    data['websiteUrl'] = websiteUrl;
    return data;
  }
}

class Timezone {
  String? value;
  String? abbr;
  String? offset;
  String? isdst;
  String? text;
  List<String>? utc;

  Timezone({this.value, this.abbr, this.offset, this.isdst, this.text, this.utc});

  Timezone.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    abbr = json['abbr'];
    offset = json['offset'];
    isdst = json['isdst'];
    text = json['text'];
    utc = json['utc'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['abbr'] = abbr;
    data['offset'] = offset;
    data['isdst'] = isdst;
    data['text'] = text;
    data['utc'] = utc;
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

class SocialLinks {
  String? facebook;
  String? instagram;
  String? x;
  String? youtube;
  String? linked;
  String? pinterest;
  String? playstore;
  String? appstore;
  String? vimeo;

  SocialLinks({this.facebook, this.instagram, this.x, this.youtube, this.linked, this.pinterest, this.playstore, this.appstore, this.vimeo});

  SocialLinks.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'];
    instagram = json['instagram'];
    x = json['x'];
    youtube = json['youtube'];
    linked = json['linked'];
    pinterest = json['pinterest'];
    playstore = json['playstore'];
    appstore = json['appstore'];
    vimeo = json['vimeo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['facebook'] = facebook;
    data['instagram'] = instagram;
    data['x'] = x;
    data['youtube'] = youtube;
    data['linked'] = linked;
    data['pinterest'] = pinterest;
    data['playstore'] = playstore;
    data['appstore'] = appstore;
    data['vimeo'] = vimeo;
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

class DefaultLocaleConfigModel {
  String? name;
  String? nativeName;
  String? code;
  String? direction;
  bool? isDefault;
  bool? status;
  String? image;

  DefaultLocaleConfigModel({this.name, this.nativeName, this.code, this.direction, this.isDefault, this.status, this.image});

  DefaultLocaleConfigModel.fromJson(Map<String, dynamic> json) {
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

class DriverConfigModel {
  String? driverLoginWith;
  String? driverResetPasswordWith;
  bool? selfRegistration;

  DriverConfigModel({this.driverLoginWith, this.driverResetPasswordWith, this.selfRegistration});

  DriverConfigModel.fromJson(Map<String, dynamic> json) {
    driverLoginWith = json['driverLoginWith'];
    driverResetPasswordWith = json['driverResetPasswordWith'];
    selfRegistration = json['selfRegistration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverLoginWith'] = driverLoginWith;
    data['driverResetPasswordWith'] = driverResetPasswordWith;
    data['selfRegistration'] = selfRegistration;
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
