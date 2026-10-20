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

class OtpVerificationResponseModel {
  bool? sent;
  String? provider;
  String? mode;
  int? otpLength;
  bool? canResendOtp;
  String? target;
  String? method;
  String? id;

  OtpVerificationResponseModel({
    this.sent,
    this.provider,
    this.mode,
    this.otpLength,
    this.canResendOtp,
    this.target,
    this.method,
    this.id,
  });

  OtpVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    sent = json['sent'];
    provider = json['provider'];
    mode = json['mode'];
    otpLength = json['otpLength'];
    canResendOtp = json['canResendOtp'];
    target = json['target'];
    method = json['method'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sent'] = sent;
    data['provider'] = provider;
    data['mode'] = mode;
    data['otpLength'] = otpLength;
    data['canResendOtp'] = canResendOtp;
    data['target'] = target;
    data['method'] = method;
    data['id'] = id;
    return data;
  }
}
