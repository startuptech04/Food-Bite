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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/media_gallery_modal_response_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_food_modal_response_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_instruction_list_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_instruction_modal_response_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_offday_modal_response_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_package_list_response_model.dart';
import 'package:vendor/app/core/models/tiffin_subscription_timeslot_modal_response_model.dart';
import 'package:vendor/app/core/models/translations/tiffin_subscription_form_translation.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/app/presentation/pages/account/tiffin_subscription/dialog_tiffin_subscription/bloc/dialog_tiffin_subscription_bloc.dart';
import 'package:vendor/app/presentation/pages/media/media_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/tiffin_subscription_foods/tiffin_subscription_food_view.dart';
import 'package:vendor/app/presentation/pages/modals/tiffin_subscription_instruction_modal/tiffin_subscription_instruction_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/tiffin_subscription_offdays_modal/tiffin_subscription_offdays_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/tiffin_subscription_timeslot_modal/tiffin_subscription_timeslot_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DialogTiffinSubscriptionScreen extends StatelessWidget {
  final bool isNew;
  final TiffinSubcriptionPackageConfigModel model;
  const DialogTiffinSubscriptionScreen({super.key, required this.isNew, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DialogTiffinSubscriptionBloc()..add(DialogTiffinSubscriptionInitialEvent(isNew: isNew, model: model)),
      child: DialogTiffinSubscriptionView(isNew: isNew, model: model),
    );
  }
}

class DialogTiffinSubscriptionView extends StatefulWidget {
  final bool isNew;
  final TiffinSubcriptionPackageConfigModel model;
  const DialogTiffinSubscriptionView({super.key, required this.isNew, required this.model});

  @override
  State<DialogTiffinSubscriptionView> createState() => _DialogTiffinSubscriptionViewState();
}

class _DialogTiffinSubscriptionViewState extends State<DialogTiffinSubscriptionView> with TickerProviderStateMixin {
  final TextEditingController _tiffinNameController = TextEditingController();
  final TextEditingController _tiffinShortDescriptionController = TextEditingController();
  final TextEditingController _tiffinFoodsController = TextEditingController();
  final TextEditingController _tiffinDeliveryAreaController = TextEditingController();
  final TextEditingController _tiffinPriceController = TextEditingController();
  final TextEditingController _tiffinDiscountController = TextEditingController();
  final TextEditingController _tiffinTotalOrdersController = TextEditingController();
  final TextEditingController _tiffinOffDayController = TextEditingController();

  final _tiffinNameFocusNode = FocusNode();
  final _tiffinShortDescriptionFocusNode = FocusNode();
  final _tiffinFoodsFocusNode = FocusNode();
  final _tiffinDeliveryAreaFocusNode = FocusNode();
  final _tiffinPriceFocusNode = FocusNode();
  final _tiffinDiscountFocusNode = FocusNode();
  final _tiffinTotalOrdersFocusNode = FocusNode();
  final _tiffinOffDayFocusNode = FocusNode();

  List<TiffinSubscriptionFormTransation> translations = <TiffinSubscriptionFormTransation>[];
  late TabController tiffinTranslationTabController;
  @override
  void initState() {
    super.initState();
    if (AppSupportedLanguagesModel.languages.length > 1) {
      for (var element in AppSupportedLanguagesModel.languages) {
        TiffinSubscriptionFormTransation keys = TiffinSubscriptionFormTransation(name: element.value, code: element.code, nativeName: element.value, title: '', shortDescription: '');
        translations.add(keys);
      }
    }
    tiffinTranslationTabController = TabController(initialIndex: 0, length: translations.length, vsync: this);

    _tiffinNameFocusNode.addListener(() {
      if (!_tiffinNameFocusNode.hasFocus) {
        context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionNameUnfocusedEvent());
      }
    });

