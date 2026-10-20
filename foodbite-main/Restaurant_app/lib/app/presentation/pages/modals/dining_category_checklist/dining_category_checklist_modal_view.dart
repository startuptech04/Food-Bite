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
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/presentation/pages/modals/dining_category_checklist/bloc/dining_category_checklist_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DiningCategoryChecklistModalScreen extends StatelessWidget {
  final List<String> savedCategory;
  const DiningCategoryChecklistModalScreen({super.key, required this.savedCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiningCategoryChecklistBloc()..add(DiningCategoryChecklistInitialEvent(savedCategory: savedCategory)),
      child: const DiningCategoryChecklistModalView(),
    );
  }
}

class DiningCategoryChecklistModalView extends StatelessWidget {
  const DiningCategoryChecklistModalView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<DiningCategoryChecklistBloc, DiningCategoryChecklistState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isSelected) {
          Navigator.of(context).pop({'action': true, 'ids': state.savedDiningCategoryId, 'names': state.savedDiningCategoryName});
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            title: Text(translate.choose_dining_categories),
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop({'action': false, 'ids': state.savedDiningCategoryId, 'names': state.savedDiningCategoryName}),
                icon: Icon(Icons.close_outlined, color: Theme.of(context).iconTheme.color),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const DiningCategoryChecklistModalLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const DiningCategoryChecklistErrorView(),
                ] else if (state.status.isEmpty) ...[
                  const DiningCategoryChecklistEmptyView(),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.categories.length,
                      (index) => GestureDetector(
                        onTap: () => context.read<DiningCategoryChecklistBloc>().add(DiningCategoryChecklistSelectEvent(id: state.categories[index].id!, name: state.categories[index].name!)),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(state.categories[index].name!, style: kAppLblMediumFontMedium(context)),
                              Icon(state.savedDiningCategoryId.contains(state.categories[index].id) ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          bottomNavigationBar: state.status.isSuccess
              ? SafeArea(
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
                                onPressed: () => Navigator.of(context).pop({'action': false, 'ids': state.savedDiningCategoryId, 'names': state.savedDiningCategoryName}),
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
                                onPressed: () => context.read<DiningCategoryChecklistBloc>().add(DiningCategoryChecklistSaveEvent()),
                                style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50),
                                child: Text(translate.save_lbl),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SafeArea(child: const SizedBox()),
        );
      },
    );
  }
}

class DiningCategoryChecklistModalLoadingView extends StatelessWidget {
  const DiningCategoryChecklistModalLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        10,
        (index) => Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: SkeletonListTile(
            verticalSpacing: 5,
            leadingStyle: SkeletonAvatarStyle(width: 45, height: 45, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
            titleStyle: SkeletonLineStyle(height: 15, minLength: 200, randomLength: true, borderRadius: BorderRadius.circular(5)),
            subtitleStyle: SkeletonLineStyle(height: 12, maxLength: 200, randomLength: true, borderRadius: BorderRadius.circular(5)),
            hasSubtitle: true,
          ),
        ),
      ),
    );
  }
}

class DiningCategoryChecklistEmptyView extends StatelessWidget {
  const DiningCategoryChecklistEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 20),
          Image.asset(AssetsUrl.imageURL.cartEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 20),
          Text(translate.no_record_found_title, textAlign: TextAlign.center, style: kAppLblMediumFontBold(context)),
          kAppSpacerVertical(height: 5),
          Text(translate.no_record_found_sub_title, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}

class DiningCategoryChecklistErrorView extends StatelessWidget {
  const DiningCategoryChecklistErrorView({super.key});

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