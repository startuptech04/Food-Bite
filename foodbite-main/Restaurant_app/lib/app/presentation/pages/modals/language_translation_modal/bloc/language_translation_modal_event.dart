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

sealed class LanguageTranslationModalEvent {}

final class LanguageTranslationModalInitialEvent extends LanguageTranslationModalEvent {
  final String selected;
  LanguageTranslationModalInitialEvent({required this.selected});
}

final class LanguageTranslationModalChangeEvent extends LanguageTranslationModalEvent {
  final String code;
  LanguageTranslationModalChangeEvent({required this.code});
}

final class LanguageTranslationModalSubmitEvent extends LanguageTranslationModalEvent {}
