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

part of 'dialog_tiffin_subscription_bloc.dart';

enum DialogTiffinSubscriptionStatus { loading, success, failure, changeDetail, submit, submitSuccess, submitFailed, update, updateSuccess, updateFailed }

extension DialogTiffinSubscriptionStatusX on DialogTiffinSubscriptionStatus {
  bool get isLoading => this == DialogTiffinSubscriptionStatus.loading;
  bool get isSuccess => this == DialogTiffinSubscriptionStatus.success;
  bool get isFailure => this == DialogTiffinSubscriptionStatus.failure;
  bool get isChangeDetail => this == DialogTiffinSubscriptionStatus.changeDetail;
  bool get isSubmit => this == DialogTiffinSubscriptionStatus.submit;
  bool get isSubmitSuccess => this == DialogTiffinSubscriptionStatus.submitSuccess;
  bool get isSubmitFailed => this == DialogTiffinSubscriptionStatus.submitFailed;
  bool get isUpdate => this == DialogTiffinSubscriptionStatus.update;
  bool get isUpdateSuccess => this == DialogTiffinSubscriptionStatus.updateSuccess;
  bool get isUpdateFailed => this == DialogTiffinSubscriptionStatus.updateFailed;
}

final class DialogTiffinSubscriptionState {
  final String appLocale;
  final String tiffinId;
  final TiffinSubscriptionInfoResponseModel model;
  final TiffinSubscriptionCoverField tiffinCover;
  final TiffinSubscriptionNameField tiffinName;
  final TiffinSubscriptionShortDescriptionField tiffinShortDescription;
  final List<String> foodIds;
  final TiffinSubscriptionFoodsField tiffinFoods;
  final TiffinSubscriptionDeliveryAreaField tiffinDeliveryArea;
  final TiffinSubscriptionPriceField tiffinPrice;
  final TiffinSubscriptionDiscountField tiffinDiscount;
  final TiffinSubscriptionTotalOrdersField tiffinTotalOrders;
  final AddonValidationModel addonValidation;
  final List<AddonValidationModel> addonValidationList;
  final VariationValidationModel variationValidation;
  final List<VariationValidationModel> variationValidationList;
  final DeliveryValidationModel deliveryValidation;
  final List<DeliveryValidationModel> deliveryValidationList;
  final OrderValidationModel orderValidation;
  final List<OrderValidationModel> orderValidationList;
  final AvailabilityValidationModel availabilityValidation;
  final List<AvailabilityValidationModel> availabilityValidationList;
  final DiscountModel discountType;
  final List<DiscountModel> discountTypeList;
  final List<TiffinSubscriptionTimeSlotListModel> timeslotList;
  final List<TiffinSubscriptionInstructionModel> instructions;
  final List<String> offDays;
  final bool isNew;
  final bool isValid;
  final DialogTiffinSubscriptionStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const DialogTiffinSubscriptionState({
    this.appLocale = '',
    this.tiffinId = '',
    required this.model,
    this.tiffinCover = const TiffinSubscriptionCoverField.pure(),
    this.tiffinName = const TiffinSubscriptionNameField.pure(),
    this.tiffinShortDescription = const TiffinSubscriptionShortDescriptionField.pure(),
    this.tiffinFoods = const TiffinSubscriptionFoodsField.pure(),
    this.foodIds = const [],
    this.tiffinDeliveryArea = const TiffinSubscriptionDeliveryAreaField.pure(),
    this.tiffinPrice = const TiffinSubscriptionPriceField.pure(),
    this.tiffinDiscount = const TiffinSubscriptionDiscountField.pure(),
    this.tiffinTotalOrders = const TiffinSubscriptionTotalOrdersField.pure(),
    required this.addonValidation,
    required this.variationValidation,
    required this.deliveryValidation,
    required this.orderValidation,
    required this.availabilityValidation,
    required this.discountType,
    this.addonValidationList = const [],
    this.variationValidationList = const [],
    this.deliveryValidationList = const [],
    this.orderValidationList = const [],
    this.availabilityValidationList = const [],
    this.discountTypeList = const [],
    this.timeslotList = const [],
    this.instructions = const [],
    this.offDays = const [],
    this.isNew = false,
    this.isValid = false,
    this.status = DialogTiffinSubscriptionStatus.loading,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  DialogTiffinSubscriptionState copyWith({
    String? appLocale,
    String? tiffinId,
    TiffinSubscriptionInfoResponseModel? model,
    TiffinSubscriptionCoverField? tiffinCover,
    TiffinSubscriptionNameField? tiffinName,
    TiffinSubscriptionShortDescriptionField? tiffinShortDescription,
    TiffinSubscriptionFoodsField? tiffinFoods,
    List<String>? foodIds,
    TiffinSubscriptionDeliveryAreaField? tiffinDeliveryArea,
    TiffinSubscriptionPriceField? tiffinPrice,
    TiffinSubscriptionDiscountField? tiffinDiscount,
    TiffinSubscriptionTotalOrdersField? tiffinTotalOrders,
    AddonValidationModel? addonValidation,
    List<AddonValidationModel>? addonValidationList,
    VariationValidationModel? variationValidation,
    List<VariationValidationModel>? variationValidationList,
    DeliveryValidationModel? deliveryValidation,
    List<DeliveryValidationModel>? deliveryValidationList,
    OrderValidationModel? orderValidation,
    List<OrderValidationModel>? orderValidationList,
    AvailabilityValidationModel? availabilityValidation,
    List<AvailabilityValidationModel>? availabilityValidationList,
    DiscountModel? discountType,
    List<DiscountModel>? discountTypeList,
    List<TiffinSubscriptionTimeSlotListModel>? timeslotList,
    List<TiffinSubscriptionInstructionModel>? instructions,
    List<String>? offDays,
    bool? isNew,
    bool? isValid,
    DialogTiffinSubscriptionStatus? status,
    String? alertMessage,
    String? extraMessage,
    int? statusCode,
  }) {
    return DialogTiffinSubscriptionState(
      appLocale: appLocale ?? this.appLocale,
      tiffinId: tiffinId ?? this.tiffinId,
      model: model ?? this.model,
      tiffinCover: tiffinCover ?? this.tiffinCover,
      tiffinName: tiffinName ?? this.tiffinName,
      tiffinShortDescription: tiffinShortDescription ?? this.tiffinShortDescription,
      tiffinFoods: tiffinFoods ?? this.tiffinFoods,
      foodIds: foodIds ?? this.foodIds,
      tiffinDeliveryArea: tiffinDeliveryArea ?? this.tiffinDeliveryArea,
      tiffinPrice: tiffinPrice ?? this.tiffinPrice,
      tiffinDiscount: tiffinDiscount ?? this.tiffinDiscount,
      tiffinTotalOrders: tiffinTotalOrders ?? this.tiffinTotalOrders,
      addonValidation: addonValidation ?? this.addonValidation,
      addonValidationList: addonValidationList ?? this.addonValidationList,
      variationValidation: variationValidation ?? this.variationValidation,
      variationValidationList: variationValidationList ?? this.variationValidationList,
      deliveryValidation: deliveryValidation ?? this.deliveryValidation,
      deliveryValidationList: deliveryValidationList ?? this.deliveryValidationList,
      orderValidation: orderValidation ?? this.orderValidation,
      orderValidationList: orderValidationList ?? this.orderValidationList,
      availabilityValidation: availabilityValidation ?? this.availabilityValidation,
      availabilityValidationList: availabilityValidationList ?? this.availabilityValidationList,
      discountType: discountType ?? this.discountType,
      discountTypeList: discountTypeList ?? this.discountTypeList,
      timeslotList: timeslotList ?? this.timeslotList,
      instructions: instructions ?? this.instructions,
      offDays: offDays ?? this.offDays,
      isNew: isNew ?? this.isNew,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class AddonValidationModel {
  String? label;
  bool? value;

  AddonValidationModel({this.label, this.value});

  AddonValidationModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['Value'] = value;
    return data;
  }
}

class VariationValidationModel {
  String? label;
  bool? value;

  VariationValidationModel({this.label, this.value});

  VariationValidationModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['Value'] = value;
    return data;
  }
}

class DeliveryValidationModel {
  String? label;
  String? value;

  DeliveryValidationModel({this.label, this.value});

  DeliveryValidationModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['Value'] = value;
    return data;
  }
}

class AvailabilityValidationModel {
  String? label;
  String? value;

  AvailabilityValidationModel({this.label, this.value});

  AvailabilityValidationModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['Value'] = value;
    return data;
  }
}

class OrderValidationModel {
  String? label;
  String? value;

  OrderValidationModel({this.label, this.value});

  OrderValidationModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['Value'] = value;
    return data;
  }
}

class DiscountModel {
  String? label;
  String? value;

  DiscountModel({this.label, this.value});

  DiscountModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['Value'] = value;
    return data;
  }
}
