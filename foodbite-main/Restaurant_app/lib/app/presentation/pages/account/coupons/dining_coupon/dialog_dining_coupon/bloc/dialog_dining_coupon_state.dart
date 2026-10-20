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

part of 'dialog_dining_coupon_bloc.dart';

enum DialogDiningCouponStatus { loading, success, failure, changeDetail, submit, submitSuccess, submitFailed, update, updateSuccess, updateFailed }

extension DialogDiningCouponStatusX on DialogDiningCouponStatus {
  bool get isLoading => this == DialogDiningCouponStatus.loading;
  bool get isSuccess => this == DialogDiningCouponStatus.success;
  bool get isFailure => this == DialogDiningCouponStatus.failure;
  bool get isChangeDetail => this == DialogDiningCouponStatus.changeDetail;
  bool get isSubmit => this == DialogDiningCouponStatus.submit;
  bool get isSubmitSuccess => this == DialogDiningCouponStatus.submitSuccess;
  bool get isSubmitFailed => this == DialogDiningCouponStatus.submitFailed;
  bool get isUpdate => this == DialogDiningCouponStatus.update;
  bool get isUpdateSuccess => this == DialogDiningCouponStatus.updateSuccess;
  bool get isUpdateFailed => this == DialogDiningCouponStatus.updateFailed;
}

final class DialogDiningCouponState {
  final String couponId;
  final DiningCouponInfoResponseModel model;
  final DiningCouponNameField diningCouponName;
  final DiningCouponCodeField diningCouponCode;
  final DiningCouponLimitField diningCouponLimit;
  final DiningCouponStartDateField diningCouponStartDate;
  final DiningCouponExpireDateField diningCouponExpireDate;
  final DiningCouponMinDiscountField diningCouponMinDiscount;
  final DiningCouponMaxDiscountField diningCouponMaxDiscount;
  final DiningCouponPreBookingChargeField diningCouponPreBookingCharge;
  final DiningCouponTypeModel type;
  final List<DiningCouponTypeModel> typeList;
  final DiningCouponAvailabilityModel availability;
  final List<DiningCouponAvailabilityModel> availabilityList;
  final DiningCouponPreBookingModel preeBookingChargeRequired;
  final List<DiningCouponPreBookingModel> preeBookingChargeRequiredList;
  final bool isNew;
  final bool isValid;
  final DialogDiningCouponStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DialogDiningCouponState({
    this.couponId = '',
    required this.model,
    this.diningCouponName = const DiningCouponNameField.pure(),
    this.diningCouponCode = const DiningCouponCodeField.pure(),
    this.diningCouponLimit = const DiningCouponLimitField.pure(),
    this.diningCouponStartDate = const DiningCouponStartDateField.pure(),
    this.diningCouponExpireDate = const DiningCouponExpireDateField.pure(),
    this.diningCouponMinDiscount = const DiningCouponMinDiscountField.pure(),
    this.diningCouponMaxDiscount = const DiningCouponMaxDiscountField.pure(),
    this.diningCouponPreBookingCharge = const DiningCouponPreBookingChargeField.pure(),
    required this.type,
    this.typeList = const [],
    required this.availability,
    this.availabilityList = const [],
    required this.preeBookingChargeRequired,
    this.preeBookingChargeRequiredList = const [],
    this.isNew = false,
    this.isValid = false,
    this.status = DialogDiningCouponStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  DialogDiningCouponState copyWith({
    String? couponId,
    DiningCouponInfoResponseModel? model,
    DiningCouponNameField? diningCouponName,
    DiningCouponCodeField? diningCouponCode,
    DiningCouponLimitField? diningCouponLimit,
    DiningCouponStartDateField? diningCouponStartDate,
    DiningCouponExpireDateField? diningCouponExpireDate,
    DiningCouponMinDiscountField? diningCouponMinDiscount,
    DiningCouponMaxDiscountField? diningCouponMaxDiscount,
    DiningCouponPreBookingChargeField? diningCouponPreBookingCharge,
    DiningCouponTypeModel? type,
    List<DiningCouponTypeModel>? typeList,
    DiningCouponAvailabilityModel? availability,
    List<DiningCouponAvailabilityModel>? availabilityList,
    DiningCouponPreBookingModel? preeBookingChargeRequired,
    List<DiningCouponPreBookingModel>? preeBookingChargeRequiredList,
    bool? isNew,
    bool? isValid,
    DialogDiningCouponStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return DialogDiningCouponState(
      couponId: couponId ?? this.couponId,
      model: model ?? this.model,
      diningCouponName: diningCouponName ?? this.diningCouponName,
      diningCouponCode: diningCouponCode ?? this.diningCouponCode,
      diningCouponLimit: diningCouponLimit ?? this.diningCouponLimit,
      diningCouponStartDate: diningCouponStartDate ?? this.diningCouponStartDate,
      diningCouponExpireDate: diningCouponExpireDate ?? this.diningCouponExpireDate,
      diningCouponMinDiscount: diningCouponMinDiscount ?? this.diningCouponMinDiscount,
      diningCouponMaxDiscount: diningCouponMaxDiscount ?? this.diningCouponMaxDiscount,
      diningCouponPreBookingCharge: diningCouponPreBookingCharge ?? this.diningCouponPreBookingCharge,
      type: type ?? this.type,
      typeList: typeList ?? this.typeList,
      availability: availability ?? this.availability,
      availabilityList: availabilityList ?? this.availabilityList,
      preeBookingChargeRequired: preeBookingChargeRequired ?? this.preeBookingChargeRequired,
      preeBookingChargeRequiredList: preeBookingChargeRequiredList ?? this.preeBookingChargeRequiredList,
      isNew: isNew ?? this.isNew,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class DiningCouponTypeModel {
  String? label;
  String? value;

  DiningCouponTypeModel({this.label, this.value});

  DiningCouponTypeModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}

class DiningCouponAvailabilityModel {
  String? label;
  String? value;

  DiningCouponAvailabilityModel({this.label, this.value});

  DiningCouponAvailabilityModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}

class DiningCouponPreBookingModel {
  String? label;
  bool? value;

  DiningCouponPreBookingModel({this.label, this.value});

  DiningCouponPreBookingModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}
