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

part of 'dialog_order_coupon_bloc.dart';

enum DialogOrderCouponStatus { loading, success, failure, changeDetail, submit, submitSuccess, submitFailed, update, updateSuccess, updateFailed }

extension DialogOrderCouponStatusX on DialogOrderCouponStatus {
  bool get isLoading => this == DialogOrderCouponStatus.loading;
  bool get isSuccess => this == DialogOrderCouponStatus.success;
  bool get isFailure => this == DialogOrderCouponStatus.failure;
  bool get isChangeDetail => this == DialogOrderCouponStatus.changeDetail;
  bool get isSubmit => this == DialogOrderCouponStatus.submit;
  bool get isSubmitSuccess => this == DialogOrderCouponStatus.submitSuccess;
  bool get isSubmitFailed => this == DialogOrderCouponStatus.submitFailed;
  bool get isUpdate => this == DialogOrderCouponStatus.update;
  bool get isUpdateSuccess => this == DialogOrderCouponStatus.updateSuccess;
  bool get isUpdateFailed => this == DialogOrderCouponStatus.updateFailed;
}

final class DialogOrderCouponState {
  final OrderCouponInfoResponseModel model;
  final String couponId;
  final OrderCouponNameField orderCouponName;
  final OrderCouponCodeField orderCouponCode;
  final OrderCouponLimitField orderCouponLimit;
  final OrderCouponStartDateField orderCouponStartDate;
  final OrderCouponExpireDateField orderCouponExpireDate;
  final OrderCouponMinDiscountField orderCouponMinDiscount;
  final OrderCouponMaxDiscountField orderCouponMaxDiscount;
  final OrderCouponMinCartField orderCouponMinCart;
  final OrderCouponTypeModel type;
  final List<OrderCouponTypeModel> typeList;
  final bool isNew;
  final bool isValid;
  final DialogOrderCouponStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DialogOrderCouponState({
    required this.model,
    this.couponId = '',
    this.orderCouponName = const OrderCouponNameField.pure(),
    this.orderCouponCode = const OrderCouponCodeField.pure(),
    this.orderCouponLimit = const OrderCouponLimitField.pure(),
    this.orderCouponStartDate = const OrderCouponStartDateField.pure(),
    this.orderCouponExpireDate = const OrderCouponExpireDateField.pure(),
    this.orderCouponMinDiscount = const OrderCouponMinDiscountField.pure(),
    this.orderCouponMaxDiscount = const OrderCouponMaxDiscountField.pure(),
    this.orderCouponMinCart = const OrderCouponMinCartField.pure(),
    required this.type,
    this.typeList = const [],
    this.isNew = false,
    this.isValid = false,
    this.status = DialogOrderCouponStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  DialogOrderCouponState copyWith({
    OrderCouponInfoResponseModel? model,
    String? couponId,
    OrderCouponNameField? orderCouponName,
    OrderCouponCodeField? orderCouponCode,
    OrderCouponLimitField? orderCouponLimit,
    OrderCouponStartDateField? orderCouponStartDate,
    OrderCouponExpireDateField? orderCouponExpireDate,
    OrderCouponMinDiscountField? orderCouponMinDiscount,
    OrderCouponMaxDiscountField? orderCouponMaxDiscount,
    OrderCouponMinCartField? orderCouponMinCart,
    OrderCouponTypeModel? type,
    List<OrderCouponTypeModel>? typeList,
    bool? isNew,
    bool? isValid,
    DialogOrderCouponStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return DialogOrderCouponState(
      model: model ?? this.model,
      couponId: couponId ?? this.couponId,
      orderCouponName: orderCouponName ?? this.orderCouponName,
      orderCouponCode: orderCouponCode ?? this.orderCouponCode,
      orderCouponLimit: orderCouponLimit ?? this.orderCouponLimit,
      orderCouponStartDate: orderCouponStartDate ?? this.orderCouponStartDate,
      orderCouponExpireDate: orderCouponExpireDate ?? this.orderCouponExpireDate,
      orderCouponMinDiscount: orderCouponMinDiscount ?? this.orderCouponMinDiscount,
      orderCouponMaxDiscount: orderCouponMaxDiscount ?? this.orderCouponMaxDiscount,
      orderCouponMinCart: orderCouponMinCart ?? this.orderCouponMinCart,
      type: type ?? this.type,
      typeList: typeList ?? this.typeList,
      isNew: isNew ?? this.isNew,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class OrderCouponTypeModel {
  String? label;
  String? value;

  OrderCouponTypeModel({this.label, this.value});

  OrderCouponTypeModel.fromJson(Map<String, dynamic> json) {
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
