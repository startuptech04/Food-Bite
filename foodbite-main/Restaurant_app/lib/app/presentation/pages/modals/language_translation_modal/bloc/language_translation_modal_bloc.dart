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
import 'package:vendor/app/core/models/request/update_locale_request_model.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/env.dart';

part 'language_translation_modal_event.dart';
part 'language_translation_modal_state.dart';

class LanguageTranslationModalBloc extends Bloc<LanguageTranslationModalEvent, LanguageTranslationModalState> {
  final AccountRepository _accountRepository = AccountRepository();
  LanguageTranslationModalBloc() : super(const LanguageTranslationModalState()) {
    on<LanguageTranslationModalInitialEvent>(_onLanguageTranslationModalInitialEvent);
    on<LanguageTranslationModalChangeEvent>(_onLanguageTranslationModalChangeEvent);
    on<LanguageTranslationModalSubmitEvent>(_onLanguageTranslationModalSubmitEvent);
  }

  FutureOr<void> _onLanguageTranslationModalInitialEvent(LanguageTranslationModalInitialEvent event, Emitter<LanguageTranslationModalState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "languages"}, 'languages_screen', 'languages_screen');
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
    final String isAuthorized = await _accountRepository.userId();
    if (isAuthorized.isNotEmpty) {
      final String uid = await _accountRepository.userId();
      UpdateLocaleRequestModel param = UpdateLocaleRequestModel(id: uid, locale: state.selected);
      await _accountRepository.updateLocale(param);
    }
  }
}
