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

class MyMediaFilesResponseModel {
  List<MediaFileConfigModel>? results;
  bool? success;

  MyMediaFilesResponseModel({this.results, this.success});

  MyMediaFilesResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <MediaFileConfigModel>[];
      json['results'].forEach((v) {
        results!.add(MediaFileConfigModel.fromJson(v));
      });
    } else {
      results = [];
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class MediaFileConfigModel {
  String? path;
  String? uid;
  String? id;

  MediaFileConfigModel({this.path, this.uid, this.id});

  MediaFileConfigModel.fromJson(Map<String, dynamic> json) {
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
