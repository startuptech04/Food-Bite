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
import 'package:vendor/app/core/models/pos_food_in_cart_model.dart';
import 'package:vendor/app/presentation/pages/modals/food_variations_modal/repeat/bloc/food_variation_modal_repeat_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class FoodVariationModalRepeatScreen extends StatelessWidget {
  final String id;
  final bool action;
  const FoodVariationModalRepeatScreen({super.key, required this.id, required this.action});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodVariationModalRepeatBloc()..add(FoodVariationModalRepeatInitialEvent(id: id)),
      child: FoodVariationModalRepeatView(id: id, action: action),
    );
  }
}

class FoodVariationModalRepeatView extends StatelessWidget {
  final String id;
  final bool action;
  const FoodVariationModalRepeatView({super.key, required this.id, required this.action});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<FoodVariationModalRepeatBloc, FoodVariationModalRepeatState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSuccessClose) {
          Navigator.of(context).pop({"action": "update", "data": state.quantityList.toJson()});
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(translate.repeat_customization),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop({"action": "update", "data": state.quantityList.toJson()}),
                icon: Icon(Icons.check_outlined, color: Theme.of(context).primaryColor),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop({"action": "close", "data": state.quantityList.toJson()}),
                icon: Icon(Icons.close, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          bottomNavigationBar: action
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                    child: TextButton.icon(
                      onPressed: () => Navigator.of(context).pop({"action": "new", "data": state.quantityList.toJson()}),
                      icon: Icon(Icons.add, size: Theme.of(context).textTheme.labelSmall?.fontSize, color: Theme.of(context).primaryColor),
                      label: Text(translate.add_new_customization, style: kAppLblSmallFontMedium(context, color: 'primary')),
                    ),
                  ),
                )
              : SafeArea(child: const SizedBox()),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
            child: state.status.isLoading
                ? kAppCenterCircularProgress(context)
                : Column(
                    children: List.generate(state.list.length, (index) => state.list[index].quantity! >= 1 ? FoodItemBlock(model: state.list[index], index: index) : const SizedBox()),
                  ),
          ),
        );
      },
    );
  }
}

class FoodItemBlock extends StatelessWidget {
  final PosFoodInCartModel model;
  final int index;
  const FoodItemBlock({super.key, required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kAppTrimWord(model.name!, 50), style: kAppLblMediumFontBold(context)),
                kAppSpacerVertical(height: 5),
                Text(kAppPriceFormat(model.totalPrice!), style: kAppLblTinyMediumFontSemi(context)),
                kAppSpacerVertical(height: 5),
                Container(
                  padding: const EdgeInsets.only(right: 5),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.8, minWidth: MediaQuery.of(context).size.width / 2.5),
                  child: Text(model.optionName!, maxLines: 4, style: kAppLblTinyFontRegular(context)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: () => context.read<FoodVariationModalRepeatBloc>().add(FoodVariationModalRepeatDecreaseEvent(index: index, uuid: model.uuid!)),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15, left: 5),
                          child: Icon(Icons.remove, size: 18, color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Text('${model.quantity}', style: kAppLblSmallFontBold(context, color: 'primary')),
                      InkWell(
                        onTap: () => context.read<FoodVariationModalRepeatBloc>().add(FoodVariationModalRepeatIncreaseEvent(index: index, uuid: model.uuid!)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 5),
                          child: Icon(Icons.add, size: 18, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                kAppSpacerVertical(height: 5),
                Text(kAppPriceFormat(model.totalPrice!), style: kAppLblTinyMediumFontSemi(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// DONE //