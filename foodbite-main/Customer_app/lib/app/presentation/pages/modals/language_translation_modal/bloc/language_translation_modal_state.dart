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

part of 'language_translation_modal_bloc.dart';

enum LanguageTranslationModalStatus { success, failure }

extension LanguageTranslationModalStatusX on LanguageTranslationModalStatus {
  bool get isSuccess => this == LanguageTranslationModalStatus.success;
  bool get isFailure => this == LanguageTranslationModalStatus.failure;
}

final class LanguageTranslationModalState {
  final String title;
  final String selectText;
  final String selected;
  final List<LanguageEntityModel> languages;
  final LanguageTranslationModalStatus status;
  final String alertMessage;
  final String extraMessage;
  const LanguageTranslationModalState({this.title = '', this.selectText = '', this.selected = '', this.languages = const [], this.status = LanguageTranslationModalStatus.success, this.alertMessage = '', this.extraMessage = ''});

  LanguageTranslationModalState copyWith({String? title, String? selectText, String? selected, List<LanguageEntityModel>? languages, LanguageTranslationModalStatus? status, String? alertMessage, String? extraMessage}) {
    return LanguageTranslationModalState(
      title: title ?? this.title,
      selectText: selectText ?? this.selectText,
      selected: selected ?? this.selected,
      languages: languages ?? this.languages,
      status: status ?? this.status,
      alertMessage: alertMessage ?? this.alertMessage,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }
}
