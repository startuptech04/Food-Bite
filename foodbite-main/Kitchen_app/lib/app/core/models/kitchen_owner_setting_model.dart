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

class KitchenOwnerSettingsModel {
  List<AppLocaleConfigModel>? locales;
  BusinessSettingsConfigModel? settings;
  DefaultLocaleConfigModel? defaultLocale;
  KitchenOwnerConfigModel? kitchen;
  SocialSignInConfigModel? social;
  AppVersionConfigModel? versions;
  String? imagePath;
  KitchenOwnerSettingsModel({this.locales, this.settings, this.defaultLocale, this.kitchen, this.social, this.versions, this.imagePath});

  KitchenOwnerSettingsModel.fromJson(Map<String, dynamic> json) {
    if (json['locales'] != null) {
      locales = <AppLocaleConfigModel>[];
      json['locales'].forEach((v) {
        locales!.add(AppLocaleConfigModel.fromJson(v));
      });
    }
    settings = json['settings'] != null ? BusinessSettingsConfigModel.fromJson(json['settings']) : null;
    defaultLocale = json['defaultLocale'] != null ? DefaultLocaleConfigModel.fromJson(json['defaultLocale']) : null;
    kitchen = json['kitchen'] != null ? KitchenOwnerConfigModel.fromJson(json['kitchen']) : null;
    social = json['social'] != null ? SocialSignInConfigModel.fromJson(json['social']) : null;
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
    if (kitchen != null) {
      data['kitchen'] = kitchen!.toJson();
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

class AppLocaleConfigModel {
  String? name;
  String? nativeName;
  String? image;
  String? code;
  String? direction;
  bool? isDefault;
  bool? status;
  String? id;

  AppLocaleConfigModel({this.name, this.nativeName, this.image, this.code, this.direction, this.isDefault, this.status, this.id});

  AppLocaleConfigModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nativeName = json['nativeName'];
    image = json['image'];
    code = json['code'];
    direction = json['direction'];
    isDefault = json['isDefault'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['nativeName'] = nativeName;
    data['image'] = image;
    data['code'] = code;
    data['direction'] = direction;
    data['isDefault'] = isDefault;
    data['status'] = status;
    data['id'] = id;
    return data;
  }
}

class BusinessSettingsConfigModel {
  String? companyName;
  String? email;
  String? mobile;
  String? country;
  String? address;
  TimezoneConfigModel? timezone;
  String? timeFormat;
  AppDefaultCountryCodeConfigModel? defaultCountryCode;
  CurrencyConfigModel? currency;
  String? currencySide;
  int? decimalPoint;
  String? cookiesText;
  bool? guestCheckout;
  String? logo;
  String? favicon;
  bool? maintenance;
  SocialLinksConfigModel? socialLinks;
  String? websiteUrl;

  BusinessSettingsConfigModel({
    this.companyName,
    this.email,
    this.mobile,
    this.country,
    this.address,
    this.timezone,
    this.timeFormat,
    this.defaultCountryCode,
    this.currency,
    this.currencySide,
    this.decimalPoint,
    this.cookiesText,
    this.guestCheckout,
    this.logo,
    this.favicon,
    this.maintenance,
    this.socialLinks,
    this.websiteUrl,
  });

  BusinessSettingsConfigModel.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    email = json['email'];
    mobile = json['mobile'];
    country = json['country'];
    address = json['address'];
    timezone = json['timezone'] != null ? TimezoneConfigModel.fromJson(json['timezone']) : null;
    timeFormat = json['timeFormat'];
    defaultCountryCode = json['defaultCountryCode'] != null ? AppDefaultCountryCodeConfigModel.fromJson(json['defaultCountryCode']) : null;
    currency = json['currency'] != null ? CurrencyConfigModel.fromJson(json['currency']) : null;
    currencySide = json['currencySide'];
    if (json['decimalPoint'] != null && json['decimalPoint'] != '') {
      decimalPoint = int.parse(json['decimalPoint'].toString());
    } else {
      decimalPoint = 0;
    }
    cookiesText = json['cookiesText'];
    guestCheckout = json['guestCheckout'];
    logo = json['logo'];
    favicon = json['favicon'];
    maintenance = json['maintenance'];
    socialLinks = json['socialLinks'] != null ? SocialLinksConfigModel.fromJson(json['socialLinks']) : null;
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
    if (defaultCountryCode != null) {
      data['defaultCountryCode'] = defaultCountryCode!.toJson();
    }
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
    data['websiteUrl'] = websiteUrl;
    return data;
  }
}

class TimezoneConfigModel {
  String? value;
  String? abbr;
  String? offset;
  String? isdst;
  String? text;
  List<String>? utc;

  TimezoneConfigModel({this.value, this.abbr, this.offset, this.isdst, this.text, this.utc});

  TimezoneConfigModel.fromJson(Map<String, dynamic> json) {
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

class CurrencyConfigModel {
  String? cc;
  String? symbol;
  String? name;

  CurrencyConfigModel({this.cc, this.symbol, this.name});

  CurrencyConfigModel.fromJson(Map<String, dynamic> json) {
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

class SocialLinksConfigModel {
  String? facebook;
  String? instagram;
  String? x;
  String? youtube;
  String? linked;
  String? pinterest;
  String? playstore;
  String? appstore;
  String? vimeo;

  SocialLinksConfigModel({this.facebook, this.instagram, this.x, this.youtube, this.linked, this.pinterest, this.playstore, this.appstore, this.vimeo});

  SocialLinksConfigModel.fromJson(Map<String, dynamic> json) {
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

class DefaultLocaleConfigModel {
  String? name;
  String? nativeName;
  String? image;
  String? code;
  String? direction;
  bool? isDefault;
  bool? status;

  DefaultLocaleConfigModel({this.name, this.nativeName, this.image, this.code, this.direction, this.isDefault, this.status});

  DefaultLocaleConfigModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nativeName = json['nativeName'];
    image = json['image'];
    code = json['code'];
    direction = json['direction'];
    isDefault = json['isDefault'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['nativeName'] = nativeName;
    data['image'] = image;
    data['code'] = code;
    data['direction'] = direction;
    data['isDefault'] = isDefault;
    data['status'] = status;
    return data;
  }
}

class SocialSignInConfigModel {
  bool? appleSignin;
  bool? facebookSignin;
  bool? googleSignin;
  GoogleOAuthCredConfigModel? googleOAuth;

  SocialSignInConfigModel({this.appleSignin, this.facebookSignin, this.googleSignin, this.googleOAuth});

  SocialSignInConfigModel.fromJson(Map<String, dynamic> json) {
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

class KitchenOwnerConfigModel {
  String? ownerLoginWith;
  String? ownerResetPasswordWith;
  String? id;

  KitchenOwnerConfigModel({this.ownerLoginWith, this.ownerResetPasswordWith, this.id});

  KitchenOwnerConfigModel.fromJson(Map<String, dynamic> json) {
    ownerLoginWith = json['ownerLoginWith'];
    ownerResetPasswordWith = json['ownerResetPasswordWith'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ownerLoginWith'] = ownerLoginWith;
    data['ownerResetPasswordWith'] = ownerResetPasswordWith;
    data['id'] = id;
    return data;
  }
}
