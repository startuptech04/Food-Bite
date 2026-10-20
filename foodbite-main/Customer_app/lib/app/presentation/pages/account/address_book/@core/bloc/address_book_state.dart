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

part of 'address_book_bloc.dart';

enum AddressBookStatus { loading, empty, success, failure, unAuthorized }

extension AddressBookStatusX on AddressBookStatus {
  bool get isLoading => this == AddressBookStatus.loading;
  bool get isEmpty => this == AddressBookStatus.empty;
  bool get isSuccess => this == AddressBookStatus.success;
  bool get isFailure => this == AddressBookStatus.failure;
  bool get isUnAuthorizd => this == AddressBookStatus.unAuthorized;
}

final class AddressBookState {
  final MyAddressListResponseModel addresses;
  final AddressBookStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const AddressBookState({required this.addresses, this.status = AddressBookStatus.loading, this.statusCode = 0, this.alertMessage = '', this.extraMessage = ''});

  AddressBookState copyWith({MyAddressListResponseModel? addresses, AddressBookStatus? status, int? statusCode, String? alertMessage, String? extraMessage}) {
    return AddressBookState(
      addresses: addresses ?? this.addresses,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
