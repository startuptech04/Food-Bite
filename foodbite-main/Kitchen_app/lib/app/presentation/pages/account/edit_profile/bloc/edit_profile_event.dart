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

part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent {}

final class EditUserProfileInitialEvent extends EditProfileEvent {}

final class EditUserProfileFirstNameChangedEvent extends EditProfileEvent {
  final String firstName;
  EditUserProfileFirstNameChangedEvent({required this.firstName});
}

final class EditUserProfileFirstNameUnfocusedEvent extends EditProfileEvent {}

final class EditUserProfileLastNameChangedEvent extends EditProfileEvent {
  final String lastName;
  EditUserProfileLastNameChangedEvent({required this.lastName});
}

final class EditUserProfileLastNameUnfocusedEvent extends EditProfileEvent {}

final class EditUserProfileSubmitEvent extends EditProfileEvent {}

final class EditUserProfileChangeGenderEvent extends EditProfileEvent {
  final OwnerGenderModel gender;
  EditUserProfileChangeGenderEvent({required this.gender});
}

final class EditUserProfileUploadImageEvent extends EditProfileEvent {
  final XFile newImage;
  EditUserProfileUploadImageEvent({required this.newImage});
}
