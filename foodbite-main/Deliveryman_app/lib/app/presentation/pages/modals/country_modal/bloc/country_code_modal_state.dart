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

enum CountryCodeModalStatus { loading, success, failure, selected }

extension CountryCodeModalStatusX on CountryCodeModalStatus {
  bool get isLoading => this == CountryCodeModalStatus.loading;
  bool get isSuccess => this == CountryCodeModalStatus.success;
  bool get isFailure => this == CountryCodeModalStatus.failure;
  bool get isSelected => this == CountryCodeModalStatus.selected;
}

final class CountryCodeModalState {
  final List<AppDefaultCountryCodeConfigModel> countries;
  final List<AppDefaultCountryCodeConfigModel> dummy;
  final String selectedCountries;
  final AppDefaultCountryCodeConfigModel info;
  final CountryCodeModalStatus status;
  final int statusCode;
  final String alertMessage;
  final String extraMessage;
  const CountryCodeModalState({
    this.countries = const [],
    this.dummy = const [],
    this.selectedCountries = '',
    required this.info,
    this.status = CountryCodeModalStatus.loading,
    this.statusCode = 0,
    this.alertMessage = '',
    this.extraMessage = '',
  });

  CountryCodeModalState copyWith({
    List<AppDefaultCountryCodeConfigModel>? countries,
    List<AppDefaultCountryCodeConfigModel>? dummy,
    String? selectedCountries,
    AppDefaultCountryCodeConfigModel? info,
    CountryCodeModalStatus? status,
    int? statusCode,
    String? alertMessage,
    String? extraMessage,
  }) {
    return CountryCodeModalState(
      countries: countries ?? this.countries,
      dummy: dummy ?? this.dummy,
      selectedCountries: selectedCountries ?? this.selectedCountries,
      info: info ?? this.info,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
