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
import 'package:waiter/app/core/config/assets_url.dart';
import 'package:waiter/app/core/config/global_settings.dart';
import 'package:waiter/app/presentation/styles/theme.dart';
import 'package:waiter/gen/l10n/app_localizations.dart';

TextStyle kAppStyleTabTitleStyle(BuildContext context) {
  return TextStyle(fontFamily: 'medium', fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize));
}

TextStyle kAppLblMediumFontBold(BuildContext context, {String color = 'regular'}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'bold', color: color == 'regular' ? Theme.of(context).canvasColor : Theme.of(context).primaryColor);
}

TextStyle kAppLblMediumFontRegular(BuildContext context, {String color = 'regular'}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'regular', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblMediumFontMedium(BuildContext context, {String color = 'regular'}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'medium', color: color == 'regular' ? Theme.of(context).canvasColor : Theme.of(context).primaryColor);
}

TextStyle kAppLblMediumFontMediumGrey(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'medium', color: Theme.of(context).colorScheme.tertiary);
}

TextStyle kAppLblMediumFontRegularError(BuildContext context, {String color = 'regular'}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'regular', color: ThemeProvider.errorColor);
}

TextStyle kAppLblLargeFontMedium(BuildContext context, {String color = 'regular'}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelLarge?.fontSize), fontFamily: 'medium', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblSmallFontMedium(BuildContext context, {String color = 'regular'}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'medium', color: color == 'regular' ? Theme.of(context).canvasColor : Theme.of(context).primaryColor);
}

TextStyle kAppLblSemiBoldFontLarge(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelLarge?.fontSize), fontFamily: 'semibold', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblSemiBoldToggle(BuildContext context, {bool canDeliver = true}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'semibold', color: canDeliver ? ThemeProvider.successColor : ThemeProvider.errorColor);
}

TextStyle kAppLblSmallFontRegular(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblTinyFontRegular(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).colorScheme.tertiary);
}

TextStyle kAppCouponLblTinyFontRegular(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).colorScheme.inverseSurface);
}

TextStyle kAppLblTinyFontRegularChip(BuildContext context, {String color = 'regular'}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: color == 'regular' ? Theme.of(context).canvasColor : Theme.of(context).primaryColor);
}

TextStyle kAppLblTinyFontBold(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'bold', color: Theme.of(context).colorScheme.tertiary);
}

TextStyle kAppLblTinyFontBoldGuest(BuildContext context) {
  return TextStyle(fontFamily: 'medium', color: Theme.of(context).scaffoldBackgroundColor, fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize));
}

TextStyle kAppLblTinyRegularWhite(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).scaffoldBackgroundColor);
}

TextStyle kAppLblBoldFont(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'bold', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblTinyStrokeRegular(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).colorScheme.tertiary, decoration: TextDecoration.lineThrough);
}

Widget kAppSysCacheMarker() {
  return const SizedBox(height: 42, width: 7, child: SizedBox(height: 9, width: 25));
}

TextStyle kAppLblTinyBoldOffer(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'bold', color: ThemeProvider.offerTagTextColorLight);
}

TextStyle kAppLblTinyStrokeFontRegular(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).colorScheme.tertiary, decoration: TextDecoration.lineThrough);
}

TextStyle kAppLblTinyMediumFontSemi(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'semibold', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblSmallFontBold(BuildContext context, {String color = 'primary'}) {
  return TextStyle(fontFamily: 'bold', color: color == 'primary' ? Theme.of(context).primaryColor : Theme.of(context).canvasColor, fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize));
}

TextStyle kAppLblSmallFontBoldCart(BuildContext context) {
  return TextStyle(fontFamily: 'bold', color: Theme.of(context).scaffoldBackgroundColor, fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize));
}

TextStyle kAppLblTinyFontBoldCart(BuildContext context) {
  return TextStyle(fontFamily: 'medium', color: Theme.of(context).scaffoldBackgroundColor, fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize));
}

TextStyle kAppLblSmallFontSemiBold(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'semibold', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblLargeFontBold(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.bodyLarge?.fontSize), fontFamily: 'bold', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblMediumFontSemiBold(BuildContext context, {String color = 'regular'}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'semibold', color: color == 'regular' ? Theme.of(context).canvasColor : Theme.of(context).primaryColor);
}

TextStyle kAppLblMediumFontSemiBoldWhite(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'semibold', color: Theme.of(context).scaffoldBackgroundColor);
}

TextStyle kAppThemeToggleLblRegular(BuildContext context, {bool isDarkTheme = false}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'regular', color: isDarkTheme ? ThemeProvider.darkBackgroundColor : ThemeProvider.backgroundColor);
}

