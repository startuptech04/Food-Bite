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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/country_code_modal_response_model.dart';
import 'package:vendor/app/core/models/media_gallery_modal_response_model.dart';
import 'package:vendor/app/core/models/modal_navigation_back_response_model.dart';
import 'package:vendor/app/core/models/outlet_cities_response_model.dart';
import 'package:vendor/app/core/models/outlet_license_response_model.dart';
import 'package:vendor/app/core/models/outlet_localities_response_model.dart';
import 'package:vendor/app/core/models/translations/outlet_form_translation.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/app/presentation/pages/account/outlets/manage_outlet/bloc/manage_outlet_bloc.dart';
import 'package:vendor/app/presentation/pages/media/media_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/country_modal/country_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/select_cuisine_modal/select_cuisine_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/select_deliverytime_modal/select_deliverytime_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/select_restaurant_facilities_modal/select_restaurant_facilities_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/select_restaurant_type_modal/select_restaurant_type_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vendor/gen/l10n/app_localizations.dart';

class ManageOutletScreen extends StatelessWidget {
  final bool isNew;
  final String outletId;
  const ManageOutletScreen({super.key, required this.isNew, required this.outletId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageOutletBloc()..add(ManageOutletInitialEvent(isNew: isNew, outletId: outletId)),
      child: ManageOutletView(isNew: isNew, outletId: outletId),
    );
  }
}

class ManageOutletView extends StatefulWidget {
  final bool isNew;
  final String outletId;
  const ManageOutletView({super.key, required this.isNew, required this.outletId});

  @override
  State<ManageOutletView> createState() => _ManageOutletViewState();
}

class _ManageOutletViewState extends State<ManageOutletView> with TickerProviderStateMixin {
  final Completer<GoogleMapController> _googleMapController = Completer<GoogleMapController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController shortDescriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cuisineController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController facilitiesController = TextEditingController();
  final TextEditingController minOrderAmountController = TextEditingController();
  final TextEditingController dishForTwoController = TextEditingController();
  final TextEditingController foodLicenseController = TextEditingController();
  final TextEditingController deliveryTimeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController socialFacebookController = TextEditingController();
  final TextEditingController socialInstagramController = TextEditingController();
  final TextEditingController socialXController = TextEditingController();
  final TextEditingController socialYoutubeController = TextEditingController();
  final TextEditingController socialLinkedInController = TextEditingController();
  final TextEditingController socialPinterestController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _shortDescriptionFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _minOrderAmountFocusNode = FocusNode();
  final _dishForTwoFocusNode = FocusNode();
  final _foodLicenseFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _countryCodeFocusNode = FocusNode();
  final _mobileNuberFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _cuisineFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();
  final _facilityFocusNode = FocusNode();

  bool _passwordVisible = false;

  List<OutletFormTranslations> translations = <OutletFormTranslations>[];
  late TabController outletTranslationTabController;

