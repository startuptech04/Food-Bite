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

class LoginWithPhoneOtpVerificationResponseModel {
  bool? sent;
  String? target;
  String? method;
  int? otpLength;
  bool? canResendOtp;
  String? id;
  String? provider;

  LoginWithPhoneOtpVerificationResponseModel({this.sent, this.target, this.method, this.otpLength, this.canResendOtp, this.id, this.provider});

  LoginWithPhoneOtpVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    sent = json['sent'];
    target = json['target'];
    method = json['method'];
    otpLength = json['otpLength'];
    canResendOtp = json['canResendOtp'];
    id = json['id'];
    provider = json['provider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sent'] = sent;
    data['target'] = target;
    data['method'] = method;
    data['otpLength'] = otpLength;
    data['canResendOtp'] = canResendOtp;
    data['id'] = id;
    data['provider'] = provider;
    return data;
  }
}