TextStyle kAppThemeToggleLblBold(BuildContext context, {bool isDarkTheme = false}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'bold', color: isDarkTheme ? ThemeProvider.darkBackgroundColor : ThemeProvider.backgroundColor);
}

TextStyle kAppLblOrderTileRegular(BuildContext context) {
  return TextStyle(fontFamily: 'regular', color: Theme.of(context).scaffoldBackgroundColor, fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize));
}

TextStyle kAppLblOrderTileBold(BuildContext context) {
  return TextStyle(fontFamily: 'bold', color: Theme.of(context).scaffoldBackgroundColor, fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize));
}

TextStyle kAppLblOrderTileSemiBold(BuildContext context) {
  return TextStyle(fontFamily: 'semibold', color: Theme.of(context).scaffoldBackgroundColor, fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize));
}

Center kAppCenterCircularProgress(BuildContext context, {String color = 'primary', double strokeWidth = 2.0}) {
  return Center(
    child: CircularProgressIndicator(color: color == 'primary' ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor, strokeWidth: strokeWidth),
  );
}

Container kAppCircularProgress(BuildContext context, {String color = 'primary', double strokeWidth = 2.0, double? width, double? height, double? padding}) {
  return Container(
    width: width!,
    height: height!,
    padding: EdgeInsets.all(padding!),
    child: CircularProgressIndicator(color: color == 'primary' ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor, strokeWidth: strokeWidth),
  );
}

ButtonStyle kAppElevatedButtonStyle(BuildContext context, {required Color disabledColor, required Color bgColor, required Color foreColor, required double height}) {
  return ElevatedButton.styleFrom(
    minimumSize: Size.fromHeight(height),
    disabledBackgroundColor: disabledColor,
    backgroundColor: bgColor,
    foregroundColor: foreColor,
    textStyle: TextStyle(fontFamily: 'semibold', fontSize: kFontFromTheme(context, Theme.of(context).textTheme.bodyMedium?.fontSize)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  );
}

ButtonStyle kAppElevatedButtonOutlineStyle(BuildContext context, {required Color disabledColor, required Color bgColor, required Color foreColor, required Color borderColor, required double height}) {
  return ElevatedButton.styleFrom(
    foregroundColor: foreColor,
    backgroundColor: bgColor,
    shadowColor: bgColor,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
      side: BorderSide(width: 1, color: borderColor),
    ),
  );
}

SizedBox kAppSpacerVertical({double height = 0}) {
  return SizedBox(height: height);
}

SizedBox kAppSpacerHorizontal({double width = 0}) {
  return SizedBox(width: width);
}

ButtonStyle kAppTextButtonColoredStyle(BuildContext context, {required Color bgColor, required Color foreColor}) {
  return TextButton.styleFrom(
    backgroundColor: bgColor,
    foregroundColor: foreColor,
    textStyle: TextStyle(fontFamily: 'semibold', fontSize: kFontFromTheme(context, Theme.of(context).textTheme.bodyMedium?.fontSize)),
  );
}

ButtonStyle kAppTextButtonTransparentStyle(BuildContext context, {required Color foreColor}) {
  return TextButton.styleFrom(
    foregroundColor: foreColor,
    textStyle: TextStyle(fontFamily: 'semibold', fontSize: kFontFromTheme(context, Theme.of(context).textTheme.bodyMedium?.fontSize)),
  );
}

InputDecoration kAppInputDecoration(BuildContext context, {Icon? prefixIcon, Icon? suffixIcon, bool? haveSuffixIcon = false, VoidCallback? onPressed, required String? lblText, String? errText}) {
  return InputDecoration(
    prefixIcon: prefixIcon,
    iconColor: Theme.of(context).canvasColor,
    prefixIconColor: Theme.of(context).canvasColor,
    suffixIconColor: Theme.of(context).canvasColor,
    suffixIcon: haveSuffixIcon == false ? suffixIcon : IconButton(onPressed: onPressed, icon: suffixIcon!),
    labelText: lblText,
    errorText: errText,
    labelStyle: TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'medium', color: Theme.of(context).canvasColor),
    errorStyle: TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'medium'),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).canvasColor)),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).canvasColor),
      borderRadius: BorderRadius.circular(5),
    ),
  );
}

ButtonStyle kAppOutlineButtonStyle(BuildContext context, {String? foreColor = 'primary', double? radius}) {
  return OutlinedButton.styleFrom(
    textStyle: TextStyle(fontFamily: 'semibold', fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize)),
    foregroundColor: foreColor == 'primary' ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius!)),
  );
}

Container kAppLine(BuildContext context) {
  return Container(height: 1, width: double.infinity, color: Colors.grey[300]);
}

TextStyle kAppTitleStyle(BuildContext context) {
  return TextStyle(fontFamily: 'bold', fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), color: Theme.of(context).canvasColor);
}

