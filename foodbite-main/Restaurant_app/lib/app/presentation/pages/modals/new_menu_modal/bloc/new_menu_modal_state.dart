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

part of 'new_menu_modal_bloc.dart';

enum NewMenuModalStatus { loading, loaded, initial, success, failure, inProgress }

extension NewMenuModalStatusX on NewMenuModalStatus {
  bool get isLoading => this == NewMenuModalStatus.loading;
  bool get isLoaded => this == NewMenuModalStatus.loaded;
  bool get isSuccess => this == NewMenuModalStatus.success;
  bool get isFailure => this == NewMenuModalStatus.failure;
  bool get isInProgress => this == NewMenuModalStatus.inProgress;
  bool get isInitial => this == NewMenuModalStatus.initial;
}

final class NewMenuModalState {
  final MenuNameField name;
  final List<MenuFormTranslations> translations;
  final List<String> photos;
  final bool isValid;
  final NewMenuModalStatus status;
  final String alertMessage;
  final String extraMessage;
  final int statusCode;
  const NewMenuModalState({
    this.name = const MenuNameField.pure(),
    this.translations = const [],
    this.photos = const [],
    this.isValid = false,
    this.status = NewMenuModalStatus.initial,
    this.alertMessage = '',
    this.extraMessage = '',
    this.statusCode = 0,
  });

  NewMenuModalState copyWith({MenuNameField? name, List<MenuFormTranslations>? translations, List<String>? photos, bool? isValid, NewMenuModalStatus? status, String? alertMessage, String? extraMessage, int? statusCode}) {
    return NewMenuModalState(
      name: name ?? this.name,
      translations: translations ?? this.translations,
      photos: photos ?? this.photos,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
