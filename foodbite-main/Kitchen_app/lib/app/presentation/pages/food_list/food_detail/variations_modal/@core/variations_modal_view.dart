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
import 'package:kitchen/app/core/config/global_settings.dart';
import 'package:kitchen/app/core/models/food_variation_model.dart';
import 'package:kitchen/app/core/models/food_variation_options_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kitchen/app/core/models/variation_option_modal_response_model.dart';
import 'package:kitchen/app/core/models/variation_required_model.dart';
import 'package:kitchen/app/core/models/variation_type_model.dart';
import 'package:kitchen/app/presentation/pages/food_list/food_detail/variations_modal/@core/bloc/food_variation_modal_bloc.dart';
import 'package:kitchen/app/presentation/pages/food_list/food_detail/variations_modal/variation_options_modal/variation_options_modal_view.dart';
import 'package:kitchen/app/presentation/styles/app_style.dart';
import 'package:kitchen/app/presentation/styles/error_dialog.dart';
import 'package:kitchen/app/presentation/styles/theme.dart';
import 'package:kitchen/gen/l10n/app_localizations.dart';

class VariationModalScreen extends StatelessWidget {
  final bool isNew;
  final FoodVariationModel model;
  final String stockType;
  const VariationModalScreen({super.key, required this.isNew, required this.model, required this.stockType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodVariationModalBloc()..add(FoodVariationModalInitialEvent(isNew: isNew, model: model, stockType: stockType)),
      child: VariationModalView(isNew: isNew, model: model, stockType: stockType),
    );
  }
}

class VariationModalView extends StatefulWidget {
  final bool isNew;
  final FoodVariationModel model;
  final String stockType;
  const VariationModalView({super.key, required this.isNew, required this.model, required this.stockType});

  @override
  State<VariationModalView> createState() => _VariationModalViewState();
}

class _VariationModalViewState extends State<VariationModalView> {
  final TextEditingController _variationNameController = TextEditingController();
  final TextEditingController _variationMinController = TextEditingController();
  final TextEditingController _variationMaxController = TextEditingController();

  final _variationNameFocusNode = FocusNode();
  final _variationMinFocusNode = FocusNode();
  final _variationMaxFocusNode = FocusNode();

  final List<VariationTypeInterfaceModel> variationTypeList = <VariationTypeInterfaceModel>[];

  final List<VariationRequiredInterfaceModel> variationRequiredList = <VariationRequiredInterfaceModel>[];

