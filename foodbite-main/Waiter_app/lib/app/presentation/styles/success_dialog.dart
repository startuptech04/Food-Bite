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
import 'package:flutter/services.dart';
import 'package:waiter/app/core/config/assets_url.dart';
import 'package:waiter/app/presentation/styles/app_style.dart';
import 'package:waiter/gen/l10n/app_localizations.dart';

Future<bool> showSuccessDialog(BuildContext context, String successMsg) async {
  final AppLocalizations translate = AppLocalizations.of(context)!;
  HapticFeedback.lightImpact();
  return (await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AssetsUrl.imageURL.successIcon, height: 45, width: 45),
              kAppSpacerVertical(height: 10),
              Text(translate.success, style: kAppLblLargeFontBold(context)),
              kAppSpacerVertical(height: 10),
              Text(successMsg, style: kAppLblMediumFontRegular(context, color: 'regular')),
            ],
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                child: Text(translate.ok_thank_you_btn),
              ),
            ),
          ],
        ),
      )) ??
      false;
}
