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

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:waiter/app/core/models/request/update_locale_request_model.dart';
import 'package:waiter/app/core/repositories/auth_repository.dart';
import 'package:waiter/app/env.dart';

part 'language_translation_modal_event.dart';
part 'language_translation_modal_state.dart';

class LanguageTranslationModalBloc extends Bloc<LanguageTranslationModalEvent, LanguageTranslationModalState> {
  final AuthRepository _authRepository = AuthRepository();
  LanguageTranslationModalBloc() : super(const LanguageTranslationModalState()) {
    on<LanguageTranslationModalInitialEvent>(_onLanguageTranslationModalInitialEvent);
    on<LanguageTranslationModalChangeEvent>(_onLanguageTranslationModalChangeEvent);
    on<LanguageTranslationModalSubmitEvent>(_onLanguageTranslationModalSubmitEvent);
  }

  FutureOr<void> _onLanguageTranslationModalInitialEvent(LanguageTranslationModalInitialEvent event, Emitter<LanguageTranslationModalState> emit) async {
    await _authRepository.saveEvent('visited_screen', {"screen": "languages"}, 'languages_screen', 'languages_screen');
    final int indexOfLanguage = AppSupportedLanguagesModel.languages.indexWhere((element) => element.code == event.selected);
    if (indexOfLanguage != -1) {
      emit(state.copyWith(title: AppSupportedLanguagesModel.languages[indexOfLanguage].title, selectText: AppSupportedLanguagesModel.languages[indexOfLanguage].selectText));
    }
    emit(state.copyWith(selected: event.selected, languages: AppSupportedLanguagesModel.languages, status: LanguageTranslationModalStatus.success));
  }

  FutureOr<void> _onLanguageTranslationModalChangeEvent(LanguageTranslationModalChangeEvent event, Emitter<LanguageTranslationModalState> emit) async {
    final int indexOfLanguage = AppSupportedLanguagesModel.languages.indexWhere((element) => element.code == event.code);
    if (indexOfLanguage != -1) {
      emit(state.copyWith(title: AppSupportedLanguagesModel.languages[indexOfLanguage].title, selectText: AppSupportedLanguagesModel.languages[indexOfLanguage].selectText, selected: event.code));
    }
  }

  FutureOr<void> _onLanguageTranslationModalSubmitEvent(LanguageTranslationModalSubmitEvent event, Emitter<LanguageTranslationModalState> emit) async {
    final bool isAuthorized = await _authRepository.isAuthorized();
    if (isAuthorized) {
      final String uid = await _authRepository.waiterId();
      UpdateLocaleRequestModel param = UpdateLocaleRequestModel(id: uid, locale: state.selected);
      await _authRepository.updateLocale(param);
    }
  }
}
