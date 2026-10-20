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

part of 'change_receiver_info_modal_bloc.dart';

final class ChangeReceiverInfoModalState {
  final String orderTo;
  final String addressTitle;
  final String addressSubtitle;
  final AddressReceiverNameField receiverName;
  final AddressReceiveCountryCodeField countryCode;
  final String flag;
  final AddressReceiverNumberField receiverNumber;
  final bool isValid;
  final FormzSubmissionStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const ChangeReceiverInfoModalState({
    this.orderTo = '',
    this.addressTitle = '',
    this.addressSubtitle = '',
    this.receiverName = const AddressReceiverNameField.pure(),
    this.countryCode = const AddressReceiveCountryCodeField.pure(),
    this.flag = '',
    this.receiverNumber = const AddressReceiverNumberField.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.inProgress,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  ChangeReceiverInfoModalState copyWith({
    String? orderTo,
    String? addressTitle,
    String? addressSubtitle,
    AddressReceiverNameField? receiverName,
    AddressReceiveCountryCodeField? countryCode,
    String? flag,
    AddressReceiverNumberField? receiverNumber,
    bool? isValid,
    FormzSubmissionStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return ChangeReceiverInfoModalState(
      orderTo: orderTo ?? this.orderTo,
      addressTitle: addressTitle ?? this.addressTitle,
      addressSubtitle: addressSubtitle ?? this.addressSubtitle,
      receiverName: receiverName ?? this.receiverName,
      countryCode: countryCode ?? this.countryCode,
      flag: flag ?? this.flag,
      receiverNumber: receiverNumber ?? this.receiverNumber,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
