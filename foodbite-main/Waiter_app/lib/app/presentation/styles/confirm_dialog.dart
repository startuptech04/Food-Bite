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
import 'package:waiter/app/presentation/styles/app_style.dart';

Future<bool> showConfirmDialog(BuildContext context, String title, String subTitle, String cancelBtnTitle, String okBtnTitle) async {
  return (await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(title),
          content: Text(subTitle),
          titleTextStyle: TextStyle(fontFamily: 'bold', fontSize: Theme.of(context).textTheme.titleMedium?.fontSize, color: Theme.of(context).canvasColor),
          contentTextStyle: kAppLblMediumFontMedium(context),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelBtnTitle, style: kAppLblMediumFontMedium(context)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                okBtnTitle,
                style: TextStyle(fontSize: Theme.of(context).textTheme.labelMedium?.fontSize, fontFamily: 'medium', color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      )) ??
      false;
}
