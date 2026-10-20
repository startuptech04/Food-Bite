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

class VendorMediaListModel {
  List<MediaResultModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  VendorMediaListModel({this.results, this.page, this.limit, this.totalPages, this.totalResults});

  VendorMediaListModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <MediaResultModel>[];
      json['results'].forEach((v) {
        results!.add(MediaResultModel.fromJson(v));
      });
    }
    page = int.parse(json['page'].toString());
    limit = int.parse(json['limit'].toString());
    totalPages = int.parse(json['totalPages'].toString());
    totalResults = int.parse(json['totalResults'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    return data;
  }
}

class MediaResultModel {
  String? path;
  String? uid;
  String? id;

  MediaResultModel({this.path, this.uid, this.id});

  MediaResultModel.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    uid = json['uid'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    data['uid'] = uid;
    data['id'] = id;
    return data;
  }
}
