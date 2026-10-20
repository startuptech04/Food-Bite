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

part of 'feedback_form_bloc.dart';

sealed class FeedbackFormEvent {}

final class FeedbackFormInitialEvent extends FeedbackFormEvent {}

final class FeedbackFormNameChangedEvent extends FeedbackFormEvent {
  final String name;
  FeedbackFormNameChangedEvent({required this.name});
}

final class FeedbackFormNameUnfocusedEvent extends FeedbackFormEvent {}

final class FeedbackFormCountryCodeChangedEvent extends FeedbackFormEvent {
  final String flag;
  final String countryCode;
  FeedbackFormCountryCodeChangedEvent({required this.flag, required this.countryCode});
}

final class FeedbackFormNumberChangedEvent extends FeedbackFormEvent {
  final String number;
  FeedbackFormNumberChangedEvent({required this.number});
}

final class FeedbackFormNumberUnfocusedEvent extends FeedbackFormEvent {}

final class FeedbackFormEmailChangedEvent extends FeedbackFormEvent {
  final String email;
  FeedbackFormEmailChangedEvent({required this.email});
}

final class FeedbackFormEmailUnfocusedEvent extends FeedbackFormEvent {}

final class FeedbackFormDescriptionChangedEvent extends FeedbackFormEvent {
  final String text;
  FeedbackFormDescriptionChangedEvent({required this.text});
}

final class FeedbackFormDescriptionUnfocusedEvent extends FeedbackFormEvent {}

final class FeedbackFormSubmitEvent extends FeedbackFormEvent {}
