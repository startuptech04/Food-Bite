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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vendor/app/core/config/global_settings.dart';
import 'package:vendor/app/core/models/addons_modal_response_model.dart';
import 'package:vendor/app/core/models/category_modal_response_model.dart';
import 'package:vendor/app/core/models/custom_category_dropdown_model.dart';
import 'package:vendor/app/core/models/discount_type_model.dart';
import 'package:vendor/app/core/models/food_preferences_type_model.dart';
import 'package:vendor/app/core/models/food_taxation_modal_response_model.dart';
import 'package:vendor/app/core/models/food_variation_modal_response_model.dart';
import 'package:vendor/app/core/models/food_variation_model.dart';
import 'package:vendor/app/core/models/food_variation_options_model.dart';
import 'package:vendor/app/core/models/media_gallery_modal_response_model.dart';
import 'package:vendor/app/core/models/translations/food_form_translation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/app/presentation/pages/media/media_modal_view.dart';
import 'package:vendor/app/presentation/pages/menu/foods/action/@food_action_dialog/bloc/manage_food_action_bloc.dart';
import 'package:vendor/app/presentation/pages/menu/foods/action/variations_modal/@core/variations_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/addons_checklist/addons_checklist_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/custom_categories/custom_categories_modal.dart';
import 'package:vendor/app/presentation/pages/modals/custom_sub_categories/custom_sub_categories_modal.dart';
import 'package:vendor/app/presentation/pages/modals/food_taxation_checklist_modal/food_taxation_checklist_modal_view.dart';
import 'package:vendor/app/presentation/pages/modals/main_categories/main_categories_modal.dart';
import 'package:vendor/app/presentation/pages/modals/main_sub_categories/main_sub_categories_modal_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class ManageFoodActionScreen extends StatelessWidget {
  final String id;
  final bool isNew;
  final bool customCategory;
  const ManageFoodActionScreen({super.key, required this.id, required this.isNew, required this.customCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageFoodActionBloc(),
      child: ManageFoodActionView(id: id, isNew: isNew, customCategory: customCategory),
    );
  }
}

class ManageFoodActionView extends StatefulWidget {
  final String id;
  final bool isNew;
  final bool customCategory;
  const ManageFoodActionView({super.key, required this.id, required this.isNew, required this.customCategory});

  @override
  State<ManageFoodActionView> createState() => _ManageFoodActionViewState();
}

class _ManageFoodActionViewState extends State<ManageFoodActionView> with TickerProviderStateMixin {
  late TabController foodTranslationTabController;

  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _foodDescriptionController = TextEditingController();
  final TextEditingController _foodPriceController = TextEditingController();
  final TextEditingController _foodDiscountController = TextEditingController();
  final TextEditingController _foodCategoryController = TextEditingController();
  final TextEditingController _foodSubCategoryController = TextEditingController();
  final TextEditingController _foodPurchaseLimitController = TextEditingController();
  final TextEditingController _foodAddonsController = TextEditingController();
  final TextEditingController _foodStockNumberController = TextEditingController();
  final TextEditingController _foodStartTimeController = TextEditingController();
  final TextEditingController _foodEndTimeController = TextEditingController();
  final TextEditingController _foodTagsController = TextEditingController();
  final TextEditingController _foodTaxationController = TextEditingController();

  TimePickerEntryMode entryMode = TimePickerEntryMode.inputOnly;
  TimeOfDay? startTimePicker;
  TimeOfDay? endTimePicker;

  final _foodNameFocusNode = FocusNode();
  final _foodDescriptionFocusNode = FocusNode();
  final _foodPriceFocusNode = FocusNode();
  final _foodCategoryFocusNode = FocusNode();
  final _foodStockNumberFocusNode = FocusNode();
  final _foodTaxationFocusNode = FocusNode();

  List<FoodFormTranslations> translations = <FoodFormTranslations>[];

  final List<DiscountTypeInterfaceModel> discountTypeList = <DiscountTypeInterfaceModel>[];
  final List<CustomCategoryDropdownInterfaceModel> customCategoryDropdownList = <CustomCategoryDropdownInterfaceModel>[];
  final List<FoodPreferencesInterfaceModel> foodPrefList = <FoodPreferencesInterfaceModel>[];
  final List<StockTypeModel> stockTypeList = <StockTypeModel>[];

