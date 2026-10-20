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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class DiningHelpModalScreen extends StatelessWidget {
  const DiningHelpModalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DiningHelpModalView();
  }
}

class DiningHelpModalView extends StatelessWidget {
  const DiningHelpModalView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: Text(translate.choose_dining_settings),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: FaIcon(FontAwesomeIcons.xmark, size: Theme.of(context).textTheme.titleSmall?.fontSize, color: Theme.of(context).canvasColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop('menu'),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.calendarDays, size: 14, color: Theme.of(context).canvasColor),
                    kAppSpacerHorizontal(width: 10),
                    Text(translate.update_dining_menu, style: kAppLblMediumFontBold(context, color: 'regular')),
                  ],
                ),
              ),
            ),
            kAppSpacerVertical(height: 5),
            GestureDetector(
              onTap: () => Navigator.of(context).pop('schedule'),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.calendarDays, size: 14, color: Theme.of(context).canvasColor),
                    kAppSpacerHorizontal(width: 10),
                    Text(translate.set_dining_schedule, style: kAppLblMediumFontBold(context, color: 'regular')),
                  ],
                ),
              ),
            ),
            kAppSpacerVertical(height: 5),
            GestureDetector(
              onTap: () => Navigator.of(context).pop('guest'),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: ThemeProvider.lightDisabledColor, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.peopleLine, size: 14, color: Theme.of(context).canvasColor),
                    kAppSpacerHorizontal(width: 10),
                    Text(translate.set_dining_guest_availability, style: kAppLblMediumFontBold(context, color: 'regular')),
                  ],
                ),
              ),
            ),
            kAppSpacerVertical(height: 5),
          ],
        ),
      ),
    );
  }
}
// DONE //