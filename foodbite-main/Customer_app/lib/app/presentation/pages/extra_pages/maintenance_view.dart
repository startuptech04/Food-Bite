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
import 'package:user/app/core/config/assets_url.dart';
import 'package:user/app/presentation/styles/app_style.dart';
import 'package:user/app/presentation/styles/theme.dart';
import 'package:user/app/router/app_route_config.dart';
import 'package:user/gen/l10n/app_localizations.dart';

class MaintenanceScreen extends StatelessWidget {
  final String businessEmail;
  final String businessMobile;
  const MaintenanceScreen({super.key, required this.businessEmail, required this.businessMobile});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AssetsUrl.imageURL.errorMaintenance, width: double.infinity, height: 300, fit: BoxFit.contain),
              kAppSpacerVertical(height: 30),
              Text(translate.maintenance_title, textAlign: TextAlign.center, style: kAppLblLargeFontBold(context)),
              kAppSpacerVertical(height: 10),
              Text("${translate.maintenance_title_sub_title} $businessEmail ${translate.or} $businessMobile.", textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
              kAppSpacerVertical(height: 30),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.initialRoute, (Route<dynamic> route) => false),
                style: kAppTextButtonColoredStyle(context, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor),
                child: Text(translate.try_again),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Done //