  @override
  void initState() {
    super.initState();

    VariationTypeInterfaceModel multiType = VariationTypeInterfaceModel(type: 'single', label: 'single_selection');
    VariationTypeInterfaceModel singleType = VariationTypeInterfaceModel(type: 'multi', label: 'multi_selection');

    variationTypeList.clear();
    variationTypeList.add(multiType);
    variationTypeList.add(singleType);

    VariationRequiredInterfaceModel requiredTrue = VariationRequiredInterfaceModel(type: true, label: 'dd_yes');
    VariationRequiredInterfaceModel requiredFalse = VariationRequiredInterfaceModel(type: false, label: 'dd_no');

    variationRequiredList.clear();
    variationRequiredList.add(requiredTrue);
    variationRequiredList.add(requiredFalse);

    _variationNameFocusNode.addListener(() {
      if (!_variationNameFocusNode.hasFocus) {
        context.read<FoodVariationModalBloc>().add(FoodVariationNameUnfocused());
      }
    });

    _variationMinFocusNode.addListener(() {
      if (!_variationMinFocusNode.hasFocus) {
        context.read<FoodVariationModalBloc>().add(FoodVariationMinUnfocused());
      }
    });

    _variationMaxFocusNode.addListener(() {
      if (!_variationMaxFocusNode.hasFocus) {
        context.read<FoodVariationModalBloc>().add(FoodVariationMaxUnfocused());
      }
    });
    if (!widget.isNew) {
      _variationNameController.text = widget.model.title!;
      _variationMinController.text = widget.model.min!;
      _variationMaxController.text = widget.model.max!;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<FoodVariationModalBloc, FoodVariationModalState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop({'action': true, 'data': state.savedData.toJson()});
        } else if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(widget.isNew ? translate.add_variation : translate.update_variation),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop({'action': false, 'data': state.savedData.toJson()}),
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
                          onPressed: () => Navigator.of(context).pop({'action': false, 'data': state.savedData.toJson()}),
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).scaffoldBackgroundColor, foreColor: Theme.of(context).canvasColor, height: 50.0),
                          child: Text(translate.cancel),
                        ),
                      ),
                    ),
                    kAppSpacerHorizontal(width: 10),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.read<FoodVariationModalBloc>().add(FoodVaritionFormSubmit()),
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<bool>(
                          key: UniqueKey(),
                          decoration: kAppInputDecoration(context, lblText: translate.form_required),
                          style: kAppLblSmallFontMedium(context),
                          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                          initialValue: state.isRequired,
                          items: variationRequiredList.map((VariationRequiredInterfaceModel state) {
                            return DropdownMenuItem<bool>(value: state.type, child: Text(kAppDDTranslate(context, state.label!)));
                          }).toList(),
                          onChanged: (bool? value) => context.read<FoodVariationModalBloc>().add(FoodVariationRequiredChanged(checked: value!)),
                        ),
                      ),
                      kAppSpacerHorizontal(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          key: UniqueKey(),
                          decoration: kAppInputDecoration(context, lblText: translate.form_variation_type),
                          style: kAppLblSmallFontMedium(context),
                          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                          initialValue: state.type,
                          items: variationTypeList.map((VariationTypeInterfaceModel state) {
                            return DropdownMenuItem<String>(value: state.type, child: Text(kAppDDTranslate(context, state.label!)));
                          }).toList(),
                          onChanged: (String? value) {
                            _variationMinController.text = '';
                            _variationMaxController.text = '';
                            context.read<FoodVariationModalBloc>().add(FoodVariationTypeChanged(value: value!));
                          },
                        ),
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  TextFormField(
                    focusNode: _variationNameFocusNode,
                    controller: _variationNameController,
                    decoration: kAppInputDecoration(context, lblText: translate.form_variation_title, errText: state.name.displayError != null ? translate.form_required : null),
                    style: kAppLblLargeFontMedium(context),
                    keyboardType: TextInputType.text,
                    onChanged: (value) => context.read<FoodVariationModalBloc>().add(FoodVariationNameChanged(name: value)),
                    textInputAction: TextInputAction.next,
                  ),
                  kAppSpacerVertical(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _variationMinController,
                          focusNode: _variationMinFocusNode,
                          enabled: state.type == 'multi' ? true : false,
                          decoration: kAppInputDecoration(context, lblText: translate.form_min_option_to_select, errText: state.min.displayError != null ? translate.form_required : null),
                          style: kAppLblLargeFontMedium(context),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => context.read<FoodVariationModalBloc>().add(FoodVariationMinChanged(min: value)),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      kAppSpacerHorizontal(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _variationMaxController,
                          focusNode: _variationMaxFocusNode,
                          enabled: state.type == 'multi' ? true : false,
                          decoration: kAppInputDecoration(context, lblText: translate.form_max_option_to_select, errText: state.max.displayError != null ? translate.form_required : null),
                          style: kAppLblLargeFontMedium(context),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => context.read<FoodVariationModalBloc>().add(FoodVariationMaxChanged(max: value)),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          var height = MediaQuery.of(context).size.height;
                          var width = MediaQuery.of(context).size.width;
                          return AlertDialog(
                            insetPadding: EdgeInsets.zero,
                            contentPadding: EdgeInsets.zero,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            content: SizedBox(
                              height: height - 400,
                              width: width - 30,
                              child: VariationOptionsModalScreen(isNew: true, model: FoodVariationOptionModel(), stockType: widget.stockType),
                            ),
                          );
                        },
                      ).then((value) {
                        if (!context.mounted) return;
                        VariationsOptionModalResponse variationOptionsResponse = VariationsOptionModalResponse.fromJson(value);
                        if (variationOptionsResponse.action!) {
                          context.read<FoodVariationModalBloc>().add(
                            FoodVariationOptionChanged(isNew: true, index: 0, name: variationOptionsResponse.name!, price: variationOptionsResponse.price!, stock: variationOptionsResponse.stock!),
                          );
                        }
                      });
                    },
                    style: kAppOutlineButtonStyle(context, foreColor: 'light', radius: 5.0),
                    child: Text(translate.add_new_option),
                  ),
                  kAppSpacerVertical(height: 20),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).colorScheme.secondary),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Theme.of(context).primaryColor, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                        kAppSpacerHorizontal(width: 10),
                        Text(translate.options, style: kAppLblMediumFontBold(context, color: 'primary')),
                      ],
                    ),
                  ),
                  kAppSpacerVertical(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(state.options.length, (index) => VariationOptionTile(results: state.options[index], index: index, stockType: widget.stockType)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class VariationOptionTile extends StatelessWidget {
  final FoodVariationOptionModel results;
  final int index;
  final String stockType;
  const VariationOptionTile({super.key, required this.results, required this.index, required this.stockType});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(results.name!, style: kAppLblMediumFontMedium(context)),
              Text(
                GlobalSettings.globalCurrencySide == 'left' ? '${translate.price} : ${GlobalSettings.globalCurrencySymbol}${results.price!}' : '${translate.price} : ${results.price!}${GlobalSettings.globalCurrencySymbol}',
                style: kAppLblSmallFontMedium(context),
              ),
              results.stock! != '' && stockType != 'unlimited' ? Text("${translate.stock} : ${results.stock! != '-1' ? results.stock : translate.unlimited}", style: kAppLblSmallFontMedium(context)) : const SizedBox(),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    var height = MediaQuery.of(context).size.height;
                    var width = MediaQuery.of(context).size.width;
                    return AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      contentPadding: EdgeInsets.zero,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      content: SizedBox(
                        height: height - 400,
                        width: width - 30,
                        child: VariationOptionsModalScreen(isNew: false, model: results, stockType: stockType),
                      ),
                    );
                  },
                ).then((value) {
                  if (!context.mounted) return;
                  VariationsOptionModalResponse variationOptionsResponse = VariationsOptionModalResponse.fromJson(value);
                  if (variationOptionsResponse.action!) {
                    context.read<FoodVariationModalBloc>().add(
                      FoodVariationOptionChanged(isNew: false, index: index, name: variationOptionsResponse.name!, price: variationOptionsResponse.price!, stock: variationOptionsResponse.stock!),
                    );
                  }
                });
              },
              icon: FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelMedium?.fontSize),
            ),
            IconButton(
              onPressed: () => context.read<FoodVariationModalBloc>().add(FoodVariationRemoveEvent(index: index)),
              icon: FaIcon(FontAwesomeIcons.trashCan, size: Theme.of(context).textTheme.labelMedium?.fontSize),
            ),
          ],
        ),
      ],
    );
  }
}
// DONE //