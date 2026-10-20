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

part of 'edit_user_profile_bloc.dart';

sealed class EditUserProfileEvent {}

final class EditUserProfileInitialEvent extends EditUserProfileEvent {}

final class EditUserProfileFirstNameChangedEvent extends EditUserProfileEvent {
  final String firstName;
  EditUserProfileFirstNameChangedEvent({required this.firstName});
}

final class EditUserProfileFirstNameUnfocusedEvent extends EditUserProfileEvent {}

final class EditUserProfileLastNameChangedEvent extends EditUserProfileEvent {
  final String lastName;
  EditUserProfileLastNameChangedEvent({required this.lastName});
}

final class EditUserProfileLastNameUnfocusedEvent extends EditUserProfileEvent {}

final class EditUserProfileSubmitEvent extends EditUserProfileEvent {}

final class EditUserProfileChangeGenderEvent extends EditUserProfileEvent {
  final UserProfileGenderModel gender;
  EditUserProfileChangeGenderEvent({required this.gender});
}

final class EditUserProfileAvatarSelectEvent extends EditUserProfileEvent {
  final String avatar;
  EditUserProfileAvatarSelectEvent({required this.avatar});
}

final class EditUserProfileUploadImageEvent extends EditUserProfileEvent {
  final XFile newImage;
  EditUserProfileUploadImageEvent({required this.newImage});
}
