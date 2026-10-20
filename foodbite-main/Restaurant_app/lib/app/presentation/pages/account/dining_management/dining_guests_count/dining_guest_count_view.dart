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
import 'package:vendor/app/presentation/pages/account/dining_management/dining_guests_count/bloc/dining_guest_count_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/success_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DiningGuestCountScreen extends StatelessWidget {
  const DiningGuestCountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => DiningGuestCountBloc()..add(DiningGuestCountInitialEvent()), child: const DiningGuestCountView());
  }
}

class DiningGuestCountView extends StatelessWidget {
  const DiningGuestCountView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<DiningGuestCountBloc, DiningGuestCountState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isUpdateFailed) {
          showErrorDialog(context, state.alertMessage, state.extraMessage.toString(), state.statusCode);
        } else if (state.status.isUpdateSuccess) {
          showSuccessDialog(context, translate.guest_availability_updated);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state.status.isUpdateStart ? true : false,
          child: Scaffold(
            appBar: AppBar(title: Text(translate.dining_guest_availability), scrolledUnderElevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status.isLoading) ...[
                    const DiningGuestCountLoadingView(),
                  ] else if (state.status.isFailure) ...[
                    const DiningGuestCountErrorView(),
                  ] else ...[
                    Text(translate.dining_guest_available_count_title, style: kAppLblMediumFontRegular(context)),
                    kAppSpacerVertical(height: 5),
                    Text(translate.dining_guest_available_count_sub_title, style: kAppLblMediumFontRegular(context)),
                    kAppSpacerVertical(height: 10),
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 50),
                      scrollDirection: Axis.vertical,
                      key: UniqueKey(),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => context.read<DiningGuestCountBloc>().add(DiningGuestCountSelectEvent(selectedNumber: state.guestCount[index])),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 5,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(color: state.savedGuest.contains(state.guestCount[index]) ? Theme.of(context).primaryColor : ThemeProvider.lightDisabledColor, width: 1.5),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                              child: Container(
                                decoration: BoxDecoration(color: state.savedGuest.contains(state.guestCount[index]) ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor),
                                child: Center(child: Text("${state.guestCount[index]}", style: state.savedGuest.contains(state.guestCount[index]) ? kAppLblTinyFontBoldGuest(context) : kAppLblTinyFontBold(context))),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: state.guestCount.length,
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
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: state.savedGuest.isNotEmpty ? () => context.read<DiningGuestCountBloc>().add(DiningGuestCountSaveEvent()) : null,
                                  style: kAppElevatedButtonStyle(
                                    context,
                                    disabledColor: Theme.of(context).disabledColor,
                                    bgColor: Theme.of(context).primaryColor,
                                    foreColor: Theme.of(context).scaffoldBackgroundColor,
                                    height: 50.0,
                                  ),
                                  child: state.status.isUpdateStart ? kAppCircularProgress(context, color: 'light', strokeWidth: 3.0, width: 24.0, height: 24.0, padding: 2.0) : Text(translate.save_changes),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class DiningGuestCountLoadingView extends StatelessWidget {
  const DiningGuestCountLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonAvatar(style: SkeletonAvatarStyle(width: MediaQuery.of(context).size.width, height: 10)),
        kAppSpacerVertical(height: 10),
        SkeletonAvatar(style: SkeletonAvatarStyle(width: MediaQuery.of(context).size.width / 1.2, height: 10)),
        kAppSpacerVertical(height: 10),
        GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 50),
          scrollDirection: Axis.vertical,
          key: UniqueKey(),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: MediaQuery.of(context).size.width / 5,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
                  child: const Center(child: SkeletonAvatar(style: SkeletonAvatarStyle(width: 5, height: 5))),
                ),
              ),
            );
          },
          itemCount: 40,
        ),
      ],
    );
  }
}

class DiningGuestCountErrorView extends StatelessWidget {
  const DiningGuestCountErrorView({super.key});

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