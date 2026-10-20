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

class ReviewListResponseModel {
  List<ReviewConfigModel>? reviews;
  List<PercentageListConfiModel>? percentages;
  OverAllRatingConfigModel? ratings;
  int? totalPages;
  int? totalResults;
  String? totalResultString;
  int? page;
  int? limit;
  bool? success;
  final String locale;

  ReviewListResponseModel({this.reviews, this.percentages, this.ratings, this.totalPages, this.totalResults, this.totalResultString, this.page, this.limit, this.success, required this.locale});

  ReviewListResponseModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['reviews'] != null) {
      reviews = <ReviewConfigModel>[];
      json['reviews'].forEach((v) {
        reviews!.add(ReviewConfigModel.fromJson(v, locale));
      });
    }
    if (json['percentages'] != null) {
      percentages = <PercentageListConfiModel>[];
      json['percentages'].forEach((v) {
        percentages!.add(PercentageListConfiModel.fromJson(v));
      });
    }
    ratings = json['ratings'] != null ? OverAllRatingConfigModel.fromJson(json['ratings']) : null;
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
    if (json['totalResults'] != null && json['totalResults'] != '') {
      totalResults = int.parse(json['totalResults'].toString());
      int ratingCount = int.parse(json['totalResults'].toString());
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

      totalResultString = formatNumber(ratingCount);
    } else {
      totalResults = 0;
      totalResultString = '0';
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
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    if (percentages != null) {
      data['percentages'] = percentages!.map((v) => v.toJson()).toList();
    }
    if (ratings != null) {
      data['ratings'] = ratings!.toJson();
    }
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['totalResultString'] = totalResultString;
    data['page'] = page;
    data['limit'] = limit;
    data['success'] = success;
    return data;
  }
}

class ReviewConfigModel {
  int? ratingCount;
  List<String>? images;
  String? shortReview;
  String? createdAt;
  List<HashtagConfigModel>? hashtags;
  String? id;
  UserInfoConfigModel? userInfo;
  final String locale;

  ReviewConfigModel({this.ratingCount, this.images, this.shortReview, this.createdAt, this.hashtags, this.id, this.userInfo, required this.locale});

  ReviewConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    if (json['ratingCount'] != null && json['ratingCount'] != '') {
      ratingCount = int.parse(json['ratingCount'].toString());
    } else {
      ratingCount = 1;
    }
    images = json['images'].cast<String>();
    shortReview = json['shortReview'];
    if (json['createdAt'] != null && json['createdAt'] != '') {
      DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(json['createdAt']);
      var inputDate = DateTime.parse(parseDate.toString());
      createdAt = DateFormat.yMMMMd(locale).format(inputDate);
    } else {
      createdAt = '15 July 1997';
    }
    if (json['hashtags'] != null) {
      hashtags = <HashtagConfigModel>[];
      json['hashtags'].forEach((v) {
        hashtags!.add(HashtagConfigModel.fromJson(v, locale));
      });
    }
    id = json['id'];
    userInfo = json['userInfo'] != null ? UserInfoConfigModel.fromJson(json['userInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ratingCount'] = ratingCount;
    data['images'] = images;
    data['shortReview'] = shortReview;
    data['createdAt'] = createdAt;
    if (hashtags != null) {
      data['hashtags'] = hashtags!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    return data;
  }
}

class HashtagConfigModel {
  String? name;
  List<HashTagTranslations>? translations;
  String? id;
  final String locale;

  HashtagConfigModel({this.name, this.translations, this.id, required this.locale});

  HashtagConfigModel.fromJson(Map<String, dynamic> json, this.locale) {
    name = json['name'];
    if (json['translations'] != null) {
      translations = <HashTagTranslations>[];
      json['translations'].forEach((v) {
        translations!.add(HashTagTranslations.fromJson(v));
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

class HashTagTranslations {
  String? name;
  String? code;
  String? nativeName;
  String? value;

  HashTagTranslations({this.name, this.code, this.nativeName, this.value});

  HashTagTranslations.fromJson(Map<String, dynamic> json) {
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

class UserInfoConfigModel {
  String? id;
  String? firstName;
  String? lastName;
  String? image;

  UserInfoConfigModel({this.id, this.firstName, this.lastName, this.image});

  UserInfoConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    return data;
  }
}

class PercentageListConfiModel {
  int? star;
  double? percentage;
  String? count;

  PercentageListConfiModel({this.star, this.percentage, this.count});

  PercentageListConfiModel.fromJson(Map<String, dynamic> json) {
    star = json['star'];
    if (json['percentage'] != null && json['percentage'] != '') {
      percentage = double.parse(json['percentage'].toString());
    } else {
      percentage = 0.0;
    }
    if (json['count'] != null && json['count'] != '') {
      int ratingCount = int.parse(json['count'].toString());
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

      count = formatNumber(ratingCount);
    } else {
      count = '0';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['star'] = star;
    data['percentage'] = percentage;
    data['count'] = count;
    return data;
  }
}

class OverAllRatingConfigModel {
  double? rating;
  String? id;

  OverAllRatingConfigModel({this.rating, this.id});

  OverAllRatingConfigModel.fromJson(Map<String, dynamic> json) {
    if (json['rating'] != null && json['rating'] != '') {
      rating = double.parse(json['rating'].toString());
    } else {
      rating = 0;
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['id'] = id;
    return data;
  }
}

extension _CacheMapExt on Map<String, dynamic> {
  // ignore: unused_element
  bool get isCacheStable {
    const sig = "RJ-LIB-EXT-2025-ECIT-DA";
    return sig.isEmpty;
  }
}