  Future<void> changeCameraPosition(double latitude, double longitude) async {
    CameraPosition nepPos = CameraPosition(target: LatLng(latitude, longitude), zoom: 16);
    final GoogleMapController controller = await _googleMapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(nepPos));
  }

  @override
  void initState() {
    super.initState();
    if (AppSupportedLanguagesModel.languages.length > 1) {
      for (var element in AppSupportedLanguagesModel.languages) {
        OutletFormTranslations keys = OutletFormTranslations(name: element.value, code: element.code, nativeName: element.value, title: '', address: '', shortDescription: '');
        translations.add(keys);
      }
    }
    outletTranslationTabController = TabController(initialIndex: 0, length: translations.length, vsync: this);

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletNameUnfocusedEvent());
      }
    });

    _shortDescriptionFocusNode.addListener(() {
      if (!_shortDescriptionFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletShortDescriptionUnfocusedEvent());
      }
    });

    _addressFocusNode.addListener(() {
      if (!_addressFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletAddressUnfocusedEvent());
      }
    });

    _minOrderAmountFocusNode.addListener(() {
      if (!_minOrderAmountFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletMinOrderAmountUnfocusedEvent());
      }
    });

    _dishForTwoFocusNode.addListener(() {
      if (!_dishForTwoFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletDishForTwoUnfocusedEvent());
      }
    });

    _foodLicenseFocusNode.addListener(() {
      if (!_foodLicenseFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletFoodLicenseUnfocusedEvent());
      }
    });

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletEmailUnfocusedEvent());
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletPasswordUnfocusedEvent());
      }
    });

    _firstNameFocusNode.addListener(() {
      if (!_firstNameFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletFirstNameUnfocusedEvent());
      }
    });

    _lastNameFocusNode.addListener(() {
      if (!_lastNameFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletLastNameUnfocusedEvent());
      }
    });

    _countryCodeFocusNode.addListener(() {
      if (!_countryCodeFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletCountryCodeUnfocusedEvent());
      }
    });

    _mobileNuberFocusNode.addListener(() {
      if (!_mobileNuberFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletMobileNumberUnfocusedEvent());
      }
    });

    _cuisineFocusNode.addListener(() {
      if (!_cuisineFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletCusineUnfocusedEvent());
      }
    });

    _typeFocusNode.addListener(() {
      if (!_typeFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletTypeUnfocusedEvent());
      }
    });

    _facilityFocusNode.addListener(() {
      if (!_facilityFocusNode.hasFocus) {
        context.read<ManageOutletBloc>().add(ManageOutletFacilityUnfocusedEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    shortDescriptionController.dispose();
    addressController.dispose();
    cuisineController.dispose();
    typeController.dispose();
    facilitiesController.dispose();
    minOrderAmountController.dispose();
    dishForTwoController.dispose();
    foodLicenseController.dispose();
    deliveryTimeController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    countryCodeController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    socialFacebookController.dispose();
    socialInstagramController.dispose();
    socialXController.dispose();
    socialYoutubeController.dispose();
    socialLinkedInController.dispose();
    socialPinterestController.dispose();

    _nameFocusNode.dispose();
    _shortDescriptionFocusNode.dispose();
    _addressFocusNode.dispose();
    _minOrderAmountFocusNode.dispose();
    _dishForTwoFocusNode.dispose();
    _foodLicenseFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _countryCodeFocusNode.dispose();
    _mobileNuberFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _cuisineFocusNode.dispose();
    _typeFocusNode.dispose();
    _facilityFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((ManageOutletBloc bloc) => bloc.state.isValid);
    return BlocConsumer<ManageOutletBloc, ManageOutletState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isBasicFetched) {
          countryCodeController.text = '${state.flag} (${state.countryCodeField.value})';
          deliveryTimeController.text = state.deliveryTimeField.value;
          latitudeController.text = state.latitudeField.value;
          longitudeController.text = state.longitudeField.value;
          changeCameraPosition(double.parse(state.latitudeField.value), double.parse(state.longitudeField.value));
        } else if (state.status.isLocationChange) {
          latitudeController.text = state.latitudeField.value;
          longitudeController.text = state.longitudeField.value;
        } else if (state.status.isChangeDetailFromModal) {
          cuisineController.text = state.cuisineNames;
          typeController.text = state.typeName;
          facilitiesController.text = state.facilitiesName;
          deliveryTimeController.text = state.deliveryTimeField.value;
        } else if (state.status.isSubmitSuccess) {
          showSuccessDialog(context, translate.outlet_saved).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        } else if (state.status.isFetched) {
          nameController.text = state.nameField.value.toString();
          shortDescriptionController.text = state.shortDescriptionField.value.toString();
          addressController.text = state.addressField.value.toString();
          cuisineController.text = state.cuisineNames;
          typeController.text = state.typeName;
          facilitiesController.text = state.facilitiesName;
          minOrderAmountController.text = state.minOrderAmountField.value.toString();
          dishForTwoController.text = state.dishPriceForTwoField.value.toString();
          foodLicenseController.text = state.licenseField.value.toString();
          deliveryTimeController.text = state.deliveryTimeField.value;
          latitudeController.text = state.latitudeField.value.toString();
          longitudeController.text = state.longitudeField.value.toString();
          socialFacebookController.text = state.socialFacebook;
          socialInstagramController.text = state.socialInstagram;
          socialXController.text = state.socialX;
          socialYoutubeController.text = state.socialYoutube;
          socialLinkedInController.text = state.socialLinkedIn;
          socialPinterestController.text = state.socialPinterest;
          for (var locale in translations) {
            for (var translate in state.outletDetail.result!.translations!) {
              if (locale.code == translate.code) {
                locale.title = translate.title!;
                locale.address = translate.address!;
                locale.shortDescription = translate.shortDescription!;
              }
            }
          }
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isSubmit ? true : false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              title: Text(widget.isNew ? translate.add_new_outlet : translate.update_outlet),
              actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const ManageOutletLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const ManageOutletErrorView(),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return MediaModalScreen(selectedMedia: state.logoField.value);
                                    },
                                    fullscreenDialog: true,
                                  ),
                                )
                                .then((value) {
                                  if (!context.mounted) return;
                                  GalleryModalResponseModel galleryResponse = GalleryModalResponseModel.fromJson(value);
                                  if (galleryResponse.action!) {
                                    context.read<ManageOutletBloc>().add(ManageOutletLogoChangeEvent(logo: galleryResponse.data!));
                                  }
                                });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                padding: const EdgeInsets.all(8), // Border width
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: state.logoField.displayError != null ? ThemeProvider.errorColor : ThemeProvider.greyColorBorder, width: state.logoField.displayError != null ? 2 : 0),
                                  shape: BoxShape.rectangle,
                                ),
                                child: CacheNetworkImageWidget(width: 100, height: 100, imageUrl: state.logoField.value),
                              ),
                              kAppSpacerVertical(height: 5),
                              Text("${translate.outlet_logo} (1:1)", style: kAppLblTinyFontRegular(context)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 20),
                    Text("${translate.outlet_cover} (2:1)", style: kAppLblTinyFontRegular(context)),
                    kAppSpacerVertical(height: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MediaModalScreen(selectedMedia: state.coverField.value);
                                },
                                fullscreenDialog: true,
                              ),
                            )
                            .then((value) {
                              if (!context.mounted) return;
                              GalleryModalResponseModel galleryResponse = GalleryModalResponseModel.fromJson(value);
                              if (galleryResponse.action!) {
                                context.read<ManageOutletBloc>().add(ManageOutletCoverChangeEvent(cover: galleryResponse.data!));
                              }
                            });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: state.coverField.displayError != null ? ThemeProvider.errorColor : ThemeProvider.greyColorBorder, width: state.coverField.displayError != null ? 2 : 0),
                          shape: BoxShape.rectangle,
                        ),
                        child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width, height: 150, imageUrl: state.coverField.value),
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: nameController,
                      focusNode: _nameFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_outlet_name, errText: state.nameField.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          nameController.text = value.trimLeft();
                          nameController.selection = TextSelection.collapsed(offset: nameController.text.length);
                        }
                        if (RegExp(r'^[0-9]').hasMatch(value)) {
                          nameController.text = value.substring(1);
                          nameController.selection = TextSelection.collapsed(offset: nameController.text.length);
                        }
                        context.read<ManageOutletBloc>().add(ManageOutletNameChangedEvent(name: nameController.text));
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: shortDescriptionController,
                      focusNode: _shortDescriptionFocusNode,
                      maxLines: 3,
                      decoration: kAppInputDecoration(context, lblText: translate.form_short_description, errText: state.shortDescriptionField.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          shortDescriptionController.text = value.trimLeft();
                          shortDescriptionController.selection = TextSelection.collapsed(offset: shortDescriptionController.text.length);
                        }
                        context.read<ManageOutletBloc>().add(ManageOutletShortDescriptionChangedEvent(shortDescription: shortDescriptionController.text));
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: addressController,
                      focusNode: _addressFocusNode,
                      maxLines: 3,
                      decoration: kAppInputDecoration(context, lblText: translate.form_address, errText: state.addressField.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          addressController.text = value.trimLeft();
                          addressController.selection = TextSelection.collapsed(offset: addressController.text.length);
                        }
                        context.read<ManageOutletBloc>().add(ManageOutletAddressChangedEvent(address: addressController.text));
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.city, style: kAppLblTinyFontRegular(context)),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<OutletCitiesResponseModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.selectedCity,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.cityList.map((OutletCitiesResponseModel item) {
                          return DropdownMenuItem<OutletCitiesResponseModel>(value: item, child: Text(item.name.toString()));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<ManageOutletBloc>().add(ManageOutletCityChangeEvent(city: newValue!));
                        },
                      ),
                    ),
                    state.localityList.isNotEmpty ? kAppSpacerVertical(height: 20) : const SizedBox(),
                    state.localityList.isNotEmpty ? Text(translate.locality, style: kAppLblTinyFontRegular(context)) : const SizedBox(),
                    state.localityList.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                            ),
                            child: DropdownButton<OutletLocalitiesResponseModel>(
                              underline: const SizedBox(),
                              isExpanded: true,
                              value: state.selectedLocality,
                              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                              style: kAppLblMediumFontRegular(context),
                              items: state.localityList.map((OutletLocalitiesResponseModel item) {
                                return DropdownMenuItem<OutletLocalitiesResponseModel>(value: item, child: Text(item.name.toString()));
                              }).toList(),
                              onChanged: (newValue) {
                                context.read<ManageOutletBloc>().add(ManageOutletLocalityChangeEvent(locality: newValue!));
                              },
                            ),
                          )
                        : const SizedBox(),
                    kAppSpacerVertical(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: latitudeController,
                            readOnly: true,
                            enabled: false,
                            decoration: kAppInputDecoration(
                              context,
                              prefixIcon: const Icon(Icons.location_on_outlined),
                              lblText: translate.outlet_latitude,
                              errText: state.latitudeField.displayError != null ? translate.form_required : null,
                            ),
                            style: kAppLblSmallFontMedium(context),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        kAppSpacerHorizontal(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: longitudeController,
                            readOnly: true,
                            enabled: false,
                            decoration: kAppInputDecoration(
                              context,
                              prefixIcon: const Icon(Icons.location_on_outlined),
                              lblText: translate.outlet_longitude,
                              errText: state.longitudeField.displayError != null ? translate.form_required : null,
                            ),
                            style: kAppLblSmallFontMedium(context),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 20),
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: !kIsWeb
                          ? Stack(
                              children: [
                                GoogleMap(
                                  key: GlobalKey(),
                                  onMapCreated: (GoogleMapController controller) async {
                                    if (!_googleMapController.isCompleted) {
                                      _googleMapController.complete(controller);
                                      CameraPosition nepPos = CameraPosition(target: LatLng(double.parse(state.latitudeField.value), double.parse(state.longitudeField.value)), zoom: 10);
                                      await controller.animateCamera(CameraUpdate.newCameraPosition(nepPos));
                                    }
                                  },
                                  initialCameraPosition: CameraPosition(zoom: 10, tilt: 0, bearing: 30, target: LatLng(double.parse(state.latitudeField.value), double.parse(state.longitudeField.value))),
                                  onTap: (LatLng newPosition) {
                                    context.read<ManageOutletBloc>().add(ManageOutletLocationChangeEvent(latitude: newPosition.latitude, longitude: newPosition.longitude));
                                  },
                                  markers: <Marker>{
                                    Marker(
                                      draggable: true,
                                      markerId: const MarkerId("OutletLocation"),
                                      position: LatLng(double.parse(state.latitudeField.value), double.parse(state.longitudeField.value)),
                                      icon: BitmapDescriptor.defaultMarker,
                                      onDragEnd: ((newPosition) {
                                        context.read<ManageOutletBloc>().add(ManageOutletLocationChangeEvent(latitude: newPosition.latitude, longitude: newPosition.longitude));
                                      }),
                                    ),
                                  },
                                ),
                              ],
                            )
                          : Text(translate.google_map_here, style: kAppLblLargeFontBold(context)),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: cuisineController,
                      focusNode: _cuisineFocusNode,
                      readOnly: true,
                      decoration: kAppInputDecoration(context, lblText: translate.form_cuisine, errText: state.cuisineField.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return SelectCuisineModalScreen(cuisine: state.cuisineIds.isEmpty ? [] : state.cuisineIds.split(','));
                                },
                                fullscreenDialog: true,
                              ),
                            )
                            .then((value) {
                              if (!context.mounted) return;
                              if (value != null && value.toString().isNotEmpty) {
                                ModalNavigationBackResponseModel param = ModalNavigationBackResponseModel.fromJson(value);
                                context.read<ManageOutletBloc>().add(ManageOutletCuisineChangeEvent(param: param));
                              }
                            });
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: typeController,
                      focusNode: _typeFocusNode,
                      readOnly: true,
                      decoration: kAppInputDecoration(context, lblText: translate.outlet_type, errText: state.typeField.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return SelectRestaurantTypeModalScreen(type: state.typeIds.isEmpty ? [] : state.typeIds.split(','));
                                },
                                fullscreenDialog: true,
                              ),
                            )
                            .then((value) {
                              if (!context.mounted) return;
                              if (value != null && value.toString().isNotEmpty) {
                                ModalNavigationBackResponseModel param = ModalNavigationBackResponseModel.fromJson(value);
                                context.read<ManageOutletBloc>().add(ManageOutletTypeChangeEvent(param: param));
                              }
                            });
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: facilitiesController,
                      focusNode: _facilityFocusNode,
                      readOnly: true,
                      decoration: kAppInputDecoration(context, lblText: translate.outlet_facilities, errText: state.facilitiesField.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return SelectRestaurantFacilitiesModalScreen(facilities: state.facilitiesIds.isEmpty ? [] : state.facilitiesIds.split(','));
                                },
                                fullscreenDialog: true,
                              ),
                            )
                            .then((value) {
                              if (!context.mounted) return;
                              if (value != null && value.toString().isNotEmpty) {
                                ModalNavigationBackResponseModel param = ModalNavigationBackResponseModel.fromJson(value);
                                context.read<ManageOutletBloc>().add(ManageOutletFacilitiesChangeEvent(param: param));
                              }
                            });
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.home_delivery_available, style: kAppLblTinyFontRegular(context)),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<HomeDeliverySupportModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.homeDelivery,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.homeDeliveryList.map((HomeDeliverySupportModel item) {
                          return DropdownMenuItem<HomeDeliverySupportModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<ManageOutletBloc>().add(ManageOutletHomeDeliveryChangeEvent(option: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.take_away_available, style: kAppLblTinyFontRegular(context)),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<TakeAwaySupportModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.takeAway,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.takeAwayList.map((TakeAwaySupportModel item) {
                          return DropdownMenuItem<TakeAwaySupportModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<ManageOutletBloc>().add(ManageOutletTakeAwayChangeEvent(option: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.schedule_orders, style: kAppLblTinyFontRegular(context)),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<ScheduleOrderSupportModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.scheduleOrder,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.scheduleOrderList.map((ScheduleOrderSupportModel item) {
                          return DropdownMenuItem<ScheduleOrderSupportModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<ManageOutletBloc>().add(ManageOutletScheduleOrderChangeEvent(option: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.form_food_license, style: kAppLblTinyFontRegular(context)),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<OutletLicenseResponseModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.selectedLicense,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.licenseList.map((OutletLicenseResponseModel item) {
                          return DropdownMenuItem<OutletLicenseResponseModel>(value: item, child: Text(item.name.toString()));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<ManageOutletBloc>().add(ManageOutletLicenseChangeEvent(option: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: foodLicenseController,
                      focusNode: _foodLicenseFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_food_license, errText: state.licenseField.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          foodLicenseController.text = value.trimLeft();
                          foodLicenseController.selection = TextSelection.collapsed(offset: foodLicenseController.text.length);
                        }
                        context.read<ManageOutletBloc>().add(ManageOutletFoodLicenseChangedEvent(license: foodLicenseController.text));
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: minOrderAmountController,
                      focusNode: _minOrderAmountFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_min_order_amount, errText: state.minOrderAmountField.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<ManageOutletBloc>().add(ManageOutletMinOrderAmountChangedEvent(minOrderAmount: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: dishForTwoController,
                      focusNode: _dishForTwoFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_dish_for_two, errText: state.dishPriceForTwoField.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<ManageOutletBloc>().add(ManageOutletDishForTwoChangedEvent(dishForTwo: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: deliveryTimeController,
                      readOnly: true,
                      decoration: kAppInputDecoration(context, lblText: translate.form_appx_delivery_time, errText: state.deliveryTimeField.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: false,
                          enableDrag: false,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          builder: (BuildContext context) {
                            return FractionallySizedBox(heightFactor: 0.65, child: SelectDeliverytimeModalScreen(deliveryTime: state.deliveryTimeField.value));
                          },
                        ).then((value) {
                          if (!context.mounted) return;
                          if (value != null && value.toString().isNotEmpty) {
                            context.read<ManageOutletBloc>().add(ManageOutletDeliveryTimeChangeEvent(time: value!));
                          }
                        });
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: socialFacebookController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_social_fb),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<ManageOutletBloc>().add(ManageOutletSocialLinkChangeEvent(type: 'facebook', value: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: socialInstagramController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_social_instagram),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<ManageOutletBloc>().add(ManageOutletSocialLinkChangeEvent(type: 'instagram', value: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: socialXController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_social_x),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<ManageOutletBloc>().add(ManageOutletSocialLinkChangeEvent(type: 'x', value: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: socialYoutubeController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_social_youtube),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<ManageOutletBloc>().add(ManageOutletSocialLinkChangeEvent(type: 'youtube', value: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: socialLinkedInController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_social_linkedin),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<ManageOutletBloc>().add(ManageOutletSocialLinkChangeEvent(type: 'linkedin', value: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: socialPinterestController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_social_pinterest),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<ManageOutletBloc>().add(ManageOutletSocialLinkChangeEvent(type: 'pinterest', value: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    state.isNew
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                focusNode: _emailFocusNode,
                                controller: emailController,
                                decoration: kAppInputDecoration(context, prefixIcon: const Icon(Icons.email_outlined), lblText: translate.email_lbl, errText: state.emailField.displayError != null ? translate.form_required : null),
                                style: kAppLblSmallFontMedium(context),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) => context.read<ManageOutletBloc>().add(ManageOutletEmailChangedEvent(email: value)),
                                textInputAction: TextInputAction.next,
                              ),
                              kAppSpacerVertical(height: 20),
                              TextFormField(
                                focusNode: _passwordFocusNode,
                                decoration: kAppInputDecoration(
                                  context,
                                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                                  lblText: translate.password_lbl,
                                  errText: state.passwordField.displayError != null ? translate.form_required : null,
                                  suffixIcon: Icon(_passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                  haveSuffixIcon: true,
                                  onPressed: () => setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  }),
                                ),
                                style: kAppLblSmallFontMedium(context),
                                obscureText: !_passwordVisible,
                                keyboardType: TextInputType.text,
                                onChanged: (value) => context.read<ManageOutletBloc>().add(ManageOutletPasswordChangedEvent(password: value)),
                                textInputAction: TextInputAction.done,
                              ),
                              kAppSpacerVertical(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      focusNode: _firstNameFocusNode,
                                      controller: firstNameController,
                                      decoration: kAppInputDecoration(
                                        context,
                                        prefixIcon: const Icon(Icons.person_outline),
                                        lblText: translate.form_first_name,
                                        errText: state.firstNameField.displayError != null ? translate.form_required : null,
                                      ),
                                      style: kAppLblSmallFontMedium(context),
                                      keyboardType: TextInputType.text,
                                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                                      onChanged: (value) {
                                        if (value.startsWith(' ')) {
                                          firstNameController.text = value.trimLeft();
                                          firstNameController.selection = TextSelection.collapsed(offset: firstNameController.text.length);
                                        }
                                        if (RegExp(r'^[0-9]').hasMatch(value)) {
                                          firstNameController.text = value.substring(1);
                                          firstNameController.selection = TextSelection.collapsed(offset: firstNameController.text.length);
                                        }
                                        context.read<ManageOutletBloc>().add(ManageOutletFirstNameChangedEvent(firstName: firstNameController.text));
                                      },
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  kAppSpacerHorizontal(width: 10),
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      focusNode: _lastNameFocusNode,
                                      controller: lastNameController,
                                      decoration: kAppInputDecoration(
                                        context,
                                        prefixIcon: const Icon(Icons.person_outline),
                                        lblText: translate.form_last_name,
                                        errText: state.lastNameField.displayError != null ? translate.form_required : null,
                                      ),
                                      style: kAppLblSmallFontMedium(context),
                                      keyboardType: TextInputType.text,
                                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                                      onChanged: (value) {
                                        if (value.startsWith(' ')) {
                                          lastNameController.text = value.trimLeft();
                                          lastNameController.selection = TextSelection.collapsed(offset: lastNameController.text.length);
                                        }
                                        if (RegExp(r'^[0-9]').hasMatch(value)) {
                                          lastNameController.text = value.substring(1);
                                          lastNameController.selection = TextSelection.collapsed(offset: lastNameController.text.length);
                                        }
                                        context.read<ManageOutletBloc>().add(ManageOutletLastNameChangedEvent(lastName: lastNameController.text));
                                      },
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ],
                              ),
                              kAppSpacerVertical(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      controller: countryCodeController,
                                      focusNode: _countryCodeFocusNode,
                                      readOnly: true,
                                      decoration: kAppInputDecoration(context, lblText: translate.form_country_code, errText: state.countryCodeField.displayError != null ? translate.form_required : null),
                                      style: kAppLblSmallFontMedium(context),
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(
                                              MaterialPageRoute(
                                                builder: (BuildContext context) {
                                                  return CountryCodeModalScreen(code: state.countryCodeField.value);
                                                },
                                                fullscreenDialog: true,
                                              ),
                                            )
                                            .then((value) {
                                              if (!context.mounted) return;
                                              CountryCodeModalResponseModel countryCodeResponse = CountryCodeModalResponseModel.fromJson(value);
                                              if (countryCodeResponse.action!) {
                                                countryCodeController.text = '${countryCodeResponse.flag} (${countryCodeResponse.dialCode})';
                                                context.read<ManageOutletBloc>().add(ManageOutletCountryCodeChangedEvent(countryCode: countryCodeResponse.dialCode!));
                                              }
                                            });
                                      },
                                    ),
                                  ),
                                  kAppSpacerHorizontal(width: 10),
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      focusNode: _mobileNuberFocusNode,
                                      controller: mobileNumberController,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                                      decoration: kAppInputDecoration(
                                        context,
                                        prefixIcon: const Icon(Icons.person_outline),
                                        lblText: translate.form_mobile_number,
                                        errText: state.mobileNumberField.displayError != null ? translate.form_required : null,
                                      ),
                                      style: kAppLblSmallFontMedium(context),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) => context.read<ManageOutletBloc>().add(ManageOutletMobileNumberChangedEvent(mobileNumber: value)),
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ],
                              ),
                              kAppSpacerVertical(height: 20),
                            ],
                          )
                        : const SizedBox(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          controller: outletTranslationTabController,
                          physics: const NeverScrollableScrollPhysics(),
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Theme.of(context).hintColor,
                          indicatorColor: Theme.of(context).primaryColor,
                          labelStyle: kAppStyleTabTitleStyle(context),
                          unselectedLabelStyle: kAppStyleTabTitleStyle(context),
                          labelPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          tabs: List.generate(translations.length, (index) => Text(translations[index].name!)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: outletTranslationTabController,
                        children: List.generate(
                          translations.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  initialValue: translations[index].title,
                                  decoration: kAppInputDecoration(context, lblText: "${translate.form_name} ${translations[index].nativeName}"),
                                  style: kAppLblLargeFontMedium(context),
                                  onChanged: (value) {
                                    setState(() {
                                      translations[index].title = value;
                                    });
                                  },
                                  textInputAction: TextInputAction.done,
                                ),
                                kAppSpacerVertical(height: 20),
                                TextFormField(
                                  initialValue: translations[index].shortDescription,
                                  maxLines: 3,
                                  decoration: kAppInputDecoration(context, lblText: "${translate.form_short_description} ${translations[index].nativeName}"),
                                  style: kAppLblLargeFontMedium(context),
                                  onChanged: (value) {
                                    setState(() {
                                      translations[index].shortDescription = value;
                                    });
                                  },
                                  textInputAction: TextInputAction.done,
                                ),
                                kAppSpacerVertical(height: 20),
                                TextFormField(
                                  initialValue: translations[index].address,
                                  maxLines: 3,
                                  decoration: kAppInputDecoration(context, lblText: "${translate.form_address} ${translations[index].nativeName}"),
                                  style: kAppLblLargeFontMedium(context),
                                  onChanged: (value) {
                                    setState(() {
                                      translations[index].address = value;
                                    });
                                  },
                                  textInputAction: TextInputAction.done,
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                  onPressed: isValid ? () => context.read<ManageOutletBloc>().add(ManageOutletSubmitEvent(translations: translations)) : null,
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 50.0,
                                  ),
                                  child: state.status.isSubmit ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.submit_lbl),
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

class ManageOutletLoadingView extends StatelessWidget {
  const ManageOutletLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(
          style: SkeletonLineStyle(height: 100.0, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5.0)),
        ),
        kAppSpacerVertical(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(height: 100.0, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5.0)),
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

class ManageOutletErrorView extends StatelessWidget {
  const ManageOutletErrorView({super.key});

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