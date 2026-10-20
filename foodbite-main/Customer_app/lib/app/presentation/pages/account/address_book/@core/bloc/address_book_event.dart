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

sealed class AddressBookEvent {}

final class AddressBookInitialEvent extends AddressBookEvent {}

final class AddressBookRefreshEvent extends AddressBookEvent {}

final class AddressBookDeleteEvent extends AddressBookEvent {
  final String id;
  AddressBookDeleteEvent({required this.id});
}
