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
import 'package:driver/app/presentation/styles/app_style.dart';

class LoaderService {
  static void showLoader(BuildContext context, {String msg = ''}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              kAppCircularProgress(context, strokeWidth: 3.0, width: 20.0, height: 20.0, padding: 0),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Text(msg, style: kAppLblMediumFontMedium(context)),
              ),
            ],
          ),
        );
      },
    );
  }

  static void hideLoder(BuildContext context) {
    Navigator.of(context).pop();
  }
}