  List<String> tagsList = <String>[];
  @override
  void initState() {
    super.initState();

    if (AppSupportedLanguagesModel.languages.length > 1) {
      for (var element in AppSupportedLanguagesModel.languages) {
        FoodFormTranslations keys = FoodFormTranslations(name: element.value, code: element.code, nativeName: element.value, title: '', shortDescription: '');
        translations.add(keys);
      }
    }

    foodTranslationTabController = TabController(initialIndex: 0, length: translations.length, vsync: this);

    DiscountTypeInterfaceModel perValueItem = DiscountTypeInterfaceModel(type: '%', label: 'percentage_lbl');
    DiscountTypeInterfaceModel amountValueItem = DiscountTypeInterfaceModel(type: '\$', label: 'amount_lbl');
    discountTypeList.clear();
    discountTypeList.add(perValueItem);
    discountTypeList.add(amountValueItem);

    CustomCategoryDropdownInterfaceModel customCateItem = CustomCategoryDropdownInterfaceModel(label: 'custom_category_permission', value: true);
    CustomCategoryDropdownInterfaceModel mainCateItem = CustomCategoryDropdownInterfaceModel(label: 'main_category', value: false);
    customCategoryDropdownList.clear();
    customCategoryDropdownList.add(customCateItem);
    customCategoryDropdownList.add(mainCateItem);

    FoodPreferencesInterfaceModel prefNoneItem = FoodPreferencesInterfaceModel(type: 'none', label: 'none');
    FoodPreferencesInterfaceModel prefVegItem = FoodPreferencesInterfaceModel(type: 'veg', label: 'veg');
    FoodPreferencesInterfaceModel prefNonVegItem = FoodPreferencesInterfaceModel(type: 'nonveg', label: 'non_veg');
    FoodPreferencesInterfaceModel prefVeganItem = FoodPreferencesInterfaceModel(type: 'vegan', label: 'vegan');
    foodPrefList.clear();
    foodPrefList.add(prefNoneItem);
    foodPrefList.add(prefVegItem);
    foodPrefList.add(prefNonVegItem);
    foodPrefList.add(prefVeganItem);

    StockTypeModel unlimitedStock = StockTypeModel(label: 'unlimited_stock', value: 'unlimited');
    StockTypeModel limitedStock = StockTypeModel(label: 'limited_stock', value: 'limited');
    StockTypeModel dailyStock = StockTypeModel(label: 'daily_limit', value: 'daily');
    stockTypeList.clear();
    stockTypeList.add(unlimitedStock);
    stockTypeList.add(limitedStock);
    stockTypeList.add(dailyStock);

    context.read<ManageFoodActionBloc>().add(ManageFoodActionInitialEvent(id: widget.id, isNew: widget.isNew, customCategory: widget.customCategory));

    _foodNameFocusNode.addListener(() {
      if (!_foodNameFocusNode.hasFocus) {
        context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodNameUnfocusedEvent());
      }
    });

