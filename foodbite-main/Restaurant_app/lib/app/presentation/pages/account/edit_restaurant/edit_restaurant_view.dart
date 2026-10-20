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
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/media_gallery_modal_response_model.dart';
import 'package:vendor/app/core/models/modal_navigation_back_response_model.dart';
import 'package:vendor/app/core/models/translations/edit_restaurant_form_translation.dart';
import 'package:vendor/app/core/models/vendor_detail_for_update_response_model.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/app/presentation/pages/account/edit_restaurant/bloc/edit_restaurant_bloc.dart';
import 'package:vendor/app/presentation/pages/media/media_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/select_cuisine_modal/select_cuisine_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/select_deliverytime_modal/select_deliverytime_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/select_restaurant_facilities_modal/select_restaurant_facilities_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/select_restaurant_type_modal/select_restaurant_type_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class EditRestaurantScreen extends StatelessWidget {
  const EditRestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditRestaurantView();
  }
}

class EditRestaurantView extends StatefulWidget {
  const EditRestaurantView({super.key});

  @override
  State<EditRestaurantView> createState() => _EditRestaurantViewState();
}

class _EditRestaurantViewState extends State<EditRestaurantView> with TickerProviderStateMixin {
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

  List<EditRestaurantFormTranslations> translations = <EditRestaurantFormTranslations>[];
  late TabController restaurantTranslationTabController;