TextStyle kAppTitleSubStyle(BuildContext context) {
  return TextStyle(fontFamily: 'regular', fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), color: Theme.of(context).canvasColor);
}

String kAppPriceFormat(double price) {
  return GlobalSettings.globalCurrencySide == 'left' ? '${GlobalSettings.globalCurrencySymbol}$price' : '$price${GlobalSettings.globalCurrencySymbol}';
}

Widget kAppFoodType(String type, {double height = 15, double width = 15}) {
  if (type == 'veg') {
    return Image.asset(AssetsUrl.imageURL.foodVegType, height: height, width: width);
  } else if (type == 'nonveg') {
    return Image.asset(AssetsUrl.imageURL.foodNonVegType, height: height, width: width);
  } else if (type == 'vegan') {
    return Image.asset(AssetsUrl.imageURL.foodVeganType, height: height, width: width);
  }
  return SizedBox(height: height, width: width);
}

Row kAppFoodRatingStar(double rating, {double iconSize = 10}) {
  return Row(
    children: [
      Icon(rating >= 1 ? Icons.star_rate_rounded : Icons.star_border_rounded, size: iconSize, color: rating >= 1 ? ThemeProvider.ratingStarIconColorLight : ThemeProvider.greyColorBorder),
      Icon(rating >= 2 ? Icons.star_rate_rounded : Icons.star_border_rounded, size: iconSize, color: rating >= 2 ? ThemeProvider.ratingStarIconColorLight : ThemeProvider.greyColorBorder),
      Icon(rating >= 3 ? Icons.star_rate_rounded : Icons.star_border_rounded, size: iconSize, color: rating >= 3 ? ThemeProvider.ratingStarIconColorLight : ThemeProvider.greyColorBorder),
      Icon(rating >= 4 ? Icons.star_rate_rounded : Icons.star_border_rounded, size: iconSize, color: rating >= 4 ? ThemeProvider.ratingStarIconColorLight : ThemeProvider.greyColorBorder),
      Icon(rating >= 5 ? Icons.star_rate_rounded : Icons.star_border_rounded, size: iconSize, color: rating >= 5 ? ThemeProvider.ratingStarIconColorLight : ThemeProvider.greyColorBorder),
    ],
  );
}

Padding kAppTitleDivider(BuildContext context, String title, double padding) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: padding),
    child: Row(
      children: <Widget>[
        const Expanded(child: Divider(thickness: 0.5)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(title, style: kAppLblMediumFontSemiBold(context)),
        ),
        const Expanded(child: Divider(thickness: 0.5)),
      ],
    ),
  );
}

String kAppTrimWord(String text, int length) {
  return text.length > length ? '${text.substring(0, length)}...' : text;
}

String kAppDDTranslate(BuildContext context, String key) {
  switch (key) {
    case 'dd_male':
      return AppLocalizations.of(context)!.dd_male;
    case 'dd_female':
      return AppLocalizations.of(context)!.dd_female;
    case 'dd_other':
      return AppLocalizations.of(context)!.dd_other;
    case 'dd_not_disclose':
      return AppLocalizations.of(context)!.dd_not_disclose;
    case 'dd_accident':
      return AppLocalizations.of(context)!.dd_accident;
    case 'dd_incident':
      return AppLocalizations.of(context)!.dd_incident;
    default:
      return key;
  }
}

String kAppPageName(BuildContext context, String slug) {
  switch (slug) {
    case 'about-us':
      return AppLocalizations.of(context)!.about;
    case 'privacy-policy':
      return AppLocalizations.of(context)!.privacy_policy;
    case 'terms-and-conditions':
      return AppLocalizations.of(context)!.terms_and_conditions;
    case 'refund-policy':
      return AppLocalizations.of(context)!.refund_policy;
    case 'shipping-policy':
      return AppLocalizations.of(context)!.shipping_policy;
    case 'cancellation-policy':
      return AppLocalizations.of(context)!.cancellation_policy;
    case 'cookies':
      return AppLocalizations.of(context)!.cookies;
    case 'help':
      return AppLocalizations.of(context)!.help;
    case 'frequently-asked-questions':
      return AppLocalizations.of(context)!.frequently_asked_questions;
    case 'dining-frequently-asked-questions':
      return AppLocalizations.of(context)!.dining_help;
    default:
      return AppLocalizations.of(context)!.about;
  }
}

double kFontFromTheme(BuildContext context, double? size) {
  if (size == null) return 14;

  double width = MediaQuery.of(context).size.width;

  if (width < 360) return size * 0.9;
  if (width < 400) return size;
  if (width < 600) return size * 1.05;

  return size * 1.1;
}
