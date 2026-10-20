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

final class EditProfileInitialEvent extends EditProfileEvent {}

final class EditProfileFirstNameChangedEvent extends EditProfileEvent {
  final String firstName;
  EditProfileFirstNameChangedEvent({required this.firstName});
}

final class EditProfileFirstNameUnfocusedEvent extends EditProfileEvent {}

final class EditProfileLastNameChangedEvent extends EditProfileEvent {
  final String lastName;
  EditProfileLastNameChangedEvent({required this.lastName});
}

final class EditProfileLastNameUnfocusedEvent extends EditProfileEvent {}

final class EditProfileIdentityChangedEvent extends EditProfileEvent {
  final String identity;
  EditProfileIdentityChangedEvent({required this.identity});
}

final class EditProfileIdentityUnfocusedEvent extends EditProfileEvent {}

final class EditProfileChangeIdentityType extends EditProfileEvent {
  final EditProfileIdentityTypeModel identity;
  EditProfileChangeIdentityType({required this.identity});
}

final class EditProfileSelectVehicleEvent extends EditProfileEvent {
  final VehicleInfoConfigModel vehicle;
  EditProfileSelectVehicleEvent({required this.vehicle});
}

final class EditProfileSubmitEvent extends EditProfileEvent {}

final class EditProfileChangeGenderEvent extends EditProfileEvent {
  final EditProfileGenderModel gender;
  EditProfileChangeGenderEvent({required this.gender});
}

final class EditProfileUploadImageEvent extends EditProfileEvent {
  final XFile newImage;
  EditProfileUploadImageEvent({required this.newImage});
}

final class EditProfileUploadDrivingLicenseEvent extends EditProfileEvent {
  final XFile newImage;
  EditProfileUploadDrivingLicenseEvent({required this.newImage});
}

final class EditProfileUploadIdentityProofEvent extends EditProfileEvent {
  final XFile newImage;
  EditProfileUploadIdentityProofEvent({required this.newImage});
}