  @override
  void initState() {
    super.initState();
    context.read<EditRestaurantBloc>().add(EditRestaurantInitialEvent());
    if (AppSupportedLanguagesModel.languages.length > 1) {
      for (var element in AppSupportedLanguagesModel.languages) {
        EditRestaurantFormTranslations keys = EditRestaurantFormTranslations(name: element.value, code: element.code, nativeName: element.value, title: '', address: '', shortDescription: '');
        translations.add(keys);
      }
    }

    restaurantTranslationTabController = TabController(initialIndex: 0, length: translations.length, vsync: this);

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        context.read<EditRestaurantBloc>().add(EditRestaurantNameUnfocusedEvent());
      }
    });

    _shortDescriptionFocusNode.addListener(() {
      if (!_shortDescriptionFocusNode.hasFocus) {
        context.read<EditRestaurantBloc>().add(EditRestaurantShortDescriptionUnfocusedEvent());
      }
    });

    _addressFocusNode.addListener(() {
      if (!_addressFocusNode.hasFocus) {
        context.read<EditRestaurantBloc>().add(EditRestaurantAddressUnfocusedEvent());
      }
    });

    _minOrderAmountFocusNode.addListener(() {
      if (!_minOrderAmountFocusNode.hasFocus) {
        context.read<EditRestaurantBloc>().add(EditRestaurantMinOrderAmountUnfocusedEvent());
      }
    });

    _dishForTwoFocusNode.addListener(() {
      if (!_dishForTwoFocusNode.hasFocus) {
        context.read<EditRestaurantBloc>().add(EditRestaurantDishForTwoUnfocusedEvent());
      }
    });

    _foodLicenseFocusNode.addListener(() {
      if (!_foodLicenseFocusNode.hasFocus) {
        context.read<EditRestaurantBloc>().add(EditRestaurantFoodLicenseUnfocusedEvent());
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
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((EditRestaurantBloc bloc) => bloc.state.isValid);
    return BlocConsumer<EditRestaurantBloc, EditRestaurantState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isFetched) {
          nameController.text = state.model.details!.name!;
          shortDescriptionController.text = state.model.details!.shortDescription!;
          addressController.text = state.model.details!.address!;
          cuisineController.text = state.cuisineNames;
          typeController.text = state.typeName;
          facilitiesController.text = state.facilitiesName;
          minOrderAmountController.text = state.model.details!.minOrderAmount!.toString();
          dishForTwoController.text = state.model.details!.dishPriceForTwo!.toString();
          foodLicenseController.text = state.model.details!.licenseId!;
          deliveryTimeController.text = state.model.details!.approxDeliveryTime!;
          socialFacebookController.text = state.socialFacebook;
          socialInstagramController.text = state.socialInstagram;
          socialXController.text = state.socialX;
          socialYoutubeController.text = state.socialYoutube;
          socialLinkedInController.text = state.socialLinkedIn;
          socialPinterestController.text = state.socialPinterest;
          for (var locale in translations) {
            for (var translate in state.model.details!.translations!) {
              if (locale.code == translate.code) {
                locale.title = translate.title!;
                locale.address = translate.address!;
                locale.shortDescription = translate.shortDescription!;
              }
            }
          }
        } else if (state.status.isChangeDetailFromModal) {
          cuisineController.text = state.cuisineNames;
          typeController.text = state.typeName;
          facilitiesController.text = state.facilitiesName;
          deliveryTimeController.text = state.deliveryTime.value;
        } else if (state.status.isSubmitSuccess) {
          showSuccessDialog(context, translate.detail_updated).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop();
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isSubmit ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.edit_restaurant_detail), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const EditRestaurantLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const EditRestaurantErrorView(),
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
                                      return MediaModalScreen(selectedMedia: state.logo);
                                    },
                                    fullscreenDialog: true,
                                  ),
                                )
                                .then((value) {
                                  if (!context.mounted) return;
                                  GalleryModalResponseModel galleryResponse = GalleryModalResponseModel.fromJson(value);
                                  if (galleryResponse.action!) {
                                    context.read<EditRestaurantBloc>().add(EditRestaurantLogoChangeEvent(logo: galleryResponse.data!));
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
                                  border: Border.all(color: ThemeProvider.greyColorBorder, width: 2),
                                  shape: BoxShape.rectangle,
                                ),
                                child: CacheNetworkImageWidget(width: 100, height: 100, imageUrl: state.logo),
                              ),
                              kAppSpacerVertical(height: 5),
                              Text("${translate.restaurant_logo} (1:1)", style: kAppLblTinyFontRegular(context)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 20),
                    Text("${translate.restaurant_cover} (2:1)", style: kAppLblTinyFontRegular(context)),
                    kAppSpacerVertical(height: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MediaModalScreen(selectedMedia: state.cover);
                                },
                                fullscreenDialog: true,
                              ),
                            )
                            .then((value) {
                              if (!context.mounted) return;
                              GalleryModalResponseModel galleryResponse = GalleryModalResponseModel.fromJson(value);
                              if (galleryResponse.action!) {
                                context.read<EditRestaurantBloc>().add(EditRestaurantCoverChangeEvent(cover: galleryResponse.data!));
                              }
                            });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: ThemeProvider.greyColorBorder, width: 2),
                          shape: BoxShape.rectangle,
                        ),
                        child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width, height: 150, imageUrl: state.cover),
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: nameController,
                      focusNode: _nameFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_restaurant_name, errText: state.name.displayError != null ? translate.form_required : null),
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
                        context.read<EditRestaurantBloc>().add(EditRestaurantNameChangedEvent(name: nameController.text));
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: shortDescriptionController,
                      focusNode: _shortDescriptionFocusNode,
                      maxLines: 3,
                      decoration: kAppInputDecoration(context, lblText: translate.form_short_description, errText: state.shortDescription.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          shortDescriptionController.text = value.trimLeft();
                          shortDescriptionController.selection = TextSelection.collapsed(offset: shortDescriptionController.text.length);
                        }
                        context.read<EditRestaurantBloc>().add(EditRestaurantShortDescriptionChangedEvent(shortDescription: shortDescriptionController.text));
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: addressController,
                      focusNode: _addressFocusNode,
                      maxLines: 3,
                      decoration: kAppInputDecoration(context, lblText: translate.form_address, errText: state.address.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          addressController.text = value.trimLeft();
                          addressController.selection = TextSelection.collapsed(offset: addressController.text.length);
                        }
                        context.read<EditRestaurantBloc>().add(EditRestaurantAddressChangedEvent(address: addressController.text));
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: cuisineController,
                      readOnly: true,
                      decoration: kAppInputDecoration(context, lblText: translate.form_cuisine, errText: state.cuisineNameField.displayError != null ? translate.form_required : null),
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
                                context.read<EditRestaurantBloc>().add(EditRestaurantCuisineChangeEvent(param: param));
                              }
                            });
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: typeController,
                      readOnly: true,
                      decoration: kAppInputDecoration(context, lblText: translate.form_restaurant_type, errText: state.restaurantTypeField.displayError != null ? translate.form_required : null),
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
                                context.read<EditRestaurantBloc>().add(EditRestaurantTypeChangeEvent(param: param));
                              }
                            });
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: facilitiesController,
                      readOnly: true,
                      decoration: kAppInputDecoration(context, lblText: translate.form_restaurant_facilities, errText: state.restaurantFacilitiesField.displayError != null ? translate.form_required : null),
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
                                context.read<EditRestaurantBloc>().add(EditRestaurantFacilitiesChangeEvent(param: param));
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
                          context.read<EditRestaurantBloc>().add(EditRestaurantHomeDeliveryChangeEvent(option: newValue!));
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
                          context.read<EditRestaurantBloc>().add(EditRestaurantTakeAwayChangeEvent(option: newValue!));
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
                          context.read<EditRestaurantBloc>().add(EditRestaurantScheduleOrderChangeEvent(option: newValue!));
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
                      child: DropdownButton<RestaurantFoodLicenseConfigModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.license,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.licenseList.map((RestaurantFoodLicenseConfigModel item) {
                          return DropdownMenuItem<RestaurantFoodLicenseConfigModel>(value: item, child: Text(item.name.toString()));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<EditRestaurantBloc>().add(EditRestaurantLicenseChangeEvent(option: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: foodLicenseController,
                      focusNode: _foodLicenseFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_food_license, errText: state.foodLicense.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          foodLicenseController.text = value.trimLeft();
                          foodLicenseController.selection = TextSelection.collapsed(offset: foodLicenseController.text.length);
                        }
                        context.read<EditRestaurantBloc>().add(EditRestaurantFoodLicenseChangedEvent(license: foodLicenseController.text));
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: minOrderAmountController,
                      focusNode: _minOrderAmountFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_min_order_amount, errText: state.minOrderAmount.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<EditRestaurantBloc>().add(EditRestaurantMinOrderAmountChangedEvent(minOrderAmount: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: dishForTwoController,
                      focusNode: _dishForTwoFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_dish_for_two, errText: state.dishPriceForTwo.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<EditRestaurantBloc>().add(EditRestaurantDishForTwoChangedEvent(dishForTwo: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: deliveryTimeController,
                      readOnly: true,
                      decoration: kAppInputDecoration(context, lblText: translate.form_appx_delivery_time, errText: state.deliveryTime.displayError != null ? translate.form_required : null),
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
                            return FractionallySizedBox(heightFactor: 0.65, child: SelectDeliverytimeModalScreen(deliveryTime: state.deliveryTime.value));
                          },
                        ).then((value) {
                          if (!context.mounted) return;
                          if (value != null && value.toString().isNotEmpty) {
                            context.read<EditRestaurantBloc>().add(EditRestaurantDeliveryTimeChangeEvent(time: value!));
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
                      onChanged: (value) => context.read<EditRestaurantBloc>().add(EditRestaurantSocialLinkChangeEvent(type: 'facebook', value: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: socialInstagramController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_social_instagram),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<EditRestaurantBloc>().add(EditRestaurantSocialLinkChangeEvent(type: 'instagram', value: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: socialXController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_social_x),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<EditRestaurantBloc>().add(EditRestaurantSocialLinkChangeEvent(type: 'x', value: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: socialYoutubeController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_social_youtube),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<EditRestaurantBloc>().add(EditRestaurantSocialLinkChangeEvent(type: 'youtube', value: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: socialLinkedInController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_social_linkedin),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<EditRestaurantBloc>().add(EditRestaurantSocialLinkChangeEvent(type: 'linkedin', value: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: socialPinterestController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_social_pinterest),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<EditRestaurantBloc>().add(EditRestaurantSocialLinkChangeEvent(type: 'pinterest', value: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          controller: restaurantTranslationTabController,
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
                        controller: restaurantTranslationTabController,
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
                                  onPressed: isValid ? () => context.read<EditRestaurantBloc>().add(EditRestaurantSubmitEvent(translations: translations)) : null,
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

class EditRestaurantLoadingView extends StatelessWidget {
  const EditRestaurantLoadingView({super.key});

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

class EditRestaurantErrorView extends StatelessWidget {
  const EditRestaurantErrorView({super.key});

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