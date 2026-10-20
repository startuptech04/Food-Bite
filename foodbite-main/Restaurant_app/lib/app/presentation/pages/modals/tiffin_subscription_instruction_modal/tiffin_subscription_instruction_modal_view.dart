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
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/tiffin_subscription_instruction_translation_model.dart';
import 'package:vendor/app/env.dart';
import 'package:vendor/app/presentation/pages/modals/tiffin_subscription_instruction_modal/bloc/tiffin_subscription_instruction_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class TiffinSubscriptionInstructionModalScreen extends StatelessWidget {
  final bool isNew;
  final String title;
  final List<TiffinSubscriptionInstructionTranslationModel> translation;
  const TiffinSubscriptionInstructionModalScreen({super.key, required this.isNew, required this.title, required this.translation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TiffinSubscriptionInstructionModalBloc()..add(TiffinSubscriptionInstructionInitialEvent(isNew: isNew, title: title)),
      child: TiffinSubscriptionInstructionModalView(isNew: isNew, title: title, translation: translation),
    );
  }
}

class TiffinSubscriptionInstructionModalView extends StatefulWidget {
  final bool isNew;
  final String title;
  final List<TiffinSubscriptionInstructionTranslationModel> translation;
  const TiffinSubscriptionInstructionModalView({super.key, required this.isNew, required this.title, required this.translation});

  @override
  State<TiffinSubscriptionInstructionModalView> createState() => _TiffinSubscriptionInstructionModalViewState();
}

class _TiffinSubscriptionInstructionModalViewState extends State<TiffinSubscriptionInstructionModalView> with TickerProviderStateMixin {
  final TextEditingController _instructionNameController = TextEditingController();

  final _instructionNameFocusNode = FocusNode();

  List<TiffinSubscriptionInstructionTranslationModel> translations = <TiffinSubscriptionInstructionTranslationModel>[];
  late TabController instructionTranslationTabController;

  @override
  void initState() {
    super.initState();
    if (AppSupportedLanguagesModel.languages.length > 1) {
      for (var element in AppSupportedLanguagesModel.languages) {
        TiffinSubscriptionInstructionTranslationModel keys = TiffinSubscriptionInstructionTranslationModel(name: element.value, code: element.code, nativeName: element.value, value: '');
        translations.add(keys);
      }
    }
    instructionTranslationTabController = TabController(initialIndex: 0, length: translations.length, vsync: this);

    _instructionNameFocusNode.addListener(() {
      if (!_instructionNameFocusNode.hasFocus) {
        context.read<TiffinSubscriptionInstructionModalBloc>().add(TiffinSubscriptionInstructionNameModalUnfocusedEvent());
      }
    });
    if (!widget.isNew) {
      for (var locale in translations) {
        for (var translate in widget.translation) {
          if (locale.code == translate.code) {
            locale.value = translate.value;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _instructionNameController.dispose();
    _instructionNameFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    final isValid = context.select((TiffinSubscriptionInstructionModalBloc bloc) => bloc.state.isValid);
    return BlocConsumer<TiffinSubscriptionInstructionModalBloc, TiffinSubscriptionInstructionModalState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSuccess) {
          _instructionNameController.text = state.instructionName.value;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(widget.isNew ? translate.add_instruction : translate.update_instruction),
            actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const TiffinSubscriptionInstructionModalLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const TiffinSubscriptionInstructionModalErrorView(),
                ] else ...[
                  TextFormField(
                    controller: _instructionNameController,
                    focusNode: _instructionNameFocusNode,
                    decoration: kAppInputDecoration(context, lblText: translate.form_instruction, errText: state.instructionName.displayError != null ? translate.form_required : null),
                    style: kAppLblLargeFontMedium(context),
                    maxLines: 2,
                    keyboardType: TextInputType.text,
                    inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]+'))],
                    onChanged: (value) {
                      if (value.startsWith(' ')) {
                        _instructionNameController.text = value.trimLeft();
                        _instructionNameController.selection = TextSelection.collapsed(offset: _instructionNameController.text.length);
                      }
                      if (RegExp(r'^[0-9]').hasMatch(value)) {
                        _instructionNameController.text = value.substring(1);
                        _instructionNameController.selection = TextSelection.collapsed(offset: _instructionNameController.text.length);
                      }
                      context.read<TiffinSubscriptionInstructionModalBloc>().add(TiffinSubscriptionInstructionModalNameChangeEvent(name: _instructionNameController.text));
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
                        controller: instructionTranslationTabController,
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
                      controller: instructionTranslationTabController,
                      children: List.generate(
                        translations.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            initialValue: translations[index].value,
                            decoration: kAppInputDecoration(context, lblText: "${translate.form_name} ${translations[index].nativeName}"),
                            maxLines: 2,
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
              ],
            ),
          ),
          bottomNavigationBar: state.status.isLoading || state.status.isFailure
              ? SafeArea(child: const SizedBox())
              : SafeArea(
                  child: SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: double.infinity,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [Text(translate.cancel_lbl, style: kAppLblSmallFontBold(context, color: 'canvas'))],
                                ),
                              ),
                            ),
                          ),
                          const Expanded(flex: 1, child: SizedBox(width: double.infinity)),
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              onPressed: isValid
                                  ? () {
                                      Navigator.of(context).pop(jsonEncode({'action': true, 'name': _instructionNameController.text, 'translation': translations}));
                                    }
                                  : null,
                              style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                              child: Text(translate.save_lbl),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class TiffinSubscriptionInstructionModalLoadingView extends StatelessWidget {
  const TiffinSubscriptionInstructionModalLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

class TiffinSubscriptionInstructionModalErrorView extends StatelessWidget {
  const TiffinSubscriptionInstructionModalErrorView({super.key});

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