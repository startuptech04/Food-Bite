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
import 'package:vendor/app/core/models/translations/food_taxation_form_translation.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/app/presentation/pages/account/food_taxation/food_taxation_dialog/bloc/food_taxation_dialog_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class FoodTaxationDialogScreen extends StatelessWidget {
  final bool isNew;
  final String taxId;
  final String name;
  final double amount;
  final List<FoodTaxationFormTranslations> transalation;
  const FoodTaxationDialogScreen({super.key, required this.isNew, required this.taxId, required this.name, required this.amount, required this.transalation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodTaxationDialogBloc()..add(FoodTaxationDialogInitialEvent(isNew: isNew, taxId: taxId, name: name, amount: amount)),
      child: FoodTaxationDialogView(isNew: isNew, name: name, amount: amount, transalation: transalation),
    );
  }
}

class FoodTaxationDialogView extends StatefulWidget {
  final bool isNew;
  final String name;
  final double amount;
  final List<FoodTaxationFormTranslations> transalation;
  const FoodTaxationDialogView({super.key, required this.isNew, required this.name, required this.amount, required this.transalation});

  @override
  State<FoodTaxationDialogView> createState() => _FoodTaxationDialogViewState();
}

class _FoodTaxationDialogViewState extends State<FoodTaxationDialogView> with TickerProviderStateMixin {
  late TabController foodTaxationTranslationTabController;
  List<FoodTaxationFormTranslations> translations = <FoodTaxationFormTranslations>[];
  final TextEditingController _foodTaxationNameController = TextEditingController();
  final TextEditingController _foodTaxationAmountController = TextEditingController();

  final _foodTaxationNameFocusNode = FocusNode();
  final _foodTaxationAmountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (AppSupportedLanguagesModel.languages.length > 1) {
      for (var element in AppSupportedLanguagesModel.languages) {
        FoodTaxationFormTranslations keys = FoodTaxationFormTranslations(name: element.value, code: element.code, nativeName: element.value, title: '');
        translations.add(keys);
      }
    }
    foodTaxationTranslationTabController = TabController(initialIndex: 0, length: translations.length, vsync: this);
    setState(() {
      for (var firstTranslation in translations) {
        for (var secondTranslation in widget.transalation) {
          if (firstTranslation.code == secondTranslation.code) {
            firstTranslation.title = secondTranslation.title;
          }
        }
      }
    });
    _foodTaxationNameFocusNode.addListener(() {
      if (!_foodTaxationNameFocusNode.hasFocus) {
        context.read<FoodTaxationDialogBloc>().add(FoodTaxationDialogNameUnfocusedEvent());
      }
    });

    _foodTaxationAmountFocusNode.addListener(() {
      if (!_foodTaxationAmountFocusNode.hasFocus) {
        context.read<FoodTaxationDialogBloc>().add(FoodTaxationDialogPriceUnfocusedEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((FoodTaxationDialogBloc bloc) => bloc.state.isValid);
    return BlocConsumer<FoodTaxationDialogBloc, FoodTaxationDialogState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isLoaded) {
          _foodTaxationNameController.text = widget.name;
          _foodTaxationAmountController.text = widget.amount.toString();
        } else if (state.status.isSuccess) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isInProgress ? true : false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              title: Text(widget.isNew ? translate.add_taxation : translate.update_taxation),
              actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    focusNode: _foodTaxationNameFocusNode,
                    controller: _foodTaxationNameController,
                    decoration: kAppInputDecoration(context, lblText: translate.form_name, errText: state.name.displayError != null ? translate.form_required : null),
                    style: kAppLblLargeFontMedium(context),
                    keyboardType: TextInputType.text,
                    onChanged: (value) => context.read<FoodTaxationDialogBloc>().add(FoodTaxationDialogNameChangedEvent(name: value)),
                    textInputAction: TextInputAction.next,
                  ),
                  kAppSpacerVertical(height: 20),
                  TextFormField(
                    focusNode: _foodTaxationAmountFocusNode,
                    controller: _foodTaxationAmountController,
                    decoration: kAppInputDecoration(context, lblText: translate.form_tax_amount, errText: state.amount.displayError != null ? translate.form_required : null),
                    style: kAppLblLargeFontMedium(context),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => context.read<FoodTaxationDialogBloc>().add(FoodTaxationDialogPriceChangedEvent(amount: value)),
                    textInputAction: TextInputAction.next,
                  ),
                  kAppSpacerVertical(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TabBar(
                        controller: foodTaxationTranslationTabController,
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
                      controller: foodTaxationTranslationTabController,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isValid ? () => context.read<FoodTaxationDialogBloc>().add(FoodTaxationDialogSubmitEvent(translations: translations)) : null,
                  style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                  child: state.status.isInProgress
                      ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0)
                      : Text(widget.isNew ? translate.save_taxation : translate.update_taxation),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
// DONE //