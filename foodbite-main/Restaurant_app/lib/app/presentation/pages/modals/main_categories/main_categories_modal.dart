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
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:vendor/app/presentation/pages/modals/main_categories/bloc/main_categories_modal_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class MainCategoriesModalScreen extends StatelessWidget {
  final String categoryId;
  const MainCategoriesModalScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCategoriesModalBloc()..add(MainCategoriesModalInitialEvent(selectedCategories: categoryId)),
      child: MainCategoriesModalView(categoryId: categoryId),
    );
  }
}

class MainCategoriesModalView extends StatefulWidget {
  final String categoryId;
  const MainCategoriesModalView({super.key, required this.categoryId});

  @override
  State<MainCategoriesModalView> createState() => _MainCategoriesModalViewState();
}

class _MainCategoriesModalViewState extends State<MainCategoriesModalView> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<MainCategoriesModalBloc, MainCategoriesModalState>(
      listener: (context, state) {
        if (state.status.isSelected) {
          Navigator.of(context).pop({'action': true, 'id': state.info.id!, 'name': state.info.name!});
        } else if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(translate.choose_category),
            elevation: 1,
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop({'action': false, 'id': '', 'name': ''}),
                icon: Icon(Icons.close_outlined, color: Theme.of(context).iconTheme.color),
              ),
            ],
          ),
          body: state.status.isLoading
              ? SkeletonListView(itemCount: 5)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.categories.length,
                      (index) => InkWell(
                        onTap: () => context.read<MainCategoriesModalBloc>().add(MainCategoriesSelectEvent(selectedCategories: state.categories[index])),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                child: Text(state.categories[index].name!, style: kAppLblMediumFontMedium(context)),
                              ),
                              Icon(state.selectedCategories == state.categories[index].id ? Icons.radio_button_checked_outlined : Icons.circle_outlined),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
                          onPressed: () => Navigator.of(context).pop({'action': false, 'id': '', 'name': ''}),
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).scaffoldBackgroundColor, foreColor: Theme.of(context).canvasColor, height: 50.0),
                          child: Text(translate.cancel_lbl),
                        ),
                      ),
                    ),
                    kAppSpacerHorizontal(width: 10),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.selectedCategories.isNotEmpty ? () => context.read<MainCategoriesModalBloc>().add(MainCategoriesOnSaveEvent()) : null,
                          style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50),
                          child: Text(translate.save_lbl),
                        ),
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
// DONE //