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

part of 'country_code_modal_bloc.dart';

sealed class CountryCodeModalEvent {}

final class CountryCodeModalInitialEvent extends CountryCodeModalEvent {
  final String code;
  CountryCodeModalInitialEvent({required this.code});
}

final class CountryCodeModalSearchEvent extends CountryCodeModalEvent {
  final String searchText;
  CountryCodeModalSearchEvent({required this.searchText});
}

final class CountryCodeModalSelectEvent extends CountryCodeModalEvent {
  final AppDefaultCountryCodeConfigModel selected;
  CountryCodeModalSelectEvent({required this.selected});
}

final class CountryCodeModalSaveEvent extends CountryCodeModalEvent {}