    _foodDescriptionFocusNode.addListener(() {
      if (!_foodDescriptionFocusNode.hasFocus) {
        context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodShortDescriptionUnfocusedEvent());
      }
    });

    _foodPriceFocusNode.addListener(() {
      if (!_foodPriceFocusNode.hasFocus) {
        context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodPriceUnfocusedEvent());
      }
    });

    _foodCategoryFocusNode.addListener(() {
      if (!_foodCategoryFocusNode.hasFocus) {
        context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodCategoryUnfocusedEvent());
      }
    });

    _foodStockNumberFocusNode.addListener(() {
      if (!_foodStockNumberFocusNode.hasFocus) {
        context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodStockNumberUnfocusedEvent());
      }
    });

    _foodTaxationFocusNode.addListener(() {
      if (!_foodTaxationFocusNode.hasFocus) {
        context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodTaxationUnfocusedEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _foodNameController.dispose();
    _foodDescriptionController.dispose();
    _foodPriceController.dispose();
    _foodDiscountController.dispose();
    _foodCategoryController.dispose();
    _foodSubCategoryController.dispose();
    _foodPurchaseLimitController.dispose();
    _foodAddonsController.dispose();
    _foodStockNumberController.dispose();
    _foodStartTimeController.dispose();
    _foodEndTimeController.dispose();
    _foodTagsController.dispose();
    _foodTaxationController.dispose();

    _foodNameFocusNode.dispose();
    _foodDescriptionFocusNode.dispose();
    _foodPriceFocusNode.dispose();
    _foodCategoryFocusNode.dispose();
    _foodStockNumberFocusNode.dispose();
    _foodTaxationFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<ManageFoodActionBloc, ManageFoodActionState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSuccess) {
          showSuccessDialog(context, widget.isNew ? translate.food_added : translate.food_updated).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        } else if (state.status.isLoaded) {
          _foodNameController.text = state.foodInfo.foodInfo!.name!;
          _foodDescriptionController.text = state.foodInfo.foodInfo!.shortDescription!;
          _foodPriceController.text = '${state.foodInfo.foodInfo!.price!}';
          _foodDiscountController.text = '${state.foodInfo.foodInfo!.discount!}';
          _foodPurchaseLimitController.text = '${state.foodInfo.foodInfo!.purchaseLimit!}';
          _foodAddonsController.text = state.addonsName;
          _foodTaxationController.text = state.foodTaxNameList;
          String convertTo12Hour(String time24, locale) {
            final date = DateFormat('HH:mm', locale).parse(time24);
            return DateFormat('hh:mm a', locale).format(date);
          }

          if (state.foodInfo.foodInfo!.startTime!.isNotEmpty) {
            _foodStartTimeController.text = convertTo12Hour(state.foodInfo.foodInfo!.startTime!, state.locale);
          }
          if (state.foodInfo.foodInfo!.endTime!.isNotEmpty) {
            _foodEndTimeController.text = convertTo12Hour(state.foodInfo.foodInfo!.endTime!, state.locale);
          }

          _foodStockNumberController.text = '${state.foodInfo.foodInfo!.stockNumber!}';
          tagsList = state.foodInfo.foodInfo!.tags!;
          if (state.foodInfo.foodInfo!.ownCategory!) {
            _foodCategoryController.text = state.foodInfo.foodInfo!.customCategory != null && state.foodInfo.foodInfo!.customCategory!.name!.isNotEmpty ? state.foodInfo.foodInfo!.customCategory!.name! : '';
          } else {
            _foodCategoryController.text = state.foodInfo.foodInfo!.category != null && state.foodInfo.foodInfo!.category!.name!.isNotEmpty ? state.foodInfo.foodInfo!.category!.name! : '';
          }
          if (state.foodInfo.foodInfo!.ownCategory!) {
            _foodSubCategoryController.text = state.foodInfo.foodInfo!.customSubCategory != null && state.foodInfo.foodInfo!.customSubCategory!.name!.isNotEmpty ? state.foodInfo.foodInfo!.customSubCategory!.name! : '';
          } else {
            _foodSubCategoryController.text = state.foodInfo.foodInfo!.subCategory != null && state.foodInfo.foodInfo!.subCategory!.name!.isNotEmpty ? state.foodInfo.foodInfo!.subCategory!.name! : '';
          }
          for (var serverKeys in state.foodInfo.foodInfo!.translations!) {
            for (var localKeys in translations) {
              if (serverKeys.code == localKeys.code) {
                localKeys.title = serverKeys.title;
                localKeys.shortDescription = serverKeys.shortDescription;
              }
            }
          }
        } else if (state.status.isInitialLoaded) {
          _foodStockNumberController.text = '-1';
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isInProgress ? true : false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              title: Text(widget.isNew ? translate.add_food : translate.update_food),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: Icon(Icons.close_outlined, color: Theme.of(context).iconTheme.color),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                child: state.status.isLoading
                    ? kAppCenterCircularProgress(context, strokeWidth: 3.0)
                    : Column(
                        children: [
                          kAppSpacerVertical(height: 10),
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
                                            return MediaModalScreen(selectedMedia: state.image.value);
                                          },
                                          fullscreenDialog: true,
                                        ),
                                      )
                                      .then((value) {
                                        if (!context.mounted) return;
                                        GalleryModalResponseModel galleryResponse = GalleryModalResponseModel.fromJson(value);
                                        if (galleryResponse.action!) {
                                          context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodImageChangedEvent(image: galleryResponse.data!));
                                        }
                                      });
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: state.image.displayError != null ? ThemeProvider.errorColor : ThemeProvider.greyColorBorder, width: state.image.displayError != null ? 2 : 0),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: CacheNetworkImageWidget(width: 100, height: 100, imageUrl: state.image.value),
                                ),
                              ),
                            ],
                          ),
                          kAppSpacerVertical(height: 20),
                          TextFormField(
                            focusNode: _foodNameFocusNode,
                            controller: _foodNameController,
                            decoration: kAppInputDecoration(context, lblText: translate.form_name, errText: state.name.displayError != null ? translate.form_required : null),
                            style: kAppLblLargeFontMedium(context),
                            keyboardType: TextInputType.text,
                            onChanged: (value) => context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodNameChangedEvent(name: value)),
                            textInputAction: TextInputAction.next,
                          ),
                          kAppSpacerVertical(height: 20),
                          TextFormField(
                            focusNode: _foodDescriptionFocusNode,
                            controller: _foodDescriptionController,
                            decoration: kAppInputDecoration(context, lblText: translate.form_short_description, errText: state.shortDescription.displayError != null ? translate.form_required : null),
                            style: kAppLblLargeFontMedium(context),
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            onChanged: (value) => context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodShortDescriptionChangedEvent(description: value)),
                            textInputAction: TextInputAction.done,
                          ),
                          kAppSpacerVertical(height: 20),
                          TextFormField(
                            focusNode: _foodPriceFocusNode,
                            controller: _foodPriceController,
                            decoration: kAppInputDecoration(context, lblText: kAppPriceLbl(translate.form_price), errText: state.price.displayError != null ? translate.form_required : null),
                            style: kAppLblLargeFontMedium(context),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodPriceChangedEvent(price: value)),
                            textInputAction: TextInputAction.next,
                          ),
                          kAppSpacerVertical(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _foodDiscountController,
                                  decoration: kAppInputDecoration(context, lblText: translate.form_discount),
                                  style: kAppLblLargeFontMedium(context),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodDiscountChangedEvent(discount: value)),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  key: UniqueKey(),
                                  decoration: kAppInputDecoration(context, lblText: translate.form_discount_type),
                                  style: kAppLblSmallFontMedium(context),
                                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                                  initialValue: state.discountType,
                                  items: discountTypeList.map((DiscountTypeInterfaceModel state) {
                                    return DropdownMenuItem<String>(value: state.type, child: Text(kAppDiscountType(context, state.label!)));
                                  }).toList(),
                                  onChanged: (String? value) => context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodDiscountTypeChangedEvent(value: value!)),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              kAppSpacerVertical(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodTaxationToggleEvent()),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(state.taxationEnable ? Icons.check_box_rounded : Icons.check_box_outline_blank, color: state.taxationEnable ? Theme.of(context).primaryColor : Theme.of(context).canvasColor, size: 18),
                                        kAppSpacerHorizontal(width: 10),
                                        Text(translate.add_taxation, style: kAppLblTinyFontRegular(context)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              kAppSpacerVertical(height: 10),
                            ],
                          ),
                          state.taxationEnable
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    kAppSpacerVertical(height: 20),
                                    TextFormField(
                                      controller: _foodTaxationController,
                                      focusNode: _foodTaxationFocusNode,
                                      readOnly: true,
                                      decoration: kAppInputDecoration(
                                        context,
                                        lblText: translate.form_select_taxation,
                                        suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                                        errText: state.foodTaxIds.displayError != null ? translate.form_required : null,
                                      ),
                                      style: kAppLblSmallFontMedium(context),
                                      keyboardType: TextInputType.text,
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(
                                              MaterialPageRoute(
                                                builder: (BuildContext context) {
                                                  return FoodTaxationChecklistModalScreen(savedTaxation: state.foodTaxIds.value);
                                                },
                                                fullscreenDialog: true,
                                              ),
                                            )
                                            .then((value) {
                                              if (!context.mounted) return;
                                              FoodTaxationModalResponseModel taxationResponse = FoodTaxationModalResponseModel.fromJson(value);
                                              if (taxationResponse.action!) {
                                                _foodTaxationController.text = taxationResponse.names!.join(',');
                                                context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodTaxationModalResponseEvent(ids: taxationResponse.ids!.join(','), names: taxationResponse.names!.join(',')));
                                              }
                                            });
                                      },
                                    ),
                                    kAppSpacerVertical(height: 20),
                                  ],
                                )
                              : const SizedBox(),
                          widget.customCategory == true
                              ? Column(
                                  children: [
                                    kAppSpacerVertical(height: 20),
                                    DropdownButtonFormField<bool>(
                                      key: UniqueKey(),
                                      decoration: kAppInputDecoration(context, lblText: translate.form_choose_custom_category),
                                      style: kAppLblSmallFontMedium(context),
                                      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                                      initialValue: state.ownCategory,
                                      items: customCategoryDropdownList.map((CustomCategoryDropdownInterfaceModel state) {
                                        return DropdownMenuItem<bool>(value: state.value, child: Text(kAppCategoryName(context, state.label!)));
                                      }).toList(),
                                      onChanged: (bool? value) {
                                        _foodCategoryController.text = '';
                                        _foodSubCategoryController.text = '';
                                        context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodOwnCategoryChangedEvent(value: value!));
                                      },
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          kAppSpacerVertical(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  focusNode: _foodCategoryFocusNode,
                                  controller: _foodCategoryController,
                                  readOnly: true,
                                  decoration: kAppInputDecoration(
                                    context,
                                    lblText: translate.form_category,
                                    errText: state.category.displayError != null ? translate.form_required : null,
                                    suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                                  ),
                                  style: kAppLblSmallFontMedium(context),
                                  keyboardType: TextInputType.text,
                                  onTap: () {
                                    if (state.ownCategory) {
                                      Navigator.of(context)
                                          .push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return CustomCategoriesModalScreen(categoryId: state.category.value);
                                              },
                                              fullscreenDialog: true,
                                            ),
                                          )
                                          .then((value) {
                                            if (!context.mounted) return;
                                            CategoryModalResponseModel categoryResponse = CategoryModalResponseModel.fromJson(value);
                                            if (categoryResponse.action!) {
                                              _foodCategoryController.text = categoryResponse.name!;
                                              _foodSubCategoryController.text = '';
                                              context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodCategoryModalResponseEvent(id: categoryResponse.id!, name: categoryResponse.name!));
                                            }
                                          });
                                    } else {
                                      Navigator.of(context)
                                          .push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return MainCategoriesModalScreen(categoryId: state.category.value);
                                              },
                                              fullscreenDialog: true,
                                            ),
                                          )
                                          .then((value) {
                                            if (!context.mounted) return;
                                            CategoryModalResponseModel categoryResponse = CategoryModalResponseModel.fromJson(value);
                                            if (categoryResponse.action!) {
                                              _foodCategoryController.text = categoryResponse.name!;
                                              _foodSubCategoryController.text = '';
                                              context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodCategoryModalResponseEvent(id: categoryResponse.id!, name: categoryResponse.name!));
                                            }
                                          });
                                    }
                                  },
                                ),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _foodSubCategoryController,
                                  enabled: state.category.value.isNotEmpty ? true : false,
                                  readOnly: true,
                                  decoration: kAppInputDecoration(context, lblText: translate.form_sub_category, suffixIcon: const Icon(Icons.arrow_drop_down_rounded)),
                                  style: kAppLblSmallFontMedium(context),
                                  keyboardType: TextInputType.text,
                                  onTap: () {
                                    if (state.ownCategory) {
                                      Navigator.of(context)
                                          .push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return CustomSubCategoriesModalScreen(categoryId: state.category.value, subCategoryId: state.subCategory, vendorId: state.restaurant);
                                              },
                                              fullscreenDialog: true,
                                            ),
                                          )
                                          .then((value) {
                                            if (!context.mounted) return;
                                            CategoryModalResponseModel categoryResponse = CategoryModalResponseModel.fromJson(value);
                                            if (categoryResponse.action!) {
                                              CategoryModalResponseModel categoryResponse = CategoryModalResponseModel.fromJson(value);
                                              if (categoryResponse.action!) {
                                                _foodSubCategoryController.text = categoryResponse.name!;
                                                context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodSubCategoryModalResponseEvent(id: categoryResponse.id!, name: categoryResponse.name!));
                                              }
                                            }
                                          });
                                    } else {
                                      Navigator.of(context)
                                          .push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return MainSubCategoriesModalScreen(mainCategoryId: state.category.value, subCategoryId: state.subCategory);
                                              },
                                              fullscreenDialog: true,
                                            ),
                                          )
                                          .then((value) {
                                            if (!context.mounted) return;
                                            CategoryModalResponseModel categoryResponse = CategoryModalResponseModel.fromJson(value);
                                            if (categoryResponse.action!) {
                                              _foodSubCategoryController.text = categoryResponse.name!;
                                              context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodSubCategoryModalResponseEvent(id: categoryResponse.id!, name: categoryResponse.name!));
                                            }
                                          });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          kAppSpacerVertical(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _foodPurchaseLimitController,
                                  decoration: kAppInputDecoration(context, lblText: translate.form_max_purchase_limit),
                                  style: kAppLblLargeFontMedium(context),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodPurchaseLimitChangedEvent(limit: value)),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  key: UniqueKey(),
                                  decoration: kAppInputDecoration(context, lblText: translate.form_food_pref),
                                  style: kAppLblSmallFontMedium(context),
                                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                                  initialValue: state.foodType,
                                  items: foodPrefList.map((FoodPreferencesInterfaceModel state) {
                                    return DropdownMenuItem<String>(value: state.type, child: Text(kAppFoodPrefName(context, state.label!)));
                                  }).toList(),
                                  onChanged: (String? value) => context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodPreferencesChangeEvent(value: value!)),
                                ),
                              ),
                            ],
                          ),
                          kAppSpacerVertical(height: 20),
                          TextFormField(
                            controller: _foodAddonsController,
                            readOnly: true,
                            decoration: kAppInputDecoration(context, lblText: translate.form_select_addon, suffixIcon: const Icon(Icons.arrow_drop_down_rounded)),
                            style: kAppLblSmallFontMedium(context),
                            keyboardType: TextInputType.text,
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return AddonsCheckListModalScreen(vendorId: state.restaurant, savedAddons: state.addons.isNotEmpty && state.addons != '' ? state.addons.split(',') : []);
                                      },
                                      fullscreenDialog: true,
                                    ),
                                  )
                                  .then((value) {
                                    if (!context.mounted) return;
                                    AddonsModalResponseModel addonsResponse = AddonsModalResponseModel.fromJson(value);
                                    if (addonsResponse.action!) {
                                      _foodAddonsController.text = addonsResponse.names!.join(',');
                                      context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodAddonsModalResponseEvent(ids: addonsResponse.ids!.join(','), names: addonsResponse.names!.join(',')));
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
                              Expanded(
                                child: TextFormField(
                                  controller: _foodStartTimeController,
                                  decoration: kAppInputDecoration(context, lblText: translate.form_available_start_time),
                                  style: kAppLblLargeFontMedium(context),
                                  readOnly: false,
                                  keyboardType: TextInputType.number,
                                  onTap: () async {
                                    await showTimePicker(
                                      context: context,
                                      initialEntryMode: entryMode,
                                      initialTime: startTimePicker ?? TimeOfDay.now(),
                                      cancelText: translate.cancel_lbl,
                                      confirmText: translate.ok_lbl,
                                      hourLabelText: translate.hour_lbl,
                                      minuteLabelText: translate.minute_lbl,
                                      helpText: translate.select_availability_start_time,
                                    ).then((value) {
                                      if (!context.mounted) return;
                                      if (value != null) {
                                        String convertTo12Hour(String time24, locale) {
                                          final date = DateFormat('HH:mm', locale).parse(time24);
                                          return DateFormat('hh:mm a', locale).format(date);
                                        }

                                        _foodStartTimeController.text = convertTo12Hour('${value.hour}:${value.minute}', state.locale);
                                        context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodAvailabilityStartTimeChangedEvent(value: '${value.hour}:${value.minute}'));
                                        setState(() {
                                          startTimePicker = value;
                                        });
                                      }
                                    });
                                  },
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _foodEndTimeController,
                                  decoration: kAppInputDecoration(context, lblText: translate.form_available_end_time),
                                  style: kAppLblLargeFontMedium(context),
                                  readOnly: false,
                                  keyboardType: TextInputType.number,
                                  onTap: () async {
                                    await showTimePicker(
                                      context: context,
                                      initialEntryMode: entryMode,
                                      initialTime: endTimePicker ?? TimeOfDay.now(),
                                      cancelText: translate.cancel_lbl,
                                      confirmText: translate.ok_lbl,
                                      hourLabelText: translate.hour_lbl,
                                      minuteLabelText: translate.minute_lbl,
                                      helpText: translate.select_availability_end_time,
                                    ).then((value) {
                                      if (!context.mounted) return;
                                      if (value != null) {
                                        String convertTo12Hour(String time24, locale) {
                                          final date = DateFormat('HH:mm', locale).parse(time24);
                                          return DateFormat('hh:mm a', locale).format(date);
                                        }

                                        _foodEndTimeController.text = convertTo12Hour('${value.hour}:${value.minute}', state.locale);

                                        context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodAvailabilityEndTimeChangedEvent(value: '${value.hour}:${value.minute}'));
                                        setState(() {
                                          endTimePicker = value;
                                        });
                                      }
                                    });
                                  },
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                          kAppSpacerVertical(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  enabled: state.stockType != 'unlimited',
                                  controller: _foodStockNumberController,
                                  focusNode: _foodStockNumberFocusNode,
                                  decoration: kAppInputDecoration(context, lblText: translate.form_item_stock, errText: state.stockNumber.displayError != null ? translate.form_required : null),
                                  style: kAppLblLargeFontMedium(context),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodStockNumberChangedEvent(value: value)),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              kAppSpacerHorizontal(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  key: UniqueKey(),
                                  decoration: kAppInputDecoration(context, lblText: translate.form_stock_type),
                                  style: kAppLblSmallFontMedium(context),
                                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                                  initialValue: state.stockType,
                                  items: stockTypeList.map((StockTypeModel state) {
                                    return DropdownMenuItem<String>(value: state.value, child: Text(kAppStockType(context, state.label!)));
                                  }).toList(),
                                  onChanged: (String? value) {
                                    if (value! == 'unlimited') {
                                      _foodStockNumberController.text = '-1';
                                    } else {
                                      _foodStockNumberController.text = '';
                                    }
                                    context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodStockChangeEvent(type: value));
                                  },
                                ),
                              ),
                            ],
                          ),
                          kAppSpacerVertical(height: 20),
                          TextFormField(
                            controller: _foodTagsController,
                            decoration: kAppInputDecoration(context, lblText: translate.form_add_tags),
                            style: kAppLblSmallFontMedium(context),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (String value) {
                              if (value.contains(',')) {
                                var commaList = value.split(',');
                                for (var element in commaList) {
                                  if (!tagsList.contains(element)) {
                                    setState(() {
                                      tagsList.add(element);
                                    });
                                  }
                                }
                              } else if (!tagsList.contains(value)) {
                                setState(() {
                                  tagsList.add(value);
                                });
                              }
                              _foodTagsController.text = '';
                            },
                          ),
                          tagsList.isNotEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: List.generate(
                                          tagsList.length,
                                          (index) => Container(
                                            margin: const EdgeInsets.only(right: 3),
                                            child: InputChip(
                                              key: ObjectKey(tagsList[index]),
                                              label: Text(tagsList[index]),
                                              onDeleted: () {
                                                setState(() {
                                                  tagsList.removeAt(index);
                                                });
                                              },
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              padding: const EdgeInsets.all(2),
                                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                              deleteIconColor: Theme.of(context).canvasColor,
                                              labelStyle: kAppLblSmallFontMedium(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          kAppSpacerVertical(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(translate.food_variation, style: kAppLblMediumFontMedium(context)),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return VariationModalScreen(isNew: true, model: FoodVariationModel(), stockType: state.stockType);
                                          },
                                          fullscreenDialog: true,
                                        ),
                                      )
                                      .then((value) {
                                        if (!context.mounted) return;
                                        FoodVariationModalResponseModel variationResponse = FoodVariationModalResponseModel.fromJson(value);
                                        if (variationResponse.action!) {
                                          context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodVariationChangedEvent(isNew: true, index: 0, model: variationResponse.data!));
                                        }
                                      });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(translate.add_new_variation, style: kAppLblMediumFontMedium(context, color: 'primary')),
                                    Icon(Icons.add, color: Theme.of(context).primaryColor, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          kAppSpacerVertical(height: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(state.variations.length, (index) => VariationListTile(results: state.variations[index], index: index, stockType: state.stockType)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TabBar(
                                controller: foodTranslationTabController,
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
                            height: 220,
                            child: TabBarView(
                              controller: foodTranslationTabController,
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
                                        textInputAction: TextInputAction.next,
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
                        ],
                      ),
              ),
            ),
            bottomNavigationBar: state.status.isLoading
                ? SafeArea(child: const SizedBox())
                : SafeArea(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ManageFoodActionBloc>().add(
                            widget.isNew ? ManageFoodActionFoodCreateFormEvent(translations: translations, tags: tagsList) : ManageFoodActionFoodUpdateFormEvent(translations: translations, tags: tagsList),
                          );
                        },
                        style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                        child: state.status.isInProgress ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.submit_lbl),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class VariationListTile extends StatelessWidget {
  final FoodVariationModel results;
  final int index;
  final String stockType;
  const VariationListTile({super.key, required this.results, required this.index, required this.stockType});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: ThemeProvider.greyColorBorder, width: 1),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${translate.form_required} : ${results.isRequired}', style: kAppLblSmallFontMedium(context)),
                  kAppSpacerHorizontal(width: 10),
                  Text("${translate.type} : ${results.type == 'single' ? translate.single_selection : translate.multi_selection}", style: kAppLblSmallFontMedium(context)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return VariationModalScreen(isNew: false, model: results, stockType: stockType);
                              },
                              fullscreenDialog: true,
                            ),
                          )
                          .then((value) {
                            if (!context.mounted) return;
                            FoodVariationModalResponseModel variationResponse = FoodVariationModalResponseModel.fromJson(value);
                            if (variationResponse.action!) {
                              context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodVariationChangedEvent(isNew: false, index: index, model: variationResponse.data!));
                            }
                          });
                    },
                    child: FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelLarge?.fontSize),
                  ),
                  kAppSpacerHorizontal(width: 20),
                  InkWell(
                    onTap: () => context.read<ManageFoodActionBloc>().add(ManageFoodActionFoodVariationDeleteEvent(index: index)),
                    child: FaIcon(FontAwesomeIcons.trashCan, size: Theme.of(context).textTheme.labelLarge?.fontSize),
                  ),
                ],
              ),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Text('${translate.form_title} : ${results.title}', style: kAppLblSmallFontMedium(context)),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${translate.min_qty} : ${results.min}', style: kAppLblSmallFontMedium(context)),
              kAppSpacerHorizontal(width: 10),
              Text('${translate.max_qty} : ${results.max}', style: kAppLblSmallFontMedium(context)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).colorScheme.secondary),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: Theme.of(context).primaryColor, size: Theme.of(context).textTheme.labelSmall?.fontSize),
                  kAppSpacerHorizontal(width: 10),
                  Text(translate.options, style: kAppLblSmallFontBold(context)),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(results.options!.length, (optionIndex) => VariationOptionListTile(results: results.options![optionIndex], stockType: stockType)),
          ),
        ],
      ),
    );
  }
}

class VariationOptionListTile extends StatelessWidget {
  final FoodVariationOptionModel results;
  final String stockType;
  const VariationOptionListTile({super.key, required this.results, required this.stockType});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${results.name} ${stockType != 'unlimited' ? '(${results.stock})' : ''}', style: kAppLblSmallFontMedium(context)),
          Text(
            GlobalSettings.globalCurrencySide == 'left' ? '${translate.form_price} : ${GlobalSettings.globalCurrencySymbol}${results.price!}' : '${translate.form_price} : ${results.price!}${GlobalSettings.globalCurrencySymbol}',
            style: kAppLblSmallFontMedium(context),
          ),
        ],
      ),
    );
  }
}
