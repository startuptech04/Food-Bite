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
import 'package:formz/formz.dart';
import 'package:vendor/app/core/models/addons_list_model.dart';
import 'package:vendor/app/core/models/translations/addons_form_translation.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';
import 'package:vendor/app/presentation/pages/menu/addons/action/bloc/addon_action_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';

class AddonActionScreen extends StatelessWidget {
  final bool isNew;
  final AddonResultModel model;
  const AddonActionScreen({super.key, required this.isNew, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddonActionBloc(),
      child: AddonActionView(isNew: isNew, model: model),
    );
  }
}

class AddonActionView extends StatefulWidget {
  final bool isNew;
  final AddonResultModel model;
  const AddonActionView({super.key, required this.isNew, required this.model});

  @override
  State<AddonActionView> createState() => _AddonActionViewState();
}

class _AddonActionViewState extends State<AddonActionView> with TickerProviderStateMixin {
  final TextEditingController _addonNameController = TextEditingController();
  final TextEditingController _addonPriceController = TextEditingController();
  final TextEditingController _addonStockNumberController = TextEditingController();

  List<AddonsFormTranslations> translations = <AddonsFormTranslations>[];
  final List<StockTypeModel> stockTypeList = <StockTypeModel>[];

  late TabController addonTranslationTabController;

  final _addonNameFocusNode = FocusNode();
  final _addonPriceFocusNode = FocusNode();
  final _addonStockNumberFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    if (AppSupportedLanguagesModel.languages.length > 1) {
      for (var element in AppSupportedLanguagesModel.languages) {
        AddonsFormTranslations keys = AddonsFormTranslations(name: element.value, code: element.code, nativeName: element.value, value: '');
        translations.add(keys);
      }
    }

    context.read<AddonActionBloc>().add(AddonActionInitialEvent(isNew: widget.isNew, model: widget.model));

    _addonNameFocusNode.addListener(() {
      if (!_addonNameFocusNode.hasFocus) {
        context.read<AddonActionBloc>().add(AddonActionNameUnfocused());
      }
    });

    _addonPriceFocusNode.addListener(() {
      if (!_addonPriceFocusNode.hasFocus) {
        context.read<AddonActionBloc>().add(AddonActionPriceUnfocused());
      }
    });

    _addonStockNumberFocusNode.addListener(() {
      if (!_addonStockNumberFocusNode.hasFocus) {
        context.read<AddonActionBloc>().add(AddonActionStockNumberUnfocused());
      }
    });

    if (widget.isNew) {
      _addonNameController.text = '';
      _addonPriceController.text = '';
      _addonStockNumberController.text = '-1';
    } else {
      _addonNameController.text = widget.model.realName!;
      _addonPriceController.text = '${widget.model.price!}';
      _addonStockNumberController.text = '${widget.model.stockNumber!}';
      for (var locale in translations) {
        for (var translate in widget.model.translations!) {
          if (locale.code == translate.code) {
            locale.value = translate.value;
          }
        }
      }
    }
    addonTranslationTabController = TabController(initialIndex: 0, length: translations.length, vsync: this);

    StockTypeModel unlimitedStock = StockTypeModel(label: 'unlimited_stock', value: 'unlimited');
    StockTypeModel limitedStock = StockTypeModel(label: 'limited_stock', value: 'limited');
    StockTypeModel dailyStock = StockTypeModel(label: 'daily_limit', value: 'daily');
    stockTypeList.clear();
    stockTypeList.add(unlimitedStock);
    stockTypeList.add(limitedStock);
    stockTypeList.add(dailyStock);
  }

  @override
  void dispose() {
    super.dispose();
    _addonNameController.dispose();
    _addonPriceController.dispose();
    _addonStockNumberController.dispose();

    _addonNameFocusNode.dispose();
    _addonPriceFocusNode.dispose();
    _addonStockNumberFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<AddonActionBloc, AddonActionState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSuccess) {
          showSuccessDialog(context, widget.isNew ? translate.addon_action_new_toast : translate.addon_action_edit_toast).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isInProgress ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(widget.isNew ? translate.addon_action_new_title : translate.addon_action_edit_title), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      focusNode: _addonNameFocusNode,
                      controller: _addonNameController,
                      decoration: kAppInputDecoration(context, lblText: translate.addon_txt_name, errText: state.name.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<AddonActionBloc>().add(AddonActionNameChanged(name: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      focusNode: _addonPriceFocusNode,
                      controller: _addonPriceController,
                      decoration: kAppInputDecoration(context, lblText: kAppPriceLbl(translate.addon_txt_price), errText: state.price.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => context.read<AddonActionBloc>().add(AddonActionPriceChanged(price: value)),
                      textInputAction: TextInputAction.done,
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
                            controller: _addonStockNumberController,
                            focusNode: _addonStockNumberFocusNode,
                            decoration: kAppInputDecoration(context, lblText: translate.form_item_stock, errText: state.stockNumber.displayError != null ? translate.form_required : null),
                            style: kAppLblLargeFontMedium(context),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => context.read<AddonActionBloc>().add(AddonActionStockNumberChangedEvent(value: value)),
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
                                _addonStockNumberController.text = '-1';
                              } else {
                                _addonStockNumberController.text = '';
                              }
                              context.read<AddonActionBloc>().add(AddonActionStockChangeEvent(type: value));
                            },
                          ),
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          controller: addonTranslationTabController,
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
                      height: 80,
                      child: TabBarView(
                        controller: addonTranslationTabController,
                        children: List.generate(
                          translations.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              initialValue: translations[index].value,
                              decoration: kAppInputDecoration(context, lblText: "${translate.form_name} ${translations[index].nativeName}"),
                              style: kAppLblLargeFontMedium(context),
                              onChanged: (value) {
                                setState(() {
                                  translations[index].value = value;
                                });
                              },
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.read<AddonActionBloc>().add(
                    widget.isNew ? AddonActionFormCreateSubmitted(translations: translations) : AddonActionFormUpdateSubmitted(id: widget.model.id!, model: widget.model, translations: translations),
                  ),
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
