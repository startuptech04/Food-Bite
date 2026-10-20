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

part of 'address_action_bloc.dart';

final class AddressActionState {
  final String id;
  final bool isNew;
  final int title;
  final AddressReceiverNameField receiverName;
  final AddressReceiveCountryCodeField countryCode;
  final String flag;
  final AddressReceiverNumberField receiverNumber;
  final AddressHouseField houseName;
  final AddressLocalityField locality;
  final String landmark;
  final String latitude;
  final String longitude;
  final bool isValid;
  final FormzSubmissionStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AddressActionState({
    this.id = '',
    this.isNew = false,
    this.title = 0,
    this.receiverName = const AddressReceiverNameField.pure(),
    this.countryCode = const AddressReceiveCountryCodeField.pure(),
    this.flag = '',
    this.receiverNumber = const AddressReceiverNumberField.pure(),
    this.houseName = const AddressHouseField.pure(),
    this.locality = const AddressLocalityField.pure(),
    this.landmark = '',
    this.latitude = '',
    this.longitude = '',
    this.isValid = false,
    this.status = FormzSubmissionStatus.inProgress,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  AddressActionState copyWith({
    String? id,
    bool? isNew,
    int? title,
    AddressReceiverNameField? receiverName,
    AddressReceiveCountryCodeField? countryCode,
    String? flag,
    AddressReceiverNumberField? receiverNumber,
    AddressHouseField? houseName,
    AddressLocalityField? locality,
    String? landmark,
    String? latitude,
    String? longitude,
    bool? isValid,
    FormzSubmissionStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return AddressActionState(
      id: id ?? this.id,
      isNew: isNew ?? this.isNew,
      title: title ?? this.title,
      receiverName: receiverName ?? this.receiverName,
      countryCode: countryCode ?? this.countryCode,
      flag: flag ?? this.flag,
      receiverNumber: receiverNumber ?? this.receiverNumber,
      houseName: houseName ?? this.houseName,
      locality: locality ?? this.locality,
      landmark: landmark ?? this.landmark,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
