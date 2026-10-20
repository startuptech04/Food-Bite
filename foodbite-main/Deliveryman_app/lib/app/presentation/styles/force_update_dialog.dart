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

import 'package:driver/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:driver/app/core/config/assets_url.dart';
import 'package:driver/app/presentation/styles/app_style.dart';

class ForceUpdateDialogService {
  static void showUpdateDialog(BuildContext context, String version, String url, String currentVersion) async {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AssetsUrl.imageURL.forceUpdateIcon, height: 45, width: 45),
              kAppSpacerVertical(height: 10),
              Text(translate.update_required, style: kAppLblLargeFontBold(context)),
              kAppSpacerVertical(height: 10),
              Text("${translate.new_update_one} ($version) ${translate.new_update_two} $currentVersion", style: kAppLblMediumFontRegular(context, color: 'regular')),
            ],
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final Uri updateUrl = Uri.parse(url);
                  if (!await launchUrl(updateUrl)) {}
                },
                style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50.0),
                child: Text(translate.update_now),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