    _tiffinShortDescriptionFocusNode.addListener(() {
      if (!_tiffinShortDescriptionFocusNode.hasFocus) {
        context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionShortDescriptionUnfocusedEvent());
      }
    });

    _tiffinFoodsFocusNode.addListener(() {
      if (!_tiffinFoodsFocusNode.hasFocus) {
        context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionFoodsUnfocusedEvent());
      }
    });

    _tiffinDeliveryAreaFocusNode.addListener(() {
      if (!_tiffinDeliveryAreaFocusNode.hasFocus) {
        context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionDeliveryAreaUnfocusedEvent());
      }
    });

    _tiffinPriceFocusNode.addListener(() {
      if (!_tiffinPriceFocusNode.hasFocus) {
        context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionPriceUnfocusedEvent());
      }
    });

    _tiffinDiscountFocusNode.addListener(() {
      if (!_tiffinDiscountFocusNode.hasFocus) {
        context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionDiscountUnfocusedEvent());
      }
    });

    if (!widget.isNew) {
      for (var locale in translations) {
        for (var translate in widget.model.translations!) {
          if (locale.code == translate.code) {
            locale.title = translate.title;
            locale.shortDescription = translate.shortDescription!;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tiffinNameController.dispose();
    _tiffinShortDescriptionController.dispose();
    _tiffinFoodsController.dispose();
    _tiffinDeliveryAreaController.dispose();
    _tiffinPriceController.dispose();
    _tiffinDiscountController.dispose();
    _tiffinTotalOrdersController.dispose();
    _tiffinOffDayController.dispose();

    _tiffinNameFocusNode.dispose();
    _tiffinShortDescriptionFocusNode.dispose();
    _tiffinFoodsFocusNode.dispose();
    _tiffinDeliveryAreaFocusNode.dispose();
    _tiffinPriceFocusNode.dispose();
    _tiffinDiscountFocusNode.dispose();
    _tiffinTotalOrdersFocusNode.dispose();
    _tiffinOffDayFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((DialogTiffinSubscriptionBloc bloc) => bloc.state.isValid);
    return BlocConsumer<DialogTiffinSubscriptionBloc, DialogTiffinSubscriptionState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSuccess) {
          _tiffinTotalOrdersController.text = state.tiffinTotalOrders.value;
          _tiffinFoodsController.text = state.tiffinFoods.value;
          _tiffinDiscountController.text = state.tiffinDiscount.value;
          _tiffinDeliveryAreaController.text = state.tiffinDeliveryArea.value;
          if (state.offDays.isNotEmpty) {
            _tiffinOffDayController.text = state.offDays.join(',');
          }
          _tiffinNameController.text = state.tiffinName.value;
          _tiffinShortDescriptionController.text = state.tiffinShortDescription.value;
          _tiffinPriceController.text = state.tiffinPrice.value;
        } else if (state.status.isSubmitSuccess) {
          showSuccessDialog(context, translate.tiffin_subscription_added).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        } else if (state.status.isUpdateSuccess) {
          showSuccessDialog(context, translate.tiffin_subscription_updated).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isSubmit || state.status.isUpdate ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(widget.isNew ? translate.add_tiffin_subscription : translate.update_tiffin_subscription), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const DialogTiffinSubscriptionLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const DialogTiffinSubscriptionErrorView(),
                  ] else ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MediaModalScreen(selectedMedia: state.tiffinCover.value);
                                },
                                fullscreenDialog: true,
                              ),
                            )
                            .then((value) {
                              if (!context.mounted) return;
                              GalleryModalResponseModel galleryResponse = GalleryModalResponseModel.fromJson(value);
                              if (galleryResponse.action!) {
                                context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionCoverChangeEvent(image: galleryResponse.data!));
                              }
                            });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200.0,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: state.tiffinCover.displayError != null ? ThemeProvider.errorColor : ThemeProvider.greyColorBorder, width: state.tiffinCover.displayError != null ? 2 : 0),
                          shape: BoxShape.rectangle,
                        ),
                        child: CacheNetworkImageWidget(width: MediaQuery.of(context).size.width, height: 200.0, imageUrl: state.tiffinCover.value),
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _tiffinNameController,
                      focusNode: _tiffinNameFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_package_name, errText: state.tiffinName.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          _tiffinNameController.text = value.trimLeft();
                          _tiffinNameController.selection = TextSelection.collapsed(offset: _tiffinNameController.text.length);
                        }
                        if (RegExp(r'^[0-9]').hasMatch(value)) {
                          _tiffinNameController.text = value.substring(1);
                          _tiffinNameController.selection = TextSelection.collapsed(offset: _tiffinNameController.text.length);
                        }
                        context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionNameChangeEvent(name: _tiffinNameController.text));
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _tiffinShortDescriptionController,
                      focusNode: _tiffinShortDescriptionFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_package_short_description, errText: state.tiffinShortDescription.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      maxLines: 3,
                      onChanged: (value) {
                        if (value.startsWith(' ')) {
                          _tiffinShortDescriptionController.text = value.trimLeft();
                          _tiffinShortDescriptionController.selection = TextSelection.collapsed(offset: _tiffinShortDescriptionController.text.length);
                        }
                        if (RegExp(r'^[0-9]').hasMatch(value)) {
                          _tiffinShortDescriptionController.text = value.substring(1);
                          _tiffinShortDescriptionController.selection = TextSelection.collapsed(offset: _tiffinShortDescriptionController.text.length);
                        }
                        context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionShortDescriptionChangeEvent(shortDescription: _tiffinShortDescriptionController.text));
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    kAppSpacerVertical(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          controller: tiffinTranslationTabController,
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
                      height: 180,
                      child: TabBarView(
                        controller: tiffinTranslationTabController,
                        children: List.generate(
                          translations.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
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
                                  decoration: kAppInputDecoration(context, lblText: "${translate.form_short_description} ${translations[index].nativeName}"),
                                  style: kAppLblLargeFontMedium(context),
                                  onChanged: (value) {
                                    setState(() {
                                      translations[index].shortDescription = value;
                                    });
                                  },
                                  maxLines: 3,
                                  textInputAction: TextInputAction.done,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      readOnly: true,
                      controller: _tiffinFoodsController,
                      focusNode: _tiffinFoodsFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_food_included, errText: state.tiffinFoods.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return TiffinSubscriptionFoodScreen(foodList: state.foodIds);
                                },
                                fullscreenDialog: true,
                              ),
                            )
                            .then((value) {
                              if (!context.mounted) return;
                              if (value != null && value.toString().isNotEmpty) {
                                TiffinSubscriptionFoodModalResponseModel response = TiffinSubscriptionFoodModalResponseModel.fromJson(value);
                                context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionFoodsChangeEvent(foods: response));
                              }
                            });
                      },
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.can_select_addon, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<AddonValidationModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.addonValidation,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.addonValidationList.map((AddonValidationModel item) {
                          return DropdownMenuItem<AddonValidationModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionAddonSelectEvent(addon: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.can_select_variation, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<VariationValidationModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.variationValidation,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.variationValidationList.map((VariationValidationModel item) {
                          return DropdownMenuItem<VariationValidationModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionVariationSelectEvent(variation: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.support_only, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<DeliveryValidationModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.deliveryValidation,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.deliveryValidationList.map((DeliveryValidationModel item) {
                          return DropdownMenuItem<DeliveryValidationModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionDeliveryChangeEvent(delivery: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      readOnly: state.deliveryValidation.value != 'homedelivery',
                      enabled: state.deliveryValidation.value == 'homedelivery',
                      controller: _tiffinDeliveryAreaController,
                      focusNode: _tiffinDeliveryAreaFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_delivery_area, errText: state.tiffinDeliveryArea.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionDeliveryAreaChangeEvent(deliveryArea: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _tiffinPriceController,
                      focusNode: _tiffinPriceFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_package_price, errText: state.tiffinPrice.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionPriceChangeEvent(price: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.form_discount_type, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<DiscountModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.discountType,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.discountTypeList.map((DiscountModel item) {
                          return DropdownMenuItem<DiscountModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionDiscountTypeChangeEvent(type: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      controller: _tiffinDiscountController,
                      focusNode: _tiffinDiscountFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_discount, errText: state.tiffinDiscount.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      onChanged: (value) => context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionDiscountChangeEvent(discount: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.availability, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<AvailabilityValidationModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.availabilityValidation,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.availabilityValidationList.map((AvailabilityValidationModel item) {
                          return DropdownMenuItem<AvailabilityValidationModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionAvailabilityChangeEvent(availability: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Text(translate.total_days, style: kAppLblTinyFontRegular(context)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                      ),
                      child: DropdownButton<OrderValidationModel>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        value: state.orderValidation,
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        style: kAppLblMediumFontRegular(context),
                        items: state.orderValidationList.map((OrderValidationModel item) {
                          return DropdownMenuItem<OrderValidationModel>(value: item, child: Text(kAppDDTranslate(context, item.label.toString())));
                        }).toList(),
                        onChanged: (newValue) {
                          context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionOrderNumberEvent(orderNumber: newValue!));
                        },
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      readOnly: true,
                      enabled: false,
                      controller: _tiffinTotalOrdersController,
                      focusNode: _tiffinTotalOrdersFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_total_orders, errText: state.tiffinTotalOrders.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      readOnly: true,
                      controller: _tiffinOffDayController,
                      focusNode: _tiffinOffDayFocusNode,
                      decoration: kAppInputDecoration(context, lblText: translate.form_off_days),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return TiffinSubscriptionOffdaysModalScreen(offDays: state.offDays);
                                },
                                fullscreenDialog: true,
                              ),
                            )
                            .then((value) {
                              if (!context.mounted) return;
                              if (value != null && value.toString().isNotEmpty) {
                                TiffinSubscriptionOffDayModalResponseModel response = TiffinSubscriptionOffDayModalResponseModel.fromJson(value);
                                context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionOffDayEvent(offdays: response));
                              }
                            });
                      },
                    ),
                    kAppSpacerVertical(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(translate.available_slots, style: kAppLblMediumFontMedium(context)),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              isDismissible: false,
                              enableDrag: false,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (BuildContext context) {
                                return const FractionallySizedBox(
                                  heightFactor: 0.65,
                                  child: TiffinSubscriptionTimeslotModalScreen(isNew: true, startTime: '', endTime: ''),
                                );
                              },
                            ).then((value) {
                              if (!context.mounted) return;
                              if (value != null && value != '' && value.toString().isNotEmpty) {
                                TiffinSubscriptionTimeSlotModalResponseModel slot = TiffinSubscriptionTimeSlotModalResponseModel.fromJson(value);
                                context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionTimeSlotEvent(timeslot: slot));
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(translate.add, style: kAppLblMediumFontMedium(context, color: 'primary')),
                              Icon(Icons.add, color: Theme.of(context).primaryColor, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        state.timeslotList.length,
                        (index) => Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("${state.timeslotList[index].startTime!} - ${state.timeslotList[index].endTime!}", style: kAppLblTinyFontRegular(context)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        enableDrag: false,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        builder: (BuildContext context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.65,
                                            child: TiffinSubscriptionTimeslotModalScreen(isNew: false, startTime: state.timeslotList[index].startTime!, endTime: state.timeslotList[index].endTime!),
                                          );
                                        },
                                      ).then((value) {
                                        if (!context.mounted) return;
                                        if (value != null && value != '' && value.toString().isNotEmpty) {
                                          TiffinSubscriptionTimeSlotModalResponseModel slot = TiffinSubscriptionTimeSlotModalResponseModel.fromJson(value);
                                          context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionEditSlotEvent(index: index, timeslot: slot));
                                        }
                                      });
                                    },
                                    icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 12),
                                  ),
                                  IconButton(
                                    onPressed: () => context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionDeleteSlotEvent(index: index)),
                                    icon: const FaIcon(FontAwesomeIcons.trashCan, size: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    kAppSpacerVertical(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(translate.package_instruction, style: kAppLblMediumFontMedium(context)),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              isDismissible: false,
                              enableDrag: false,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (BuildContext context) {
                                return const FractionallySizedBox(
                                  heightFactor: 0.65,
                                  child: TiffinSubscriptionInstructionModalScreen(isNew: true, title: '', translation: []),
                                );
                              },
                            ).then((value) {
                              if (!context.mounted) return;
                              if (value != null && value.toString().isNotEmpty) {
                                TiffinSubscriptionInstructionModalResponseModel model = TiffinSubscriptionInstructionModalResponseModel.fromJson(jsonDecode(value));
                                TiffinSubscriptionInstructionModel newInstruction = TiffinSubscriptionInstructionModel(name: model.name, translations: model.translation, locale: state.appLocale.toString());
                                context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionInstructionAddEvent(instruction: newInstruction));
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(translate.add, style: kAppLblMediumFontMedium(context, color: 'primary')),
                              Icon(Icons.add, color: Theme.of(context).primaryColor, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        state.instructions.length,
                        (index) => Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(state.instructions[index].displayName!, maxLines: 2, overflow: TextOverflow.ellipsis, style: kAppLblTinyFontRegular(context)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        enableDrag: false,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        builder: (BuildContext context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.65,
                                            child: TiffinSubscriptionInstructionModalScreen(isNew: false, title: state.instructions[index].name!, translation: state.instructions[index].translations!),
                                          );
                                        },
                                      ).then((value) {
                                        if (!context.mounted) return;
                                        if (value != null && value.toString().isNotEmpty) {
                                          TiffinSubscriptionInstructionModalResponseModel model = TiffinSubscriptionInstructionModalResponseModel.fromJson(jsonDecode(value));
                                          TiffinSubscriptionInstructionModel newInstruction = TiffinSubscriptionInstructionModel(name: model.name, translations: model.translation, locale: state.appLocale.toString());
                                          context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionEditInstructionEvent(index: index, instruction: newInstruction));
                                        }
                                      });
                                    },
                                    icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 12),
                                  ),
                                  IconButton(
                                    onPressed: () => context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionDeleteInstructionEvent(index: index)),
                                    icon: const FaIcon(FontAwesomeIcons.trashCan, size: 12),
                                  ),
                                ],
                              ),
                            ],
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
                                  onPressed: isValid ? () => context.read<DialogTiffinSubscriptionBloc>().add(DialogTiffinSubscriptionSubmitEvent(translations: translations)) : null,
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

class DialogTiffinSubscriptionLoadingView extends StatelessWidget {
  const DialogTiffinSubscriptionLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kAppSpacerVertical(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(height: 150, width: MediaQuery.of(context).size.width, borderRadius: BorderRadius.circular(5)),
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

class DialogTiffinSubscriptionErrorView extends StatelessWidget {
  const DialogTiffinSubscriptionErrorView({super.key});

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