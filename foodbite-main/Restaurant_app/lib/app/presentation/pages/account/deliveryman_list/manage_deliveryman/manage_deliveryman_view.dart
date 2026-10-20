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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:intl/intl.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/country_code_modal_response_model.dart';
import 'package:vendor/app/core/models/deliveryman_vehicle_response_model.dart';
import 'package:vendor/app/core/models/media_gallery_modal_response_model.dart';
import 'package:vendor/app/presentation/pages/account/deliveryman_list/manage_deliveryman/bloc/manage_deliveryman_bloc.dart';
import 'package:vendor/app/presentation/pages/media/media_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/country_modal/country_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class ManageDeliverymanScreen extends StatelessWidget {
  final bool isNew;
  final String deliverymanId;
  const ManageDeliverymanScreen({super.key, required this.isNew, required this.deliverymanId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageDeliverymanBloc()..add(ManageDeliverymanInitialEvent(isNew: isNew, deliverymanId: deliverymanId)),
      child: ManageDeliverymanView(isNew: isNew),
    );
  }
}

class ManageDeliverymanView extends StatefulWidget {
  final bool isNew;
  const ManageDeliverymanView({super.key, required this.isNew});

  @override
  State<ManageDeliverymanView> createState() => _ManageDeliverymanViewState();
}

