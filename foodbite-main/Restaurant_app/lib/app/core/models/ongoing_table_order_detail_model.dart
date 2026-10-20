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

class OngoingTableOrderDetailModel {
  List<OngoingCartItemConfig>? items;
  BusinessDetailConfigModel? business;
  PackagingDetailConfigModel? packaging;
  bool? success;
  final String locale;
  OngoingTableOrderDetailModel({this.items, this.business, this.packaging, this.success, required this.locale});

  OngoingTableOrderDetailModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['items'] != null) {
      items = <OngoingCartItemConfig>[];
      json['items'].forEach((v) {
        items!.add(OngoingCartItemConfig.fromJson(v, locale));
      });
    }
    business = json['business'] != null ? BusinessDetailConfigModel.fromJson(json['business']) : null;
    packaging = json['packaging'] != null ? PackagingDetailConfigModel.fromJson(json['packaging']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (business != null) {
      data['business'] = business!.toJson();
    }
    if (packaging != null) {
      data['packaging'] = packaging!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class OngoingCartItemConfig {
  String? uuid;
  List<SavedAddonConfigModel>? addons;
  String? food;
  int? quantity;
  List<SavedVariationConfigModel>? variations;
  String? instruction;
  List<FoodTaxationConfigModel>? foodtaxations;
  String? id;
  FoodInfoConfigModel? foodInfo;
  double? realPrice;
  double? itemPrice;
  double? discountPrice;
  String? optionName;
  final String locale;

  OngoingCartItemConfig({
    this.uuid,
    this.addons,
    this.food,
    this.quantity,
    this.variations,
    this.instruction,
    this.foodtaxations,
    this.id,
    this.foodInfo,
    this.realPrice,
    this.itemPrice,
    this.discountPrice,
    this.optionName,
    required this.locale,
  });

  OngoingCartItemConfig.fromJson(Map<String, dynamic> json, this.locale) {
    uuid = json['uuid'];
    if (json['addons'] != null) {
      addons = <SavedAddonConfigModel>[];
      json['addons'].forEach((v) {
        addons!.add(SavedAddonConfigModel.fromJson(v, locale));
      });
    } else {
      addons = [];
    }
    food = json['food'];
    if (json['quantity'] != null && json['quantity'] != '') {
      quantity = int.parse(json['quantity'].toString());
    } else {
      quantity = 1;
    }
    if (json['variations'] != null) {
      variations = <SavedVariationConfigModel>[];
      json['variations'].forEach((v) {
        variations!.add(SavedVariationConfigModel.fromJson(v));
      });
    } else {
      variations = [];
    }
    instruction = json['instruction'];
    if (json['foodtaxations'] != null) {
      foodtaxations = <FoodTaxationConfigModel>[];
      json['foodtaxations'].forEach((v) {
        foodtaxations!.add(FoodTaxationConfigModel.fromJson(v));
      });
    } else {
      foodtaxations = [];
    }
    id = json['id'];
    foodInfo = json['foodInfo'] != null ? FoodInfoConfigModel.fromJson(json['foodInfo'], locale) : null;
    if (json['realPrice'] != null && json['realPrice'] != '') {
      realPrice = double.parse(json['realPrice'].toString());
    } else {
      realPrice = 0;
    }
    if (json['itemPrice'] != null && json['itemPrice'] != '') {
      itemPrice = double.parse(json['itemPrice'].toString());
    } else {
      itemPrice = 0;
    }
    if (json['discountPrice'] != null && json['discountPrice'] != '') {
      discountPrice = double.parse(json['discountPrice'].toString());
    } else {
      discountPrice = 0;
    }
    if (json['optionName'] != null && json['optionName'] != '') {
      optionName = json['optionName'];
    } else {
      optionName = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    if (addons != null) {
      data['addons'] = addons!.map((v) => v.toJson()).toList();
    }
    data['food'] = food;
    data['quantity'] = quantity;
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    data['instruction'] = instruction;
    if (foodtaxations != null) {
      data['foodtaxations'] = foodtaxations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    if (foodInfo != null) {
      data['foodInfo'] = foodInfo!.toJson();
    }
    data['realPrice'] = realPrice;
    data['itemPrice'] = itemPrice;
    data['discountPrice'] = discountPrice;
    data['optionName'] = optionName;
    return data;
  }
}

class SavedAddonConfigModel {
  String? name;
  List<AddonTranslations>? translations;
  String? id;
  double? price;
  final String locale;
  SavedAddonConfigModel({this.name, this.translations, this.id, this.price, required this.locale});

  SavedAddonConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <AddonTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(AddonTranslations.fromJson(v));
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
    if (json['price'] != null && json['price'] != '') {
      price = double.parse(json['price'].toString());
    } else {
      price = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['price'] = price;
    return data;
  }
}

class AddonTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  AddonTranslations({this.name, this.code, this.nativeName, this.value});

  AddonTranslations.fromJson(Map<String, dynamic> json) {
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

class FoodTaxationConfigModel {
  String? id;
  double? taxAmount;

  FoodTaxationConfigModel({this.id, this.taxAmount});

  FoodTaxationConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['taxAmount'] != null && json['taxAmount'] != '') {
      taxAmount = double.parse(json['taxAmount'].toString());
    } else {
      taxAmount = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['taxAmount'] = taxAmount;
    return data;
  }
}

class SavedVariationConfigModel {
  String? variation;
  List<String>? selected;

  SavedVariationConfigModel({this.variation, this.selected});

  SavedVariationConfigModel.fromJson(Map<String, dynamic> json) {
    variation = json['variation'];
    selected = json['selected'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variation'] = variation;
    data['selected'] = selected;
    return data;
  }
}

class FoodInfoConfigModel {
  String? id;
  String? name;
  String? discountType;
  List<FoodVariationConfigModel>? foodVariations;
  bool? taxationEnable;
  double? price;
  double? discount;
  String? foodType;
  List<FoodTranslation>? translations;
  final String locale;
  FoodInfoConfigModel({this.id, this.name, this.discountType, this.foodVariations, this.taxationEnable, this.price, this.discount, this.foodType, this.translations, required this.locale});

  FoodInfoConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    discountType = json['discountType'];
    if (json['foodVariations'] != null) {
      foodVariations = <FoodVariationConfigModel>[];
      json['foodVariations'].forEach((v) {
        foodVariations!.add(FoodVariationConfigModel.fromJson(v));
      });
    } else {
      foodVariations = [];
    }
    taxationEnable = json['taxationEnable'];
    if (json['price'] != null && json['price'] != '') {
      price = double.parse(json['price'].toString());
    } else {
      price = 0;
    }
    if (json['discount'] != null && json['discount'] != '') {
      discount = double.parse(json['discount'].toString());
    } else {
      discount = 0;
    }
    foodType = json['foodType'];
    if (json['translations'] != null) {
      translations = <FoodTranslation>[];
      json['translations'].forEach((v) {
        translations!.add(FoodTranslation.fromJson(v));
      });
      if (locale.isNotEmpty && translations!.isNotEmpty) {
        final int localeIndex = translations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (translations![localeIndex].title!.isNotEmpty) {
            name = translations![localeIndex].title!;
          }
        }
      }
    } else {
      translations = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['discountType'] = discountType;
    if (foodVariations != null) {
      data['foodVariations'] = foodVariations!.map((v) => v.toJson()).toList();
    }
    data['taxationEnable'] = taxationEnable;
    data['price'] = price;
    data['discount'] = discount;
    data['foodType'] = foodType;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodVariationConfigModel {
  bool? isRequired;
  String? title;
  String? type;
  int? min;
  int? max;
  List<FoodOptionConfigModel>? options;

  FoodVariationConfigModel({this.isRequired, this.title, this.type, this.min, this.max, this.options});

  FoodVariationConfigModel.fromJson(Map<String, dynamic> json) {
    if (json['isRequired'].toString().toLowerCase() == 'true' || json['isRequired'] == true) {
      isRequired = true;
    } else {
      isRequired = false;
    }
    title = json['title'];
    type = json['type'];
    if (json['min'] != null && json['min'] != '') {
      min = int.parse(json['min'].toString());
    } else {
      min = 1;
    }
    if (json['max'] != null && json['max'] != '') {
      max = int.parse(json['max'].toString());
    } else {
      max = 1;
    }
    // New Code
    if (json['min'] == '0') {
      min = 1;
    }
    if (json['max'] == '0') {
      max = 1;
    }
    if (min == 1 && max == 1) {
      type = 'single';
    }
    // New Code
    if (json['options'] != null) {
      options = <FoodOptionConfigModel>[];
      json['options'].forEach((v) {
        options!.add(FoodOptionConfigModel.fromJson(v));
      });
    } else {
      options = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isRequired'] = isRequired;
    data['title'] = title;
    data['type'] = type;
    data['min'] = min;
    data['max'] = max;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodOptionConfigModel {
  String? name;
  double? price;

  FoodOptionConfigModel({this.name, this.price});

  FoodOptionConfigModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['price'] != null && json['price'] != '') {
      price = double.parse(json['price'].toString());
    } else {
      price = 0.0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}

class FoodTranslation {
  String? name;
  String? code;
  String? nativeName;
  String? title;
  String? shortDescription;

  FoodTranslation({this.name, this.code, this.nativeName, this.title, this.shortDescription});

  FoodTranslation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    nativeName = json['nativeName'];
    title = json['title'];
    shortDescription = json['shortDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['nativeName'] = nativeName;
    data['title'] = title;
    data['shortDescription'] = shortDescription;
    return data;
  }
}

class BusinessDetailConfigModel {
  bool? includeTaxOnFood;
  String? foodTaxName;
  double? foodTaxAmount;
  String? foodTaxType;
  bool? additionalServiceCharge;
  String? additionalServiceName;
  double? additionalServiceAmount;
  String? id;

  BusinessDetailConfigModel({this.includeTaxOnFood, this.foodTaxName, this.foodTaxAmount, this.foodTaxType, this.additionalServiceCharge, this.additionalServiceName, this.additionalServiceAmount, this.id});

  BusinessDetailConfigModel.fromJson(Map<String, dynamic> json) {
    includeTaxOnFood = json['includeTaxOnFood'];
    foodTaxName = json['foodTaxName'];
    if (json['foodTaxAmount'] != null && json['foodTaxAmount'] != '') {
      foodTaxAmount = double.parse(json['foodTaxAmount'].toString());
    } else {
      foodTaxAmount = 0;
    }
    foodTaxType = json['foodTaxType'];
    additionalServiceCharge = json['additionalServiceCharge'];
    additionalServiceName = json['additionalServiceName'];
    if (json['additionalServiceAmount'] != null && json['additionalServiceAmount'] != '') {
      additionalServiceAmount = double.parse(json['additionalServiceAmount'].toString());
    } else {
      additionalServiceAmount = 0;
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['includeTaxOnFood'] = includeTaxOnFood;
    data['foodTaxName'] = foodTaxName;
    data['foodTaxAmount'] = foodTaxAmount;
    data['foodTaxType'] = foodTaxType;
    data['additionalServiceCharge'] = additionalServiceCharge;
    data['additionalServiceName'] = additionalServiceName;
    data['additionalServiceAmount'] = additionalServiceAmount;
    data['id'] = id;
    return data;
  }
}

class PackagingDetailConfigModel {
  bool? havePackagingCharges;
  double? packagingCharges;
  bool? includePackagesChargesInTax;
  double? packagingChargesTax;
  String? id;

  PackagingDetailConfigModel({this.havePackagingCharges, this.packagingCharges, this.includePackagesChargesInTax, this.packagingChargesTax, this.id});

  PackagingDetailConfigModel.fromJson(Map<String, dynamic> json) {
    havePackagingCharges = json['havePackagingCharges'];
    if (json['packagingCharges'] != null && json['packagingCharges'] != '') {
      packagingCharges = double.parse(json['packagingCharges'].toString());
    } else {
      packagingCharges = 0;
    }
    includePackagesChargesInTax = json['includePackagesChargesInTax'];
    if (json['packagingChargesTax'] != null && json['packagingChargesTax'] != '') {
      packagingChargesTax = double.parse(json['packagingChargesTax'].toString());
    } else {
      packagingChargesTax = 0;
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['havePackagingCharges'] = havePackagingCharges;
    data['packagingCharges'] = packagingCharges;
    data['includePackagesChargesInTax'] = includePackagesChargesInTax;
    data['packagingChargesTax'] = packagingChargesTax;
    data['id'] = id;
    return data;
  }
}
