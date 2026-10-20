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

sealed class ChangeReceiverInfoModalEvent {}

final class ChangeReceiverInfoModalInitialEvent extends ChangeReceiverInfoModalEvent {
  final String orderTo;
  final String addressTitle;
  final String addressSubtitle;
  final String receiverName;
  final String receiverCountryCode;
  final String receiverPhoneNumber;
  ChangeReceiverInfoModalInitialEvent({required this.orderTo, required this.addressTitle, required this.addressSubtitle, required this.receiverName, required this.receiverCountryCode, required this.receiverPhoneNumber});
}

final class ChangeReceiverNameChanged extends ChangeReceiverInfoModalEvent {
  final String name;
  ChangeReceiverNameChanged({required this.name});
}

final class ChangeReceiverNameUnfocused extends ChangeReceiverInfoModalEvent {}

final class ChangeReceiverCountryCodeChanged extends ChangeReceiverInfoModalEvent {
  final String flag;
  final String countryCode;
  ChangeReceiverCountryCodeChanged({required this.flag, required this.countryCode});
}

final class ChangeReceiverNumberChanged extends ChangeReceiverInfoModalEvent {
  final String number;
  ChangeReceiverNumberChanged({required this.number});
}

final class ChangeReceiverNumberUnfocused extends ChangeReceiverInfoModalEvent {}

final class ChangeReceiverSubmitted extends ChangeReceiverInfoModalEvent {}
