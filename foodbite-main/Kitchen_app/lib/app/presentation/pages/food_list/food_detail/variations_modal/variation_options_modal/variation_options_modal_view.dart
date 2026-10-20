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
import 'package:kitchen/app/core/models/food_variation_options_model.dart';
import 'package:kitchen/app/presentation/pages/food_list/food_detail/variations_modal/variation_options_modal/bloc/variation_options_modal_bloc.dart';
import 'package:kitchen/app/presentation/styles/app_style.dart';
import 'package:kitchen/app/presentation/styles/theme.dart';
import 'package:kitchen/gen/l10n/app_localizations.dart';

class VariationOptionsModalScreen extends StatelessWidget {
  final bool isNew;
  final FoodVariationOptionModel model;
  final String stockType;
  const VariationOptionsModalScreen({super.key, required this.isNew, required this.model, required this.stockType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VariationOptionsModalBloc()..add(VariationOptionsModalInitialEvent(isNew: isNew, model: model, stockType: stockType)),
      child: VariationOptionsModalView(isNew: isNew, model: model, stockType: stockType),
    );
  }
}

class VariationOptionsModalView extends StatefulWidget {
  final bool isNew;
  final FoodVariationOptionModel model;
  final String stockType;
  const VariationOptionsModalView({super.key, required this.isNew, required this.model, required this.stockType});

  @override
  State<VariationOptionsModalView> createState() => _VariationOptionsModalViewState();
}

class _VariationOptionsModalViewState extends State<VariationOptionsModalView> {
  final TextEditingController _optionNameController = TextEditingController();
  final TextEditingController _optionPriceController = TextEditingController();
  final TextEditingController _optionStockController = TextEditingController();

  final _optionNameFocusNode = FocusNode();
  final _optionPriceFocusNode = FocusNode();
  final _optionStockFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (!widget.isNew) {
      _optionNameController.text = widget.model.name!;
      _optionPriceController.text = widget.model.price!;
      _optionStockController.text = widget.model.stock!;
    }
    _optionNameFocusNode.addListener(() {
      if (!_optionNameFocusNode.hasFocus) {
        context.read<VariationOptionsModalBloc>().add(VariationOptionNameUnfocused());
      }
    });

    _optionPriceFocusNode.addListener(() {
      if (!_optionPriceFocusNode.hasFocus) {
        context.read<VariationOptionsModalBloc>().add(VariationOptionPriceUnfocused());
      }
    });

    _optionStockFocusNode.addListener(() {
      if (!_optionStockFocusNode.hasFocus) {
        context.read<VariationOptionsModalBloc>().add(VariationOptionStockUnfocused());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _optionNameController.dispose();
    _optionPriceController.dispose();
    _optionStockController.dispose();

    _optionNameFocusNode.dispose();
    _optionPriceFocusNode.dispose();
    _optionStockFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<VariationOptionsModalBloc, VariationOptionsModalState>(
      listener: (context, state) {
        if (state.status.isSelected) {
          Navigator.of(context).pop({'action': true, 'name': state.name.value, 'price': state.price.value, 'stock': state.stock.value});
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(widget.isNew ? translate.add_option : translate.update_option),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop({'action': false, 'name': '', 'price': ''}),
                icon: Icon(Icons.close_outlined, color: Theme.of(context).iconTheme.color),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.read<VariationOptionsModalBloc>().add(VariationOptionFormSubmit()),
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                          child: Text(translate.save),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    focusNode: _optionNameFocusNode,
                    controller: _optionNameController,
                    decoration: kAppInputDecoration(context, lblText: translate.form_option_name, errText: state.name.displayError != null ? translate.form_required : null),
                    style: kAppLblLargeFontMedium(context),
                    keyboardType: TextInputType.text,
                    onChanged: (value) => context.read<VariationOptionsModalBloc>().add(VariationOptionNameChanged(name: value)),
                    textInputAction: TextInputAction.next,
                  ),
                  kAppSpacerVertical(height: 20),
                  TextFormField(
                    focusNode: _optionPriceFocusNode,
                    controller: _optionPriceController,
                    decoration: kAppInputDecoration(context, lblText: translate.form_option_price, errText: state.price.displayError != null ? translate.form_required : null),
                    style: kAppLblLargeFontMedium(context),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => context.read<VariationOptionsModalBloc>().add(VariationOptionPriceChanged(price: value)),
                    textInputAction: TextInputAction.done,
                  ),
                  state.stockType != 'unlimited'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kAppSpacerVertical(height: 20),
                            TextFormField(
                              focusNode: _optionStockFocusNode,
                              controller: _optionStockController,
                              decoration: kAppInputDecoration(context, lblText: translate.form_option_stock, errText: state.stock.displayError != null ? translate.form_required : null),
                              style: kAppLblLargeFontMedium(context),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => context.read<VariationOptionsModalBloc>().add(VariationOptionStockChanged(stock: value)),
                              textInputAction: TextInputAction.done,
                            ),
                            kAppSpacerVertical(height: 20),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
// DONE //