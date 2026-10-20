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

class FoodListModel {
  List<FoodList>? custom;
  List<FoodList>? main;
  List<Count>? count;
  final String locale;

  FoodListModel({this.custom, this.main, this.count, required this.locale});

  FoodListModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['custom'] != null) {
      custom = <FoodList>[];
      json['custom'].forEach((v) {
        custom!.add(FoodList.fromJson(v, locale));
      });
    }
    if (json['main'] != null) {
      main = <FoodList>[];
      json['main'].forEach((v) {
        main!.add(FoodList.fromJson(v, locale));
      });
    }
    if (json['count'] != null) {
      count = <Count>[];
      json['count'].forEach((v) {
        count!.add(Count.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (custom != null) {
      data['custom'] = custom!.map((v) => v.toJson()).toList();
    }
    if (main != null) {
      data['main'] = main!.map((v) => v.toJson()).toList();
    }
    if (count != null) {
      data['count'] = count!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodList {
  List<FoodModel>? foods;
  String? categoryId;
  String? categoryName;
  List<CategoryTranslations>? categoryTranslations;
  bool isOpen = true;
  final String locale;
  FoodList({this.foods, this.categoryId, this.categoryName, this.categoryTranslations, this.isOpen = true, required this.locale});

  FoodList.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['foods'] != null) {
      foods = <FoodModel>[];
      json['foods'].forEach((v) {
        foods!.add(FoodModel.fromJson(v, locale));
      });
    }
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    if (json['category_translations'] != null) {
      categoryTranslations = <CategoryTranslations>[];
      json['category_translations'].forEach((v) {
        categoryTranslations!.add(CategoryTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && categoryTranslations!.isNotEmpty) {
        final int localeIndex = categoryTranslations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (categoryTranslations![localeIndex].value!.isNotEmpty) {
            categoryName = categoryTranslations![localeIndex].value!;
          }
        }
      }
    }
    isOpen = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (foods != null) {
      data['foods'] = foods!.map((v) => v.toJson()).toList();
    }
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    if (categoryTranslations != null) {
      data['category_translations'] = categoryTranslations!.map((v) => v.toJson()).toList();
    }
    data['isOpen'] = true;
    return data;
  }
}

class FoodModel {
  String? id;
  String? name;
  double? price;
  bool? inStock;
  String? foodType;
  String? shortDescription;
  bool? recommended;
  String? image;
  String? status;
  List<FoodTranslations>? foodTranslations;
  final String locale;

  FoodModel({this.id, this.name, this.price, this.inStock, this.foodType, this.shortDescription, this.recommended, this.image, this.status, this.foodTranslations, required this.locale});

  FoodModel.fromJson(Map<String, dynamic> json, this.locale) {
    id = json['id'];
    name = json['name'];
    price = double.parse(json['price'].toString());
    inStock = json['inStock'];
    foodType = json['foodType'];
    shortDescription = json['shortDescription'];
    recommended = json['recommended'];
    image = json['image'];
    status = json['status'];
    if (json['food_translations'] != null) {
      foodTranslations = <FoodTranslations>[];
      json['food_translations'].forEach((v) {
        foodTranslations!.add(FoodTranslations.fromJson(v));
      });
      if (locale.isNotEmpty && foodTranslations!.isNotEmpty) {
        final int localeIndex = foodTranslations!.indexWhere((tLocale) => tLocale.code! == locale);
        if (localeIndex != -1) {
          if (foodTranslations![localeIndex].title!.isNotEmpty) {
            name = foodTranslations![localeIndex].title!;
          }
          if (foodTranslations![localeIndex].shortDescription!.isNotEmpty) {
            shortDescription = foodTranslations![localeIndex].shortDescription!;
          }
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['inStock'] = inStock;
    data['foodType'] = foodType;
    data['shortDescription'] = shortDescription;
    data['recommended'] = recommended;
    data['image'] = image;
    data['status'] = status;
    if (foodTranslations != null) {
      data['food_translations'] = foodTranslations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? title;
  String? shortDescription;

  FoodTranslations({this.name, this.code, this.nativeName, this.title, this.shortDescription});

  FoodTranslations.fromJson(Map<String, dynamic> json) {
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

class CategoryTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  CategoryTranslations({this.name, this.code, this.nativeName, this.value});

  CategoryTranslations.fromJson(Map<String, dynamic> json) {
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

class Count {
  int? all;
  int? hold;
  int? photoreject;
  int? qualityreject;
  int? sizereject;
  int? reject;
  int? hide;

  Count({this.all, this.hold, this.photoreject, this.qualityreject, this.sizereject, this.reject, this.hide});

  Count.fromJson(Map<String, dynamic> json) {
    all = int.parse(json['all'].toString());
    hold = int.parse(json['hold'].toString());
    photoreject = int.parse(json['photoreject'].toString());
    qualityreject = int.parse(json['qualityreject'].toString());
    sizereject = int.parse(json['sizereject'].toString());
    reject = int.parse(json['reject'].toString());
    hide = int.parse(json['hide'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['all'] = all;
    data['hold'] = hold;
    data['photoreject'] = photoreject;
    data['qualityreject'] = qualityreject;
    data['sizereject'] = sizereject;
    data['reject'] = reject;
    data['hide'] = hide;
    return data;
  }
}
