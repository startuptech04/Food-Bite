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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kitchen/app/core/config/global_settings.dart';
import 'package:kitchen/app/core/models/addons_modal_response_model.dart';
import 'package:kitchen/app/core/models/food_variation_modal_response_model.dart';
import 'package:kitchen/app/core/models/food_variation_model.dart';
import 'package:kitchen/app/core/models/food_variation_options_model.dart';
import 'package:kitchen/app/presentation/pages/food_list/food_detail/@core/bloc/food_detail_bloc.dart';
import 'package:kitchen/app/presentation/pages/food_list/food_detail/variations_modal/@core/variations_modal_view.dart';
import 'package:kitchen/app/presentation/pages/modals/addons_checklist/addons_checklist_modal_view.dart';
import 'package:kitchen/app/presentation/styles/app_style.dart';
import 'package:kitchen/app/presentation/styles/error_dialog.dart';
import 'package:kitchen/app/presentation/styles/success_dialog.dart';
import 'package:kitchen/app/presentation/styles/theme.dart';
import 'package:kitchen/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:kitchen/gen/l10n/app_localizations.dart';

class FoodDetailScreen extends StatelessWidget {
  final String id;
  const FoodDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodDetailBloc()..add(FoodDetailInitialEvent(id: id)),
      child: const FoodDetailView(),
    );
  }
}

class FoodDetailView extends StatefulWidget {
  const FoodDetailView({super.key});

  @override
  State<FoodDetailView> createState() => _FoodDetailViewState();
}

class _FoodDetailViewState extends State<FoodDetailView> {
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _foodDescriptionController = TextEditingController();
  final TextEditingController _foodAddonsController = TextEditingController();
  final TextEditingController _foodStockNumberController = TextEditingController();

  final _foodStockNumberFocusNode = FocusNode();

  final List<StockTypeModel> stockTypeList = <StockTypeModel>[];

  @override
  void initState() {
    super.initState();
    StockTypeModel unlimitedStock = StockTypeModel(label: 'dd_unlimited_stock', value: 'unlimited');
    StockTypeModel limitedStock = StockTypeModel(label: 'dd_limited_stock', value: 'limited');
    StockTypeModel dailyStock = StockTypeModel(label: 'dd_daily_limit', value: 'daily');
    stockTypeList.clear();
    stockTypeList.add(unlimitedStock);
    stockTypeList.add(limitedStock);
    stockTypeList.add(dailyStock);

    _foodStockNumberFocusNode.addListener(() {
      if (!_foodStockNumberFocusNode.hasFocus) {}
    });
  }

