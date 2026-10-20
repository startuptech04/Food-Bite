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

import 'package:intl/intl.dart';

class PosCustomDateBusinessInsightModel {
  TotalSalesAndAverageTopModel? totalSold;
  List<ChartDataConfigModel>? chartData;
  List<TrendingCustomDatePosBusinessInsightFoodListConfigModel>? trendingFoods;
  bool? success;
  final String locale;
  PosCustomDateBusinessInsightModel({this.totalSold, this.chartData, this.trendingFoods, this.success, required this.locale});

  PosCustomDateBusinessInsightModel.fromJson(Map<String, dynamic> json, this.locale) {
    totalSold = json['totalSold'] != null ? TotalSalesAndAverageTopModel.fromJson(json['totalSold']) : null;
    if (json['chartData'] != null) {
      chartData = <ChartDataConfigModel>[];
      json['chartData'].forEach((v) {
        chartData!.add(ChartDataConfigModel.fromJson(v, locale));
      });
    } else {
      chartData = [];
    }
    if (json['trendingFoods'] != null) {
      trendingFoods = <TrendingCustomDatePosBusinessInsightFoodListConfigModel>[];
      json['trendingFoods'].forEach((v) {
        trendingFoods!.add(TrendingCustomDatePosBusinessInsightFoodListConfigModel.fromJson(v, locale));
      });
    } else {
      trendingFoods = [];
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (totalSold != null) {
      data['totalSold'] = totalSold!.toJson();
    }
    if (chartData != null) {
      data['chartData'] = chartData!.map((v) => v.toJson()).toList();
    }
    if (trendingFoods != null) {
      data['trendingFoods'] = trendingFoods!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class TotalSalesAndAverageTopModel {
  String? totalSold;
  String? averageSold;

  TotalSalesAndAverageTopModel({this.totalSold, this.averageSold});

  TotalSalesAndAverageTopModel.fromJson(Map<String, dynamic> json) {
    if (json['totalSold'] != null && json['totalSold'] != '') {
      double ratingCount = double.parse(json['totalSold'].toString());
      String formatNumber(num number) {
        if (number >= 1000000000) {
          return '${(number / 1000000000).toStringAsFixed(1)}B';
        } else if (number >= 1000000) {
          return '${(number / 1000000).toStringAsFixed(1)}M';
        } else if (number >= 1000) {
          return '${(number / 1000).toStringAsFixed(1)}K';
        } else {
          return number.toString();
        }
      }

      totalSold = formatNumber(ratingCount);
    } else {
      totalSold = '0';
    }

    if (json['averageSold'] != null && json['averageSold'] != '') {
      double ratingCount = double.parse(json['averageSold'].toString());
      String formatNumber(num number) {
        if (number >= 1000000000) {
          return '${(number / 1000000000).toStringAsFixed(1)}B';
        } else if (number >= 1000000) {
          return '${(number / 1000000).toStringAsFixed(1)}M';
        } else if (number >= 1000) {
          return '${(number / 1000).toStringAsFixed(1)}K';
        } else {
          return number.toString();
        }
      }

      averageSold = formatNumber(ratingCount);
    } else {
      averageSold = '0';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalSold'] = totalSold;
    data['averageSold'] = averageSold;
    return data;
  }
}

class ChartDataConfigModel {
  String? date;
  double? soldCount;
  final String locale;
  ChartDataConfigModel({this.date, this.soldCount, required this.locale});

  ChartDataConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['date'] != null && json['date'] != '') {
      DateTime parsedDate = DateTime.parse(json['date']);
      date = DateFormat('MMM dd', locale).format(parsedDate);
    } else {
      date = 'July 15';
    }
    if (json['soldCount'] != null && json['soldCount'] != '') {
      soldCount = double.parse(json['soldCount'].toString());
    } else {
      soldCount = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['soldCount'] = soldCount;
    return data;
  }
}

class TrendingCustomDatePosBusinessInsightFoodListConfigModel {
  int? count;
  BusinessInsighFoodDetailConfigModel? foodDetails;
  double? offerPrice = 0.0;
  final String locale;
  TrendingCustomDatePosBusinessInsightFoodListConfigModel({this.count, this.foodDetails, this.offerPrice, required this.locale});

  TrendingCustomDatePosBusinessInsightFoodListConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['count'] != null && json['count'] != '') {
      count = int.parse(json['count'].toString());
    } else {
      count = 0;
    }
    foodDetails = json['foodDetails'] != null ? BusinessInsighFoodDetailConfigModel.fromJson(json['foodDetails'], locale, count!) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (foodDetails != null) {
      data['foodDetails'] = foodDetails!.toJson();
    }
    return data;
  }
}

class BusinessInsighFoodDetailConfigModel {
  String? name;
  String? image;
  List<FoodTranslation>? translations;
  String? id;
  double? price;
  double? offerPrice = 0.0;
  final int count;
  final String locale;
  BusinessInsighFoodDetailConfigModel({this.name, this.image, this.translations, this.id, this.price, this.offerPrice, required this.count, required this.locale});

  BusinessInsighFoodDetailConfigModel.fromJson(Map<String, dynamic> json, this.locale, this.count) {
    name = json['name'];
    image = json['image'];
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
    if (json['price'] != null && json['price'] != '') {
      price = double.parse(json['price'].toString());
      if (json['taxationEnable'] != null && json['taxationEnable'] != '' && json['taxationEnable'] == true) {
        double taxPercentage = 0;
        if (json['foodtaxations'] != null) {
          json['foodtaxations'].forEach((v) {
            FoodTaxationConfigModel taxation = FoodTaxationConfigModel.fromJson(v);
            taxPercentage = (taxPercentage + taxation.taxAmount!);
          });
        }
        if (taxPercentage > 0) {
          double basePrice = price!;
          String finalPriceString = (basePrice + (taxPercentage / 100) * basePrice).toStringAsFixed(2);
          double finalPrice = double.parse(finalPriceString);
          price = finalPrice;
        }
      }
    } else {
      price = 0.0;
      offerPrice = 0.0;
    }

    if (json['discount'] != null && json['discount'] != '') {
      double discount = double.parse(json['discount'].toString());
      if (discount > 0) {
        if (json['discountType'] == '%') {
          String discountValue = (double.parse(price.toString()) - (double.parse(price.toString()) * double.parse(json['discount'].toString()) / 100)).toStringAsFixed(2);
          offerPrice = double.parse(discountValue);
        } else {
          String discountValue = (double.parse(price.toString()) - double.parse(json['discount'].toString())).toStringAsFixed(2);
          offerPrice = double.parse(discountValue);
        }
      } else {
        offerPrice = price;
      }
    } else {
      offerPrice = price;
    }

    String total = (double.parse(offerPrice.toString()) * double.parse(count.toString())).toStringAsFixed(2);
    offerPrice = double.parse(total);
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
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

class FoodTaxationConfigModel {
  String? taxName;
  String? id;
  double? taxAmount;

  FoodTaxationConfigModel({this.taxName, this.id, this.taxAmount});

  FoodTaxationConfigModel.fromJson(Map<String, dynamic> json) {
    taxName = json['taxName'];
    id = json['id'];
    if (json['taxAmount'] != null && json['taxAmount'] != '') {
      taxAmount = double.parse(json['taxAmount'].toString());
    } else {
      taxAmount = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taxName'] = taxName;
    data['id'] = id;
    data['taxAmount'] = taxAmount;
    return data;
  }
}
