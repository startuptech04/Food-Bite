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
import 'package:vendor/app/core/models/categories_list_model.dart';
import 'package:vendor/app/core/models/media_gallery_modal_response_model.dart';
import 'package:vendor/app/core/models/translations/custom_category_form_translation.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';
import 'package:vendor/app/presentation/pages/media/media_modal_view.dart';
import 'package:vendor/app/presentation/pages/menu/categories/action/bloc/categories_action_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';

class CategoriesActionScreen extends StatelessWidget {
  final bool isNew;
  final VendorCategoryResultModel model;
  const CategoriesActionScreen({super.key, required this.isNew, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesActionBloc(),
      child: CategoriesActionView(isNew: isNew, model: model),
    );
  }
}

class CategoriesActionView extends StatefulWidget {
  final bool isNew;
  final VendorCategoryResultModel model;
  const CategoriesActionView({super.key, required this.isNew, required this.model});

  @override
  State<CategoriesActionView> createState() => _CategoriesActionViewState();
}

class _CategoriesActionViewState extends State<CategoriesActionView> with TickerProviderStateMixin {
  final TextEditingController _customCategoryNameController = TextEditingController();
  final _customCategoryNameFocusNode = FocusNode();
  List<CustomCategoryFormTranslations> translations = <CustomCategoryFormTranslations>[];

  late TabController customCategoryTranslationTabController;

  @override
  void initState() {
    super.initState();
    if (AppSupportedLanguagesModel.languages.length > 1) {
      for (var element in AppSupportedLanguagesModel.languages) {
        CustomCategoryFormTranslations keys = CustomCategoryFormTranslations(name: element.value, code: element.code, nativeName: element.value, value: '');
        translations.add(keys);
      }
    }

    context.read<CategoriesActionBloc>().add(CategoriesActionInitialEvent(isNew: widget.isNew, model: widget.model));

    _customCategoryNameFocusNode.addListener(() {
      if (!_customCategoryNameFocusNode.hasFocus) {
        context.read<CategoriesActionBloc>().add(CustomCategoryActionNameUnfocused());
      }
    });

    if (widget.isNew) {
      _customCategoryNameController.text = '';
    } else {
      _customCategoryNameController.text = widget.model.realName!;
      for (var locale in translations) {
        for (var translate in widget.model.translations!) {
          if (locale.code == translate.code) {
            locale.value = translate.value;
          }
        }
      }
    }
    customCategoryTranslationTabController = TabController(initialIndex: 0, length: translations.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<CategoriesActionBloc, CategoriesActionState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSuccess) {
          showSuccessDialog(context, widget.isNew ? translate.category_added : translate.category_updated).then((value) {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isInProgress ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(widget.isNew ? translate.add_category : translate.update_category), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    context.read<CategoriesActionBloc>().add(CustomCategoryActionImageChanged(image: galleryResponse.data!));
                                  }
                                });
                          },
                          child: Container(
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
                        ),
                      ],
                    ),
                    kAppSpacerVertical(height: 30),
                    TextFormField(
                      focusNode: _customCategoryNameFocusNode,
                      controller: _customCategoryNameController,
                      decoration: kAppInputDecoration(context, lblText: translate.form_category_name, errText: state.name.displayError != null ? translate.form_required : null),
                      style: kAppLblLargeFontMedium(context),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => context.read<CategoriesActionBloc>().add(CustomCategoryActionNameChanged(name: value)),
                      textInputAction: TextInputAction.next,
                    ),
                    kAppSpacerVertical(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          controller: customCategoryTranslationTabController,
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
                        controller: customCategoryTranslationTabController,
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
                  onPressed: () => context.read<CategoriesActionBloc>().add(
                    widget.isNew ? CustomCategoryActionFormCreateSubmitted(translations: translations) : CustomCategoryActionFormUpdateSubmitted(id: widget.model.id!, model: widget.model, translations: translations),
                  ),
                  style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                  child: state.status.isInProgress ? kAppCircularProgress(context, color: 'light', width: 24.0, height: 24.0, strokeWidth: 3.0, padding: 2.0) : Text(translate.submit_lbl),
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