  @override
  void dispose() {
    super.dispose();
    _foodNameController.dispose();
    _foodDescriptionController.dispose();
    _foodAddonsController.dispose();
    _foodStockNumberController.dispose();

    _foodStockNumberFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<FoodDetailBloc, FoodDetailState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSuccess) {
          showSuccessDialog(context, translate.food_updated).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        } else if (state.status.isLoaded) {
          _foodNameController.text = state.model.detail!.name!;
          _foodDescriptionController.text = state.model.detail!.shortDescription!;
          _foodAddonsController.text = state.addonsName;
          _foodStockNumberController.text = '${state.model.detail!.stockNumber!}';
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
              title: Text(translate.update_stock_detail),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_outlined, color: Theme.of(context).iconTheme.color),
                ),
              ],
            ),
            body: SingleChildScrollView(
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
                            Container(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.all(8), // Border width
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: state.image.displayError != null ? ThemeProvider.errorColor : ThemeProvider.greyColorBorder, width: state.image.displayError != null ? 2 : 0),
                                shape: BoxShape.rectangle,
                              ),
                              child: CacheNetworkImageWidget(width: 100, height: 100, imageUrl: state.image.value),
                            ),
                          ],
                        ),
                        kAppSpacerVertical(height: 20),
                        TextFormField(
                          controller: _foodNameController,
                          decoration: kAppInputDecoration(context, lblText: translate.form_name, errText: state.name.displayError != null ? translate.form_required : null),
                          style: kAppLblLargeFontMedium(context),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          readOnly: true,
                        ),
                        kAppSpacerVertical(height: 20),
                        TextFormField(
                          controller: _foodDescriptionController,
                          decoration: kAppInputDecoration(context, lblText: translate.form_short_description, errText: state.shortDescription.displayError != null ? translate.form_required : null),
                          style: kAppLblLargeFontMedium(context),
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          textInputAction: TextInputAction.next,
                          readOnly: true,
                        ),
                        kAppSpacerVertical(height: 20),
                        TextFormField(
                          controller: _foodAddonsController,
                          readOnly: true,
                          decoration: kAppInputDecoration(context, lblText: translate.form_select_addons, suffixIcon: const Icon(Icons.arrow_drop_down_rounded)),
                          style: kAppLblSmallFontMedium(context),
                          keyboardType: TextInputType.text,
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return AddonsCheckListModalScreen(savedAddons: state.addons.isNotEmpty && state.addons != '' ? state.addons.split(',') : []);
                                    },
                                    fullscreenDialog: true,
                                  ),
                                )
                                .then((value) {
                                  if (!context.mounted) return;
                                  AddonsModalResponseModel addonsResponse = AddonsModalResponseModel.fromJson(value);
                                  if (addonsResponse.action!) {
                                    _foodAddonsController.text = addonsResponse.names!.join(',');
                                    context.read<FoodDetailBloc>().add(FoodDetailAddonsModalResponseEvent(ids: addonsResponse.ids!.join(','), names: addonsResponse.names!.join(',')));
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
                                enabled: state.stockType != 'unlimited',
                                controller: _foodStockNumberController,
                                focusNode: _foodStockNumberFocusNode,
                                decoration: kAppInputDecoration(context, lblText: translate.form_item_stock, errText: state.stockNumber.displayError != null ? translate.form_required : null),
                                style: kAppLblLargeFontMedium(context),
                                keyboardType: TextInputType.number,
                                onChanged: (value) => context.read<FoodDetailBloc>().add(FoodDetailStockNumberChangedEvent(value: value)),
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
                                  return DropdownMenuItem<String>(value: state.value, child: Text(kAppDDTranslate(context, state.label!)));
                                }).toList(),
                                onChanged: (String? value) {
                                  if (value! == 'unlimited') {
                                    _foodStockNumberController.text = '-1';
                                  } else {
                                    _foodStockNumberController.text = '';
                                  }
                                  context.read<FoodDetailBloc>().add(FoodDetailStockChangeEvent(type: value));
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
                                        context.read<FoodDetailBloc>().add(FoodDetailVariationChangedEvent(isNew: true, index: 0, model: variationResponse.data!));
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
                      ],
                    ),
            ),
            bottomNavigationBar: state.status.isLoading
                ? SafeArea(child: const SizedBox())
                : SafeArea(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.read<FoodDetailBloc>().add(FoodDetailUpdateFormEvent()),
                        style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                        child: state.status.isInProgress ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.submit),
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
                  Text("${translate.required_field} : ${results.isRequired}", style: kAppLblSmallFontMedium(context)),
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
                              context.read<FoodDetailBloc>().add(FoodDetailVariationChangedEvent(isNew: false, index: index, model: variationResponse.data!));
                            }
                          });
                    },
                    child: FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelLarge?.fontSize),
                  ),
                  kAppSpacerHorizontal(width: 20),
                  InkWell(
                    onTap: () => context.read<FoodDetailBloc>().add(FoodDetailVariationDeleteEvent(index: index)),
                    child: FaIcon(FontAwesomeIcons.trashCan, size: Theme.of(context).textTheme.labelLarge?.fontSize),
                  ),
                ],
              ),
            ],
          ),
          kAppSpacerVertical(height: 5),
          Text("${translate.title} : ${results.title}", style: kAppLblSmallFontMedium(context)),
          kAppSpacerVertical(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${translate.min_qty} : ${results.min}", style: kAppLblSmallFontMedium(context)),
              kAppSpacerHorizontal(width: 10),
              Text("${translate.max_qty} : ${results.max}", style: kAppLblSmallFontMedium(context)),
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
          Text("${results.name} ${stockType != 'unlimited' ? '(${results.stock})' : ''}", style: kAppLblSmallFontMedium(context)),
          Text(
            GlobalSettings.globalCurrencySide == 'left' ? '${translate.price} : ${GlobalSettings.globalCurrencySymbol}${results.price!}' : '${translate.price} : ${results.price!}${GlobalSettings.globalCurrencySymbol}',
            style: kAppLblSmallFontMedium(context),
          ),
        ],
      ),
    );
  }
}
// DONE //