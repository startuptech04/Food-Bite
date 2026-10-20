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

import 'dart:io';

import 'package:driver/app/core/config/assets_url.dart';
import 'package:driver/app/core/models/driver_profile_info_response_model.dart';
import 'package:driver/app/presentation/pages/account/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:driver/app/presentation/styles/app_style.dart';
import 'package:driver/app/presentation/styles/error_dialog.dart';
import 'package:driver/app/presentation/styles/success_dialog.dart';
import 'package:driver/app/presentation/styles/theme.dart';
import 'package:driver/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:driver/app/router/app_route_config.dart';
import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditProfileView();
  }
}

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _mobileNumberFocusNode = FocusNode();
  final _identityFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<EditProfileBloc>().add(EditProfileInitialEvent());
    _firstNameFocusNode.addListener(() {
      if (!_firstNameFocusNode.hasFocus) {
        context.read<EditProfileBloc>().add(EditProfileFirstNameUnfocusedEvent());
      }
    });

    _lastNameFocusNode.addListener(() {
      if (!_lastNameFocusNode.hasFocus) {
        context.read<EditProfileBloc>().add(EditProfileLastNameUnfocusedEvent());
      }
    });

    _identityFocusNode.addListener(() {
      if (!_identityFocusNode.hasFocus) {
        context.read<EditProfileBloc>().add(EditProfileIdentityUnfocusedEvent());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _mobileNumberFocusNode.dispose();
    super.dispose();
  }

  XFile? newImage;
  XFile? identityProof;
  XFile? drivingLicense;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      newImage = img;
    });
    uploadImageNow(img!);
  }

  Future getImageDrivingLicense(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      drivingLicense = img;
    });
    uploadImageDrivingLicense(img!);
  }

  Future getImageIdentityProof(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      identityProof = img;
    });
    uploadImagIdentityProof(img!);
  }

  void uploadImageNow(XFile img) {
    context.read<EditProfileBloc>().add(EditProfileUploadImageEvent(newImage: img));
  }

  void uploadImagIdentityProof(XFile img) {
    context.read<EditProfileBloc>().add(EditProfileUploadIdentityProofEvent(newImage: img));
  }

  void uploadImageDrivingLicense(XFile img) {
    context.read<EditProfileBloc>().add(EditProfileUploadDrivingLicenseEvent(newImage: img));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((EditProfileBloc bloc) => bloc.state.isValid);
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          _countryCodeController.text = '${state.flag} (${state.countryCode.value})';
          _firstNameController.text = state.model.info!.firstName!;
          _lastNameController.text = state.model.info!.lastName!;
          _emailController.text = state.model.info!.email!;
          _mobileController.text = state.model.info!.mobile!;
          _cityController.text = state.model.driver!.city!.name!;
          _localityController.text = state.model.driver!.locality!.name!;
          _identityController.text = state.model.driver!.identityNumber!;
          _dobController.text = state.model.driver!.dob!;
        } else if (state.status.isFailure || state.status.isSubmitFailed || state.status.isUploadFailed) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSubmitSuccess) {
          showSuccessDialog(context, translate.profile_updated);
        } else if (state.status.isUploadSuccess) {
          showSuccessDialog(context, translate.image_uploaded);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isSubmit || state.status.isUploadStarted || state.status.isUploadDrivingLicense || state.status.isUploadIdentityProof ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.your_profile), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const EditUserProfileLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const EditUserProfileErrorView(),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder: (_) => CupertinoActionSheet(
                                title: Text(translate.choose_from, style: kAppLblMediumFontSemiBold(context)),
                                actions: <CupertinoActionSheetAction>[
                                  CupertinoActionSheetAction(
                                    child: Text(translate.gallery, style: kAppLblMediumFontRegular(context)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      getImage(ImageSource.gallery);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text(translate.camera, style: kAppLblMediumFontRegular(context)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      getImage(ImageSource.camera);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text(translate.cancel, style: kAppLblMediumFontRegularError(context)),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(8), // Border width
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              border: Border.all(color: Theme.of(context).disabledColor, width: 2),
                              shape: BoxShape.rectangle,
                            ),
                            child: newImage != null
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                    child: Stack(
                                      children: [
                                        Image.file(File(newImage!.path), width: 100, height: 100, fit: BoxFit.cover),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black.withValues(alpha: 0.9), Colors.black.withValues(alpha: 0.5)]),
                                          ),
                                        ),
                                        state.status.isUploadStarted
                                            ? Align(
                                                alignment: Alignment.center,
                                                child: kAppCircularProgress(context, color: 'primary', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                    child: CacheNetworkImageWidget(width: 100, height: 100, imageUrl: state.image),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 40),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _firstNameController,
                            focusNode: _firstNameFocusNode,
                            decoration: kAppInputDecoration(
                              context,
                              prefixIcon: const Icon(Icons.person_outline),
                              lblText: translate.form_first_name,
                              errText: state.firstName.displayError != null ? translate.form_required : null,
                            ),
                            style: kAppLblSmallFontMedium(context),
                            keyboardType: TextInputType.text,
                            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                            onChanged: (value) {
                              if (value.startsWith(' ')) {
                                _firstNameController.text = value.trimLeft();
                                _firstNameController.selection = TextSelection.collapsed(offset: _firstNameController.text.length);
                              }
                              if (RegExp(r'^[0-9]').hasMatch(value)) {
                                _firstNameController.text = value.substring(1);
                                _firstNameController.selection = TextSelection.collapsed(offset: _firstNameController.text.length);
                              }
                              context.read<EditProfileBloc>().add(EditProfileFirstNameChangedEvent(firstName: _firstNameController.text));
                            },
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        kAppSpacerHorizontal(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _lastNameController,
                            focusNode: _lastNameFocusNode,
                            decoration: kAppInputDecoration(context, prefixIcon: const Icon(Icons.person_outline), lblText: translate.form_last_name, errText: state.lastName.displayError != null ? translate.form_required : null),
                            style: kAppLblSmallFontMedium(context),
                            keyboardType: TextInputType.text,
                            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                            onChanged: (value) {
                              if (value.startsWith(' ')) {
                                _lastNameController.text = value.trimLeft();
                                _lastNameController.selection = TextSelection.collapsed(offset: _lastNameController.text.length);
                              }
                              if (RegExp(r'^[0-9]').hasMatch(value)) {
                                _lastNameController.text = value.substring(1);
                                _lastNameController.selection = TextSelection.collapsed(offset: _lastNameController.text.length);
                              }
                              context.read<EditProfileBloc>().add(EditProfileLastNameChangedEvent(lastName: _lastNameController.text));
                            },
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        iconColor: Theme.of(context).canvasColor,
                        prefixIconColor: Theme.of(context).canvasColor,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pushNamed(AppRouter.accountSettingChangeEmailRoute),
                              child: Text(translate.edit, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                            ),
                          ],
                        ),
                        labelText: translate.email_lbl,
                        labelStyle: TextStyle(fontSize: Theme.of(context).textTheme.labelMedium?.fontSize, fontFamily: 'medium', color: Theme.of(context).canvasColor),
                        errorStyle: TextStyle(fontSize: Theme.of(context).textTheme.labelMedium?.fontSize, fontFamily: 'medium'),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).canvasColor)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).canvasColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      style: kAppLblSmallFontMedium(context),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _mobileController,
                      focusNode: _mobileNumberFocusNode,
                      readOnly: true,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.call_outlined),
                        iconColor: Theme.of(context).canvasColor,
                        prefixIconColor: Theme.of(context).canvasColor,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pushNamed(AppRouter.accountSettingChangeMobileRoute),
                              child: Text(translate.edit, style: kAppLblTinyFontRegularChip(context, color: 'primary')),
                            ),
                          ],
                        ),
                        labelText: translate.form_mobile,
                        labelStyle: TextStyle(fontSize: Theme.of(context).textTheme.labelMedium?.fontSize, fontFamily: 'medium', color: Theme.of(context).canvasColor),
                        errorStyle: TextStyle(fontSize: Theme.of(context).textTheme.labelMedium?.fontSize, fontFamily: 'medium'),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).canvasColor)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).canvasColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      style: kAppLblSmallFontMedium(context),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_month_outlined),
                        iconColor: Theme.of(context).canvasColor,
                        prefixIconColor: Theme.of(context).canvasColor,
                        labelText: translate.form_dob,
                        labelStyle: TextStyle(fontSize: Theme.of(context).textTheme.labelMedium?.fontSize, fontFamily: 'medium', color: Theme.of(context).canvasColor),
                        errorStyle: TextStyle(fontSize: Theme.of(context).textTheme.labelMedium?.fontSize, fontFamily: 'medium'),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).canvasColor)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).canvasColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      style: kAppLblSmallFontMedium(context),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 10),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<EditProfileGenderModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.gender,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.genderList.map((EditProfileGenderModel item) {
                          return DropdownMenuItem<EditProfileGenderModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<EditProfileBloc>().add(EditProfileChangeGenderEvent(gender: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 10),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<VehicleInfoConfigModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.vehicle,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.vehicleList.map((VehicleInfoConfigModel item) {
                          return DropdownMenuItem<VehicleInfoConfigModel>(value: item, child: Text(item.name.toString()));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<EditProfileBloc>().add(EditProfileSelectVehicleEvent(vehicle: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 10),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<EditProfileIdentityTypeModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.identity,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.identityList.map((EditProfileIdentityTypeModel item) {
                          return DropdownMenuItem<EditProfileIdentityTypeModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<EditProfileBloc>().add(EditProfileChangeIdentityType(identity: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _identityController,
                      focusNode: _identityFocusNode,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        iconColor: Theme.of(context).canvasColor,
                        prefixIconColor: Theme.of(context).canvasColor,
                        labelText: translate.identity,
                        labelStyle: TextStyle(fontSize: Theme.of(context).textTheme.labelMedium?.fontSize, fontFamily: 'medium', color: Theme.of(context).canvasColor),
                        errorStyle: TextStyle(fontSize: Theme.of(context).textTheme.labelMedium?.fontSize, fontFamily: 'medium'),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).canvasColor)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).canvasColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      style: kAppLblSmallFontMedium(context),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          _identityController.text = value.trimLeft();
                          _identityController.selection = TextSelection.collapsed(offset: _identityController.text.length);
                        }
                        if (RegExp(r'^[0-9]').hasMatch(value)) {
                          _identityController.text = value.substring(1);
                          _identityController.selection = TextSelection.collapsed(offset: _identityController.text.length);
                        }
                        context.read<EditProfileBloc>().add(EditProfileIdentityChangedEvent(identity: _identityController.text));
                      },
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.identity, style: kAppLblTinyFontRegular(context)),
                    kAppSpacerVertical(height: 10),
                    GestureDetector(
                      onTap: () {
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (_) => CupertinoActionSheet(
                            title: Text(translate.choose_from, style: kAppLblMediumFontSemiBold(context)),
                            actions: <CupertinoActionSheetAction>[
                              CupertinoActionSheetAction(
                                child: Text(translate.gallery, style: kAppLblMediumFontRegular(context)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  getImageIdentityProof(ImageSource.gallery);
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Text(translate.camera, style: kAppLblMediumFontRegular(context)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  getImageIdentityProof(ImageSource.camera);
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Text(translate.cancel, style: kAppLblMediumFontRegularError(context)),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        padding: const EdgeInsets.all(8), // Border width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: ThemeProvider.greyColorBorder, width: 1),
                          shape: BoxShape.rectangle,
                        ),
                        child: identityProof != null
                            ? ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                child: Stack(
                                  children: [
                                    Image.file(File(identityProof!.path), width: MediaQuery.of(context).size.width, height: 250, fit: BoxFit.cover),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black.withValues(alpha: 0.9), Colors.black.withValues(alpha: 0.5)]),
                                      ),
                                    ),
                                    state.status.isUploadIdentityProof
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: kAppCircularProgress(context, color: 'primary', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              )
                            : ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width, height: 250, imageUrl: state.identityProof),
                              ),
                      ),
                    ),
                    kAppSpacerVertical(height: 10),
                    Text(translate.driving_license, style: kAppLblTinyFontRegular(context)),
                    kAppSpacerVertical(height: 10),
                    GestureDetector(
                      onTap: () {
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (_) => CupertinoActionSheet(
                            title: Text(translate.choose_from, style: kAppLblMediumFontSemiBold(context)),
                            actions: <CupertinoActionSheetAction>[
                              CupertinoActionSheetAction(
                                child: Text(translate.gallery, style: kAppLblMediumFontRegular(context)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  getImageDrivingLicense(ImageSource.gallery);
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Text(translate.camera, style: kAppLblMediumFontRegular(context)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  getImageDrivingLicense(ImageSource.camera);
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Text(translate.cancel, style: kAppLblMediumFontRegularError(context)),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        padding: const EdgeInsets.all(8), // Border width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: ThemeProvider.greyColorBorder, width: 1),
                          shape: BoxShape.rectangle,
                        ),
                        child: drivingLicense != null
                            ? ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                child: Stack(
                                  children: [
                                    Image.file(File(drivingLicense!.path), width: MediaQuery.of(context).size.width, height: 250, fit: BoxFit.cover),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black.withValues(alpha: 0.9), Colors.black.withValues(alpha: 0.5)]),
                                      ),
                                    ),
                                    state.status.isUploadDrivingLicense
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: kAppCircularProgress(context, color: 'primary', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              )
                            : ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width, height: 250, imageUrl: state.drivingLicense),
                              ),
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _cityController,
                      readOnly: true,
                      decoration: kAppInputDecoration(context, lblText: translate.form_city),
                      style: kAppLblSmallFontMedium(context),
                      keyboardType: TextInputType.text,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _localityController,
                      readOnly: true,
                      decoration: kAppInputDecoration(context, lblText: translate.form_locality),
                      style: kAppLblSmallFontMedium(context),
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ],
              ),
            ),
            bottomNavigationBar: state.status.isLoading || state.status.isFailure
                ? SafeArea(child: const SizedBox())
                : SafeArea(
                    child: SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: ThemeProvider.scaffoldPadding),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isValid ? () => context.read<EditProfileBloc>().add(EditProfileSubmitEvent()) : null,
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 50.0,
                                  ),
                                  child: state.status.isSubmit ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.update_profile),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class EditUserProfileLoadingView extends StatelessWidget {
  const EditUserProfileLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [SkeletonLine(style: SkeletonLineStyle(height: 100.0, width: 100.0, borderRadius: BorderRadius.circular(50.0)))],
        ),
        kAppSpacerVertical(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
        kAppSpacerVertical(height: 10),
        SkeletonLine(
          style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
        ),
      ],
    );
  }
}

class EditUserProfileErrorView extends StatelessWidget {
  const EditUserProfileErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.something_went_wrong_error_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //