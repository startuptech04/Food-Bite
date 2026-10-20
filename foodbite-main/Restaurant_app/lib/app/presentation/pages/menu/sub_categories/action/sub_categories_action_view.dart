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
import 'package:vendor/app/core/models/category_modal_response_model.dart';
import 'package:vendor/app/core/models/sub_categories_list_model.dart';
import 'package:vendor/app/core/models/translations/custom_sub_category_form_translation.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/app/presentation/pages/modals/custom_categories/custom_categories_modal.dart';
import 'package:vendor/app/presentation/pages/menu/sub_categories/action/bloc/sub_categories_action_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class SubCategoriesActionScreen extends StatelessWidget {
  final bool isNew;
  final CustomSubCategoryResultModel model;
  const SubCategoriesActionScreen({super.key, required this.isNew, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubCategoriesActionBloc(),
      child: SubCategoriesActionView(isNew: isNew, model: model),
    );
  }
}

class SubCategoriesActionView extends StatefulWidget {
  final bool isNew;
  final CustomSubCategoryResultModel model;
  const SubCategoriesActionView({super.key, required this.isNew, required this.model});

  @override
  State<SubCategoriesActionView> createState() => _SubCategoriesActionViewState();
}

class _SubCategoriesActionViewState extends State<SubCategoriesActionView> with TickerProviderStateMixin {
  final TextEditingController _customSubCategoryNameController = TextEditingController();
  final TextEditingController _customSubCategoryMainCateNameController = TextEditingController();
  final _customSubCategoryNameFocusNode = FocusNode();
  final _customSubCategoryMainCateNameFocuseNode = FocusNode();
  List<CustomSubCategoryFormTranslations> translations = <CustomSubCategoryFormTranslations>[];

  late TabController customSubCategoryTranslationTabController;

  @override
  void initState() {
    super.initState();
    if (AppSupportedLanguagesModel.languages.length > 1) {
      for (var element in AppSupportedLanguagesModel.languages) {
        CustomSubCategoryFormTranslations keys = CustomSubCategoryFormTranslations(name: element.value, code: element.code, nativeName: element.value, value: '');
        translations.add(keys);
      }
    }

    context.read<SubCategoriesActionBloc>().add(SubCategoriesActionInitialEvent(isNew: widget.isNew, model: widget.model));

    _customSubCategoryNameFocusNode.addListener(() {
      if (!_customSubCategoryNameFocusNode.hasFocus) {
        context.read<SubCategoriesActionBloc>().add(CustomSubCategoryActionNameUnfocused());
      }
    });

    _customSubCategoryMainCateNameFocuseNode.addListener(() {
      if (!_customSubCategoryMainCateNameFocuseNode.hasFocus) {
        context.read<SubCategoriesActionBloc>().add(CustomSubCategoryCateIdUnfocused());
      }
    });

    if (widget.isNew) {
      _customSubCategoryNameController.text = '';
      _customSubCategoryMainCateNameController.text = '';
    } else {
      _customSubCategoryNameController.text = widget.model.realName!;
      _customSubCategoryMainCateNameController.text = widget.model.category != null && widget.model.category!.name!.isNotEmpty ? widget.model.category!.name! : '';
      for (var locale in translations) {
        for (var translate in widget.model.translations!) {
          if (locale.code == translate.code) {
            locale.value = translate.value;
          }
        }
      }
    }
    customSubCategoryTranslationTabController = TabController(initialIndex: 0, length: translations.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<SubCategoriesActionBloc, SubCategoriesActionState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSuccess) {
          showSuccessDialog(context, widget.isNew ? translate.sub_category_added : translate.sub_category_updated).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isInProgress ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(widget.isNew ? translate.add_sub_category : translate.update_sub_category), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    kAppSpacerVertical(height: 10),
                    TextFormField(
                      focusNode: _customSubCategoryMainCateNameFocuseNode,
                      controller: _customSubCategoryMainCateNameController,
                      readOnly: true,
                      decoration: kAppInputDecoration(
                        context,
                        lblText: translate.form_select_category,
                        errText: state.category.displayError != null ? translate.form_required : null,
                        suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                      ),
                      style: kAppLblSmallFontMedium(context),
                      keyboardType: TextInputType.text,
                      onTap: () {
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
                                _customSubCategoryMainCateNameController.text = categoryResponse.name!;
                                context.read<SubCategoriesActionBloc>().add(CustomSubCategoryActionCategoryModalResponseEvent(id: categoryResponse.id!, name: categoryResponse.name!));
                              }
                            });
                      },
                    ),
                    kAppSpacerVertical(height: 20),
                    TextFormField(
                      focusNode: _customSubCategoryNameFocusNode,
                      controller: _customSubCategoryNameController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_sub_category_name, errText: state.name.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<SubCategoriesActionBloc>().add(CustomSubCategoryActionNameChanged(name: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          controller: customSubCategoryTranslationTabController,
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
                        controller: customSubCategoryTranslationTabController,
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
                  onPressed: () => context.read<SubCategoriesActionBloc>().add(
                    widget.isNew ? CustomSubCategoryActionFormCreateSubmitted(translations: translations) : CustomSubCategoryActionFormUpdateSubmitted(id: widget.model.id!, model: widget.model, translations: translations),
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
// DONE //