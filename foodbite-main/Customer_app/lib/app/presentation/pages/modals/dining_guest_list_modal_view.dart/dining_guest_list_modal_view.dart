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
import 'package:user/app/presentation/styles/app_style.dart';
import 'package:user/app/presentation/styles/theme.dart';
import 'package:user/gen/l10n/app_localizations.dart';

class DiningGuestListModalScreen extends StatelessWidget {
  final int savedGuest;
  final List<int> guestAvailability;
  const DiningGuestListModalScreen({super.key, required this.savedGuest, required this.guestAvailability});

  @override
  Widget build(BuildContext context) {
    return DiningGuestListModalView(savedGuest: savedGuest, guestAvailability: guestAvailability);
  }
}

class DiningGuestListModalView extends StatelessWidget {
  final int savedGuest;
  final List<int> guestAvailability;
  const DiningGuestListModalView({super.key, required this.savedGuest, required this.guestAvailability});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            guestAvailability.length,
            (guestIndex) => InkWell(
              onTap: () => Navigator.of(context).pop(guestAvailability[guestIndex]),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${guestAvailability[guestIndex]} ${guestAvailability[guestIndex] == 1 ? translate.guest : translate.guests}", style: kAppLblMediumFontBold(context, color: 'regular')),
                    kAppSpacerHorizontal(width: 10),
                    Icon(savedGuest == guestAvailability[guestIndex] ? Icons.radio_button_on_outlined : Icons.radio_button_off_outlined, color: Theme.of(context).primaryColor, size: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// Done //