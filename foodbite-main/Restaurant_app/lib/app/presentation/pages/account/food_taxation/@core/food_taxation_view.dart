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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/presentation/pages/account/food_taxation/@core/bloc/food_taxation_bloc.dart';
import 'package:vendor/app/presentation/pages/account/food_taxation/food_taxation_dialog/food_taxation_dialog_view.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/confirm_dialog.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/loader_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class FoodTaxationScreen extends StatelessWidget {
  const FoodTaxationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => FoodTaxationBloc()..add(FoodTaxationInitialEvent()), child: const FoodTaxationView());
  }
}

class FoodTaxationView extends StatefulWidget {
  const FoodTaxationView({super.key});

  @override
  State<FoodTaxationView> createState() => _FoodTaxationViewState();
}

class _FoodTaxationViewState extends State<FoodTaxationView> {
  final ScrollController _scrollTaxController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollTaxController.addListener(() {
      if (_scrollTaxController.position.pixels == _scrollTaxController.position.maxScrollExtent) {
        context.read<FoodTaxationBloc>().add(FoodTaxationLoadMoreEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<FoodTaxationBloc, FoodTaxationState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isDeleteStarted) {
          LoaderService.showLoader(context);
        } else if (state.status.isDeleteSuccess) {
          LoaderService.hideLoder(context);
          showSuccessDialog(context, translate.taxation_deleted);
        } else if (state.status.isDeleteFailed) {
          LoaderService.hideLoder(context);
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(translate.food_taxation), scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            controller: _scrollTaxController,
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const FoodTaxationLoadingView(),
                ] else if (state.status.isEmpty) ...[
                  const FoodTaxationEmptyView(),
                ] else if (state.status.isFailure) ...[
                  const FoodTaxationErrorView(),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.model.results!.length,
                      (taxIndex) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("${state.model.results![taxIndex].taxName} (${state.model.results![taxIndex].taxAmount}%)", style: kAppLblMediumFontMedium(context)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: false,
                                    enableDrag: false,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    builder: (BuildContext context) {
                                      return FractionallySizedBox(
                                        heightFactor: 0.7,
                                        child: FoodTaxationDialogScreen(
                                          isNew: false,
                                          taxId: state.model.results![taxIndex].id!,
                                          name: state.model.results![taxIndex].realName!,
                                          amount: state.model.results![taxIndex].taxAmount!,
                                          transalation: state.model.results![taxIndex].translations!,
                                        ),
                                      );
                                    },
                                  ).then((value) {
                                    if (!context.mounted) return;
                                    if (value != null && value.toString().isNotEmpty) {
                                      context.read<FoodTaxationBloc>().add(FoodTaxationInitialEvent());
                                    }
                                  });
                                },
                                icon: FaIcon(FontAwesomeIcons.penToSquare, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                              ),
                              IconButton(
                                onPressed: () {
                                  showConfirmDialog(context, translate.alert_confirm_title, translate.alert_taxation_removed, translate.cancel_lbl, translate.yes_delete_btn).then((value) {
                                    if (!context.mounted) return;
                                    if (value) {
                                      context.read<FoodTaxationBloc>().add(FoodTaxationDeleteEvent(id: state.model.results![taxIndex].id!));
                                    }
                                  });
                                },
                                icon: FaIcon(FontAwesomeIcons.trashCan, size: Theme.of(context).textTheme.labelMedium?.fontSize),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  kAppSpacerVertical(height: 20),
                  state.loadMore ? kAppCenterCircularProgress(context) : const SizedBox(),
                  kAppSpacerVertical(height: 20),
                ],
              ],
            ),
          ),
          floatingActionButton: SizedBox(
            height: 30,
            child: FloatingActionButton.extended(
              heroTag: 'addFoodTaxationFab',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  builder: (BuildContext context) {
                    return const FractionallySizedBox(
                      heightFactor: 0.7,
                      child: FoodTaxationDialogScreen(isNew: true, taxId: '', name: '', amount: 0, transalation: []),
                    );
                  },
                ).then((value) {
                  if (!context.mounted) return;
                  if (value != null && value.toString().isNotEmpty) {
                    context.read<FoodTaxationBloc>().add(FoodTaxationInitialEvent());
                  }
                });
              },
              label: Text(translate.add_tax),
              icon: Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}

class FoodTaxationLoadingView extends StatelessWidget {
  const FoodTaxationLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        10,
        (index) => Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.3, borderRadius: BorderRadius.circular(8)),
              ),
              SkeletonLine(style: SkeletonLineStyle(height: 10, width: 20, borderRadius: BorderRadius.circular(8))),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodTaxationEmptyView extends StatelessWidget {
  const FoodTaxationEmptyView({super.key});

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

class FoodTaxationErrorView extends StatelessWidget {
  const FoodTaxationErrorView({super.key});

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