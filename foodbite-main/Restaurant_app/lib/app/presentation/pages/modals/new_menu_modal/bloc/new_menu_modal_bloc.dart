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
import 'package:formz/formz.dart';
import 'package:vendor/app/core/models/dining_detail_response_model.dart';
import 'package:vendor/app/core/models/translations/menu_form_translation.dart';
import 'package:vendor/app/core/repositories/account_repository.dart';
import 'package:vendor/app/core/validations/dining_menu_form.dart';

part 'new_menu_modal_event.dart';
part 'new_menu_modal_state.dart';

class NewMenuModalBloc extends Bloc<NewMenuModalEvent, NewMenuModalState> {
  final AccountRepository _accountRepository = AccountRepository();
  NewMenuModalBloc() : super(const NewMenuModalState()) {
    on<NewMenuModalInitialEvent>(_onNewMenuModalInitialEvent);
    on<NewMenuNameUnfocusedEvent>(_onNewMenuNameUnfocusedEvent);
    on<NewMenuNameChangedEvent>(_onNewMenuNameChangedEvent);
    on<NewMenuSavePhotoEvent>(_onNewMenuSavePhotoEvent);
    on<NewMenuRemovePhotoEvent>(_onNewMenuRemovePhotoEvent);
    on<NewMenuSaveEvent>(_onNewMenuSaveEvent);
  }

  FutureOr<void> _onNewMenuModalInitialEvent(NewMenuModalInitialEvent event, Emitter<NewMenuModalState> emit) async {
    await _accountRepository.saveEvent('visited_screen', {"screen": "add_new_menu"}, 'add_new_menu_screen', 'add_new_menu_screen');
    if (!event.isNew) {
      final name = MenuNameField.dirty(event.name);
      emit(state.copyWith(name: name, photos: event.photos, isValid: Formz.validate([name])));
    }
  }

  FutureOr<void> _onNewMenuNameUnfocusedEvent(NewMenuNameUnfocusedEvent event, Emitter<NewMenuModalState> emit) async {
    final name = MenuNameField.dirty(state.name.value);
    emit(state.copyWith(name: name, status: NewMenuModalStatus.initial, isValid: Formz.validate([name])));
  }

  FutureOr<void> _onNewMenuNameChangedEvent(NewMenuNameChangedEvent event, Emitter<NewMenuModalState> emit) async {
    final name = MenuNameField.dirty(event.name);
    emit(state.copyWith(name: name.isValid ? name : MenuNameField.pure(event.name), status: NewMenuModalStatus.initial, isValid: Formz.validate([name])));
  }

  FutureOr<void> _onNewMenuSavePhotoEvent(NewMenuSavePhotoEvent event, Emitter<NewMenuModalState> emit) async {
    List<String> photos = <String>[];
    for (var element in state.photos) {
      photos.add(element);
    }
    photos.add(event.image);
    emit(state.copyWith(photos: [...photos], status: NewMenuModalStatus.initial));
  }

  FutureOr<void> _onNewMenuRemovePhotoEvent(NewMenuRemovePhotoEvent event, Emitter<NewMenuModalState> emit) async {
    state.photos.removeWhere((element) => element == event.image);
    emit(state.copyWith(photos: [...state.photos], status: NewMenuModalStatus.initial));
  }

  FutureOr<void> _onNewMenuSaveEvent(NewMenuSaveEvent event, Emitter<NewMenuModalState> emit) async {
    final name = MenuNameField.dirty(state.name.value);
    emit(state.copyWith(name: name, status: NewMenuModalStatus.initial, isValid: Formz.validate([name])));
    if (state.isValid && state.name.value.isNotEmpty) {
      emit(state.copyWith(name: name, translations: event.translations, status: NewMenuModalStatus.success));
    }
  }
}