class _ManageDeliverymanViewState extends State<ManageDeliverymanView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _countryCodeFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _dobFocusNode = FocusNode();
  final _identityFocusNode = FocusNode();

  bool _passwordVisible = false;

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileNumberController.dispose();
    _countryCodeController.dispose();
    _ageController.dispose();
    _dobController.dispose();
    _identityController.dispose();

    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _countryCodeFocusNode.dispose();
    _mobileFocusNode.dispose();
    _ageFocusNode.dispose();
    _dobFocusNode.dispose();
    _identityFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();

    _firstNameFocusNode.addListener(() {
      if (!_firstNameFocusNode.hasFocus) {
        context.read<ManageDeliverymanBloc>().add(ManageDeliverymanFirstNameUnfocusedEvent());
      }
    });

    _lastNameFocusNode.addListener(() {
      if (!_lastNameFocusNode.hasFocus) {
        context.read<ManageDeliverymanBloc>().add(ManageDeliverymanLastNameUnfocusedEvent());
      }
    });

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<ManageDeliverymanBloc>().add(ManageDeliverymanEmailUnfocusedEvent());
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<ManageDeliverymanBloc>().add(ManageDeliverymanPasswordUnfocusedEvent());
      }
    });

    _countryCodeFocusNode.addListener(() {
      if (!_countryCodeFocusNode.hasFocus) {
        context.read<ManageDeliverymanBloc>().add(ManageDeliverymanCountryCodeUnfocusedEvent());
      }
    });

    _mobileFocusNode.addListener(() {
      if (!_mobileFocusNode.hasFocus) {
        context.read<ManageDeliverymanBloc>().add(ManageDeliverymanMobileNumberUnfocusedEvent());
      }
    });

    _ageFocusNode.addListener(() {
      if (!_ageFocusNode.hasFocus) {
        context.read<ManageDeliverymanBloc>().add(ManageDeliverymanAgeUnfocusedEvent());
      }
    });

    _dobFocusNode.addListener(() {
      if (!_dobFocusNode.hasFocus) {
        context.read<ManageDeliverymanBloc>().add(ManageDeliverymanDOBUnfocusedEvent());
      }
    });

    _identityFocusNode.addListener(() {
      if (!_identityFocusNode.hasFocus) {
        context.read<ManageDeliverymanBloc>().add(ManageDeliverymanIdentityNumberUnfocusedEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((ManageDeliverymanBloc bloc) => bloc.state.isValid);
    return BlocConsumer<ManageDeliverymanBloc, ManageDeliverymanState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          _countryCodeController.text = '${state.flag} (${state.deliverymanCountryCode.value})';
          _dobController.text = state.deliverymanDOB.value;
          _ageController.text = state.deliverymanAge.value;
          _identityController.text = state.deliverymanIdentityNumber.value;
        } else if (state.status.isFailure || state.status.isSubmitFailed || state.status.isUpdateFailed) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSubmitSuccess) {
          showSuccessDialog(context, translate.deliveryman_added).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        } else if (state.status.isUpdateSuccess) {
          showSuccessDialog(context, translate.deliveryman_updated).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isSubmit || state.status.isUpdate ? true : false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              title: Text(widget.isNew ? translate.add_deliveryman : translate.update_deliveryman),
              actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const ManageDeliverymanLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const ManageDeliverymanErrorView(),
                  ] else ...[
                    state.isNew
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return MediaModalScreen(selectedMedia: state.deliverymanCover.value);
                                          },
                                          fullscreenDialog: true,
                                        ),
                                      )
                                      .then((value) {
                                        if (!context.mounted) return;
                                        GalleryModalResponseModel galleryResponse = GalleryModalResponseModel.fromJson(value);
                                        if (galleryResponse.action!) {
                                          context.read<ManageDeliverymanBloc>().add(ManageDeliverymanCoverChangeEvent(image: galleryResponse.data!));
                                        }
                                      });
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  padding: const EdgeInsets.all(8), // Border width
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: state.deliverymanCover.displayError != null ? ThemeProvider.errorColor : ThemeProvider.greyColorBorder, width: state.deliverymanCover.displayError != null ? 2 : 0),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: CacheNetworkImageWidget(width: 100, height: 100, imageUrl: state.deliverymanCover.value),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    state.isNew ? kAppSpacerVertical(height: 20) : const SizedBox(),
                    state.isNew
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  focusNode: _firstNameFocusNode,
                                  decoration: kAppInputDecoration(context, lblText: translate.form_first_name, errText: state.deliverymanFirstName.displayError != null ? translate.form_required : null),
                                  style: kAppLblLargeFontMedium(context),
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
                                    context.read<ManageDeliverymanBloc>().add(ManageDeliverymanFirstNameChangedEvent(firstName: _firstNameController.text));
                                  },
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  focusNode: _lastNameFocusNode,
                                  decoration: kAppInputDecoration(context, lblText: translate.form_last_name, errText: state.deliverymanLastName.displayError != null ? translate.form_required : null),
                                  style: kAppLblLargeFontMedium(context),
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
                                    context.read<ManageDeliverymanBloc>().add(ManageDeliverymanLastNameChangedEvent(lastName: _lastNameController.text));
                                  },
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    state.isNew ? kAppSpacerVertical(height: 20) : const SizedBox(),
                    state.isNew
                        ? TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            decoration: kAppInputDecoration(
                              context,
                              prefixIcon: const Icon(Icons.email_outlined),
                              lblText: translate.email_lbl,
                              errText: state.deliverymanEmail.displayError != null ? translate.form_required : null,
                            ),
                            style: kAppLblSmallFontMedium(context),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => context.read<ManageDeliverymanBloc>().add(ManageDeliverymanEmailChangedEvent(email: value)),
                            textInputAction: TextInputAction.next,
                          )
                        : const SizedBox(),
                    state.isNew ? kAppSpacerVertical(height: 20) : const SizedBox(),
                    state.isNew
                        ? TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            decoration: kAppInputDecoration(
                              context,
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              lblText: translate.password_lbl,
                              errText: state.deliverymanPassword.displayError != null ? translate.form_required : null,
                              suffixIcon: Icon(_passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              haveSuffixIcon: true,
                              onPressed: () => setState(() {
                                _passwordVisible = !_passwordVisible;
                              }),
                            ),
                            style: kAppLblSmallFontMedium(context),
                            obscureText: !_passwordVisible,
                            keyboardType: TextInputType.text,
                            onChanged: (value) => context.read<ManageDeliverymanBloc>().add(ManageDeliverymanPasswordChangedEvent(password: value)),
                            textInputAction: TextInputAction.done,
                          )
                        : const SizedBox(),
                    state.isNew ? kAppSpacerVertical(height: 20) : const SizedBox(),
                    state.isNew
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: _countryCodeController,
                                  focusNode: _countryCodeFocusNode,
                                  readOnly: true,
                                  decoration: kAppInputDecoration(context, lblText: translate.form_country_code, errText: state.deliverymanCountryCode.displayError != null ? translate.form_required : null),
                                  style: kAppLblSmallFontMedium(context),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return CountryCodeModalScreen(code: state.deliverymanCountryCode.value);
                                            },
                                            fullscreenDialog: true,
                                          ),
                                        )
                                        .then((value) {
                                          if (!context.mounted) return;
                                          CountryCodeModalResponseModel countryCodeResponse = CountryCodeModalResponseModel.fromJson(value);
                                          if (countryCodeResponse.action!) {
                                            _countryCodeController.text = '${countryCodeResponse.flag} (${countryCodeResponse.dialCode})';
                                            context.read<ManageDeliverymanBloc>().add(ManageDeliverymanCountryCodeChangedEvent(countryCode: countryCodeResponse.dialCode!));
                                          }
                                        });
                                  },
                                ),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  focusNode: _mobileFocusNode,
                                  controller: _mobileNumberController,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                                  decoration: kAppInputDecoration(
                                    context,
                                    prefixIcon: const Icon(Icons.person_outline),
                                    lblText: translate.form_mobile_number,
                                    errText: state.deliverymanMobile.displayError != null ? translate.form_required : null,
                                  ),
                                  style: kAppLblSmallFontMedium(context),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => context.read<ManageDeliverymanBloc>().add(ManageDeliverymanMobileNumberChangedEvent(mobileNumber: value)),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    state.isNew ? kAppSpacerVertical(height: 20) : const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextFormField(
                            focusNode: _ageFocusNode,
                            controller: _ageController,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                            decoration: kAppInputDecoration(
                              context,
                              prefixIcon: const Icon(Icons.calendar_today_outlined),
                              lblText: translate.form_age,
                              errText: state.deliverymanAge.displayError != null ? translate.form_required : null,
                            ),
                            style: kAppLblSmallFontMedium(context),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => context.read<ManageDeliverymanBloc>().add(ManageDeliverymanAgeChangedEvent(age: value)),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        kAppSpacerHorizontal(width: 10),
                        Expanded(
                          child: TextFormField(
                            showCursor: false,
                            readOnly: true,
                            focusNode: _dobFocusNode,
                            controller: _dobController,
                            onTap: () async {
                              int calculateEighteenYearsAgo() {
                                return DateTime.now().subtract(const Duration(days: 365 * 18)).year;
                              }

                              await showDatePicker(context: context, firstDate: DateTime(1947), lastDate: DateTime(calculateEighteenYearsAgo())).then((value) {
                                if (!context.mounted) return;
                                String formattedDate = DateFormat('yyyy-MM-dd').format(value!);
                                context.read<ManageDeliverymanBloc>().add(ManageDeliverymanDOBChangedEvent(dob: formattedDate));
                              });
                            },
                            decoration: kAppInputDecoration(
                              context,
                              prefixIcon: const Icon(Icons.calendar_today_outlined),
                              lblText: translate.form_date_of_birth,
                              errText: state.deliverymanDOB.displayError != null ? translate.form_required : null,
                            ),
                            style: kAppLblSmallFontMedium(context),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => context.read<ManageDeliverymanBloc>().add(ManageDeliverymanDOBChangedEvent(dob: value)),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.identity_type, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<IdentityProofModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.proof,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.proofList.map((IdentityProofModel item) {
                          return DropdownMenuItem<IdentityProofModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<ManageDeliverymanBloc>().add(ManageDeliverymanChangeIdentityTypeEvent(type: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      focusNode: _identityFocusNode,
                      controller: _identityController,
                      decoration: kAppInputDecoration(
                        context,
                        prefixIcon: const Icon(Icons.calendar_view_day_outlined),
                        lblText: translate.form_identity_number,
                        errText: state.deliverymanIdentityNumber.displayError != null ? translate.form_required : null,
                      ),
                      style: kAppLblSmallFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<ManageDeliverymanBloc>().add(ManageDeliverymanIdentityNumberChangedEvent(identity: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.vehicle, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<DeliverymanVehicleConfigModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.vehicle,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.vehicleList.map((DeliverymanVehicleConfigModel item) {
                          return DropdownMenuItem<DeliverymanVehicleConfigModel>(value: item, child: Text(item.name.toString()));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<ManageDeliverymanBloc>().add(ManageDeliverymanChangeVehicleEvent(vehicle: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.identity_proof, style: kAppLblTinyFontRegular(context)),
                    kAppSpacerVertical(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MediaModalScreen(selectedMedia: state.identityProof.value);
                                },
                                fullscreenDialog: true,
                              ),
                            )
                            .then((value) {
                              if (!context.mounted) return;
                              GalleryModalResponseModel galleryResponse = GalleryModalResponseModel.fromJson(value);
                              if (galleryResponse.action!) {
                                context.read<ManageDeliverymanBloc>().add(ManageDeliverymanIdentityProofChangeEvent(image: galleryResponse.data!));
                              }
                            });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: state.identityProof.displayError != null ? ThemeProvider.errorColor : ThemeProvider.greyColorBorder, width: state.deliverymanCover.displayError != null ? 2 : 0),
                          shape: BoxShape.rectangle,
                        ),
                        child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width, height: 200, imageUrl: state.identityProof.value),
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.driving_license, style: kAppLblTinyFontRegular(context)),
                    kAppSpacerVertical(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MediaModalScreen(selectedMedia: state.drivingLicense.value);
                                },
                                fullscreenDialog: true,
                              ),
                            )
                            .then((value) {
                              if (!context.mounted) return;
                              GalleryModalResponseModel galleryResponse = GalleryModalResponseModel.fromJson(value);
                              if (galleryResponse.action!) {
                                context.read<ManageDeliverymanBloc>().add(ManageDeliverymanDrivingLicenseChangeEvent(image: galleryResponse.data!));
                              }
                            });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        padding: const EdgeInsets.all(8), // Border width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: state.drivingLicense.displayError != null ? ThemeProvider.errorColor : ThemeProvider.greyColorBorder, width: state.deliverymanCover.displayError != null ? 2 : 0),
                          shape: BoxShape.rectangle,
                        ),
                        child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width, height: 200, imageUrl: state.drivingLicense.value),
                      ),
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
                                  onPressed: isValid ? () => context.read<ManageDeliverymanBloc>().add(ManageDeliverymanSubmitEvent()) : null,
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 50.0,
                                  ),
                                  child: state.status.isSubmit || state.status.isUpdate ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.submit_lbl),
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

class ManageDeliverymanLoadingView extends StatelessWidget {
  const ManageDeliverymanLoadingView({super.key});

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

class ManageDeliverymanErrorView extends StatelessWidget {
  const ManageDeliverymanErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
// DONE //