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
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/config/global_settings.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

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

TextStyle kAppLblBoldFont(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'bold', color: Theme.of(context).canvasColor);
}

String kAppAddressTitle(BuildContext context, int num) {
  if (num == 0) {
    return AppLocalizations.of(context)!.home;
  } else if (num == 1) {
    return AppLocalizations.of(context)!.work;
  } else if (num == 2) {
    return AppLocalizations.of(context)!.hotel;
  } else if (num == 3) {
    return AppLocalizations.of(context)!.other;
  }
  return AppLocalizations.of(context)!.other;
}

TextStyle kAppLblMediumFontSemiBoldWhite(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'semibold', color: Theme.of(context).scaffoldBackgroundColor);
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

TextStyle kAppLblSmallFontRegular(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblSmallFontBold(BuildContext context, {String color = 'primary'}) {
  return TextStyle(fontFamily: 'bold', color: color == 'primary' ? Theme.of(context).primaryColor : Theme.of(context).canvasColor, fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize));
}

TextStyle kAppLblSmallFontBoldCart(BuildContext context) {
  return TextStyle(fontFamily: 'bold', color: Theme.of(context).scaffoldBackgroundColor, fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize));
}

TextStyle kAppLblSmallFontSemiBold(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'semibold', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblLargeFontBold(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.bodyLarge?.fontSize), fontFamily: 'bold', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblMediumFontSemiBold(BuildContext context, {String color = 'regular'}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'semibold', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblTinyFontRegular(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblTinyBoldOffer(BuildContext context) {
  return TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.offerTagTextColorLight);
}

String kAppTiffinSubscriptionTime(String time) {
  if (time == 'week') {
    return '7';
  } else if (time == 'fortnight') {
    return '15';
  } else if (time == 'month') {
    return '30';
  }
  return '7';
}

String kAppSupportChatType(BuildContext context, String type) {
  if (type == 'orders') {
    return AppLocalizations.of(context)!.orders;
  } else if (type == 'dining') {
    return AppLocalizations.of(context)!.dining_booking;
  } else if (type == 'tiffin_subscription') {
    return AppLocalizations.of(context)!.tiffin_subscription;
  } else if (type == 'complaints') {
    return AppLocalizations.of(context)!.complaints;
  } else if (type == 'reports') {
    return AppLocalizations.of(context)!.reports;
  }
  return AppLocalizations.of(context)!.orders;
}

TextStyle kAppCouponLblTinyFontRegular(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).colorScheme.inverseSurface);
}

TextStyle kAppLblTinyFontRegularChip(BuildContext context, {String color = 'regular'}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: color == 'regular' ? Theme.of(context).canvasColor : Theme.of(context).primaryColor);
}

TextStyle kAppLblTinyFontRegularLight(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).scaffoldBackgroundColor);
}

TextStyle kAppLblTinyFontBold(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'bold', color: Theme.of(context).canvasColor);
}

TextStyle kAppLblTinyStrokeRegular(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).colorScheme.tertiary, decoration: TextDecoration.lineThrough);
}

TextStyle kAppLblTinyFontBoldGuest(BuildContext context) {
  return TextStyle(fontFamily: 'medium', color: Theme.of(context).scaffoldBackgroundColor, fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize));
}

Widget kAppSysCacheMarker() {
  return const SizedBox(height: 42, width: 7, child: SizedBox(height: 9, width: 25));
}

TextStyle kAppLblTinyStrokeFontRegular(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).colorScheme.tertiary, decoration: TextDecoration.lineThrough);
}

TextStyle kAppLblTinyMediumFontSemi(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'semibold', color: Theme.of(context).canvasColor);
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
    // padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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

String kAppPriceFormat(double price) {
  return GlobalSettings.globalCurrencySide == 'left' ? '${GlobalSettings.globalCurrencySymbol}$price' : '$price${GlobalSettings.globalCurrencySymbol}';
}

String kAppPriceFormatString(String price) {
  return GlobalSettings.globalCurrencySide == 'left' ? '${GlobalSettings.globalCurrencySymbol}$price' : '$price${GlobalSettings.globalCurrencySymbol}';
}

String kAppPriceLbl(String lbl) {
  return GlobalSettings.globalCurrencySide == 'left' ? '${GlobalSettings.globalCurrencySymbol} $lbl' : '$lbl ${GlobalSettings.globalCurrencySymbol}';
}

String kAppTrimWord(String text, int length) {
  return text.length > length ? '${text.substring(0, length)}...' : text;
}

TextStyle kAppLblTinyRegularWhite(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'regular', color: Theme.of(context).scaffoldBackgroundColor);
}

TextStyle kAppLblTinyFontBoldCart(BuildContext context) {
  return TextStyle(fontFamily: 'medium', color: Theme.of(context).scaffoldBackgroundColor, fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize));
}

TextStyle kAppThemeToggleLblBold(BuildContext context, {bool isDarkTheme = false}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'bold', color: isDarkTheme ? ThemeProvider.darkBackgroundColor : ThemeProvider.backgroundColor);
}

TextStyle kAppThemeToggleLblRegular(BuildContext context, {bool isDarkTheme = false}) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelMedium?.fontSize), fontFamily: 'regular', color: isDarkTheme ? ThemeProvider.darkBackgroundColor : ThemeProvider.backgroundColor);
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

TextStyle kAppInvoiceRegular(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'invoice_regular', color: ThemeProvider.darkBackgroundColor);
}

TextStyle kAppInvoiceSemiBold(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'invoice_semi_bold', color: ThemeProvider.darkBackgroundColor);
}

TextStyle kAppInvoiceBold(BuildContext context) {
  return TextStyle(fontSize: kFontFromTheme(context, Theme.of(context).textTheme.labelSmall?.fontSize), fontFamily: 'invoice_bold', color: ThemeProvider.darkBackgroundColor);
}

String kAppWeekName(BuildContext context, String key) {
  switch (key) {
    case 'sunday':
      return AppLocalizations.of(context)!.sunday;
    case 'monday':
      return AppLocalizations.of(context)!.monday;
    case 'tuesday':
      return AppLocalizations.of(context)!.tuesday;
    case 'wednesday':
      return AppLocalizations.of(context)!.wednesday;
    case 'thursday':
      return AppLocalizations.of(context)!.thursday;
    case 'friday':
      return AppLocalizations.of(context)!.friday;
    case 'saturday':
      return AppLocalizations.of(context)!.saturday;
    default:
      return key;
  }
}

String kAppStockType(BuildContext context, String key) {
  switch (key) {
    case 'unlimited_stock':
      return AppLocalizations.of(context)!.unlimited_stock;
    case 'limited_stock':
      return AppLocalizations.of(context)!.limited_stock;
    case 'daily_limit':
      return AppLocalizations.of(context)!.daily_limit;
    default:
      return key;
  }
}

String kAppDiscountType(BuildContext context, String key) {
  switch (key) {
    case 'percentage_lbl':
      return AppLocalizations.of(context)!.percentage_lbl;
    case 'amount_lbl':
      return AppLocalizations.of(context)!.amount_lbl;
    default:
      return key;
  }
}

String kAppCategoryName(BuildContext context, String key) {
  switch (key) {
    case 'custom_category_permission':
      return AppLocalizations.of(context)!.custom_category_permission;
    case 'main_category':
      return AppLocalizations.of(context)!.main_category;
    default:
      return key;
  }
}

String kAppFoodPrefName(BuildContext context, String key) {
  switch (key) {
    case 'none':
      return AppLocalizations.of(context)!.none;
    case 'veg':
      return AppLocalizations.of(context)!.veg;
    case 'non_veg':
      return AppLocalizations.of(context)!.non_veg;
    case 'vegan':
      return AppLocalizations.of(context)!.vegan;
    default:
      return key;
  }
}

String kAppVariationTypeName(BuildContext context, String key) {
  switch (key) {
    case 'single_selection':
      return AppLocalizations.of(context)!.single_selection;
    case 'multi_selection':
      return AppLocalizations.of(context)!.multi_selection;
    default:
      return key;
  }
}

String kAppVariationRequiredTypeName(BuildContext context, String key) {
  switch (key) {
    case 'yes_lbl':
      return AppLocalizations.of(context)!.yes_lbl;
    case 'no_title':
      return AppLocalizations.of(context)!.no_title;
    default:
      return key;
  }
}

String kAppTiffinKind(BuildContext context, String key) {
  switch (key) {
    case 'breakfast':
      return AppLocalizations.of(context)!.breakfast;
    case 'lunch':
      return AppLocalizations.of(context)!.lunch;
    case 'dinner':
      return AppLocalizations.of(context)!.dinner;
    default:
      return key;
  }
}

String kAppDDTranslate(BuildContext context, String key) {
  switch (key) {
    case 'dd_amount':
      return AppLocalizations.of(context)!.dd_amount;
    case 'dd_percentage':
      return AppLocalizations.of(context)!.dd_percentage;
    case 'dd_breakfast':
      return AppLocalizations.of(context)!.dd_breakfast;
    case 'dd_lunch':
      return AppLocalizations.of(context)!.dd_lunch;
    case 'dd_dinner':
      return AppLocalizations.of(context)!.dd_dinner;
    case 'dd_yes':
      return AppLocalizations.of(context)!.dd_yes;
    case 'dd_no':
      return AppLocalizations.of(context)!.dd_no;
    case 'dd_passport':
      return AppLocalizations.of(context)!.dd_passport;
    case 'dd_driving_license':
      return AppLocalizations.of(context)!.dd_driving_license;
    case 'dd_nic':
      return AppLocalizations.of(context)!.dd_nic;
    case 'dd_male':
      return AppLocalizations.of(context)!.dd_male;
    case 'dd_female':
      return AppLocalizations.of(context)!.dd_female;
    case 'dd_other':
      return AppLocalizations.of(context)!.dd_other;
    case 'dd_not_disclose':
      return AppLocalizations.of(context)!.dd_not_disclose;
    case 'dd_report_accident':
      return AppLocalizations.of(context)!.dd_report_accident;
    case 'dd_report_incident':
      return AppLocalizations.of(context)!.dd_report_incident;
    case 'dd_ongoing_orders':
      return AppLocalizations.of(context)!.dd_ongoing_orders;
    case 'dd_completed_orders':
      return AppLocalizations.of(context)!.dd_completed_orders;
    case 'dd_percent_price':
      return AppLocalizations.of(context)!.dd_percent_price;
    case 'dd_amount_price':
      return AppLocalizations.of(context)!.dd_amount_price;
    case 'dd_guest_customer':
      return AppLocalizations.of(context)!.dd_guest_customer;
    case 'dd_regular_customer':
      return AppLocalizations.of(context)!.dd_regular_customer;
    case 'dd_home_delivery':
      return AppLocalizations.of(context)!.dd_home_delivery;
    case 'dd_self_pickup':
      return AppLocalizations.of(context)!.dd_self_pickup;
    case 'dd_week_days':
      return AppLocalizations.of(context)!.dd_week_days;
    case 'dd_fortnight_days':
      return AppLocalizations.of(context)!.dd_fortnight_days;
    case 'dd_month_days':
      return AppLocalizations.of(context)!.dd_month_days;
    case 'dd_breakfast_food':
      return AppLocalizations.of(context)!.dd_breakfast_food;
    case 'dd_lunch_food':
      return AppLocalizations.of(context)!.dd_lunch_food;
    case 'dd_dinner_food':
      return AppLocalizations.of(context)!.dd_dinner_food;
    case 'dd_min':
      return AppLocalizations.of(context)!.dd_min;
    case 'dd_hour':
      return AppLocalizations.of(context)!.dd_hour;
    case 'dd_yes_home_delivery':
      return AppLocalizations.of(context)!.dd_yes_home_delivery;
    case 'dd_no_home_delivery':
      return AppLocalizations.of(context)!.dd_no_home_delivery;
    case 'dd_yes_takeaway':
      return AppLocalizations.of(context)!.dd_yes_takeaway;
    case 'dd_no_takeaway':
      return AppLocalizations.of(context)!.dd_no_takeaway;
    case 'dd_yes_schedule_order':
      return AppLocalizations.of(context)!.dd_yes_schedule_order;
    case 'dd_no_schedule_order':
      return AppLocalizations.of(context)!.dd_no_schedule_order;
    case 'dd_customer':
      return AppLocalizations.of(context)!.dd_customer;
    case 'dd_deliveryman':
      return AppLocalizations.of(context)!.dd_deliveryman;
    case 'dd_select':
      return AppLocalizations.of(context)!.dd_select;
    default:
      return key;
  }
}

String kAppTabTranslate(BuildContext context, String keyName, int value) {
  final Map<String, String> keyValueMap = {
    "tab_new_order": "New (##dynamic##)",
    "tab_preparing_order": "Preparing (##dynamic##)",
    "tab_ready_order": "Ready (##dynamic##)",
    "tab_picked_order": "Pickd up (##dynamic##)",
    "tab_ongoing_order": "Ongoing (##dynamic##)",
    "tab_delivered_order": "Delivered (##dynamic##)",
    "tab_rejected_order": "Rejected (##dynamic##)",
    "tab_accepted_order": "Accepted (##dynamic##)",
    "tab_completed_order": "Completed (##dynamic##)",
    "tab_cancelled_order": "Cancelled (##dynamic##)",
    "tab_refunded_order": "Refunded (##dynamic##)",
    "tab_partial_refund_order": "Partially Refunded (##dynamic##)",
    "tab_all_food": "All (##dynamic##)",
    "tab_rejected_food": "Item Rejected (##dynamic##)",
    "tab_hold_food": "On Hold (##dynamic##)",
    "tab_photo_rejected_food": "Photo Rejected (##dynamic##)",
    "tab_quality_rejected_food": "Quality Rejected (##dynamic##)",
    "tab_size_rejected_food": "Size Rejected (##dynamic##)",
    "tab_hidden_food": "Hidden (##dynamic##)",
  };
  String? key = keyValueMap.entries.firstWhere((e) => e.value.toLowerCase() == keyName.toLowerCase(), orElse: () => const MapEntry('', '')).key;
  String translateTabKey(BuildContext context, String keyName) {
    switch (key) {
      case "tab_new_order":
        return AppLocalizations.of(context)!.tab_new_order;
      case "tab_preparing_order":
        return AppLocalizations.of(context)!.tab_preparing_order;
      case "tab_ready_order":
        return AppLocalizations.of(context)!.tab_ready_order;
      case "tab_picked_order":
        return AppLocalizations.of(context)!.tab_picked_order;
      case "tab_ongoing_order":
        return AppLocalizations.of(context)!.tab_ongoing_order;
      case "tab_delivered_order":
        return AppLocalizations.of(context)!.tab_delivered_order;
      case "tab_rejected_order":
        return AppLocalizations.of(context)!.tab_rejected_order;
      case "tab_accepted_order":
        return AppLocalizations.of(context)!.tab_accepted_order;
      case "tab_completed_order":
        return AppLocalizations.of(context)!.tab_completed_order;
      case "tab_cancelled_order":
        return AppLocalizations.of(context)!.tab_cancelled_order;
      case "tab_refunded_order":
        return AppLocalizations.of(context)!.tab_refunded_order;
      case "tab_partial_refund_order":
        return AppLocalizations.of(context)!.tab_partial_refund_order;
      case "tab_all_food":
        return AppLocalizations.of(context)!.tab_all_food;
      case "tab_rejected_food":
        return AppLocalizations.of(context)!.tab_rejected_food;
      case "tab_hold_food":
        return AppLocalizations.of(context)!.tab_hold_food;
      case "tab_photo_rejected_food":
        return AppLocalizations.of(context)!.tab_photo_rejected_food;
      case "tab_quality_rejected_food":
        return AppLocalizations.of(context)!.tab_quality_rejected_food;
      case "tab_size_rejected_food":
        return AppLocalizations.of(context)!.tab_size_rejected_food;
      case "tab_hidden_food":
        return AppLocalizations.of(context)!.tab_hidden_food;
      default:
        return keyName;
    }
  }

  final localizedMessage = translateTabKey(context, keyName);
  final String dynamicMessage = localizedMessage.replaceAll('##dynamic##', value.toString());
  return dynamicMessage;
}

String kAppExpenseKey(BuildContext context, String key) {
  switch (key) {
    case 'expense_all':
      return AppLocalizations.of(context)!.expense_all;
    case 'expense_order_product':
      return AppLocalizations.of(context)!.expense_order_product;
    case 'expense_pos_product_discount':
      return AppLocalizations.of(context)!.expense_pos_product_discount;
    case 'expense_table_product_discount':
      return AppLocalizations.of(context)!.expense_table_product_discount;
    case 'expense_pos_extra_discount':
      return AppLocalizations.of(context)!.expense_pos_extra_discount;
    case 'expense_table_extra_discount':
      return AppLocalizations.of(context)!.expense_table_extra_discount;
    case 'expense_order_coupon':
      return AppLocalizations.of(context)!.expense_order_coupon;
    case 'expense_dining_coupon':
      return AppLocalizations.of(context)!.expense_dining_coupon;
    case 'expense_dining_booking':
      return AppLocalizations.of(context)!.expense_dining_booking;
    case 'expense_order_refund':
      return AppLocalizations.of(context)!.expense_order_refund;
    case 'expense_others':
      return AppLocalizations.of(context)!.expense_others;
    case 'expense_total':
      return AppLocalizations.of(context)!.expense_total;
    case 'expense_pos_order_product_discount':
      return AppLocalizations.of(context)!.expense_pos_order_product_discount;
    case 'expense_table_order_product':
      return AppLocalizations.of(context)!.expense_table_order_product;
    case 'expense_pos_order_extra':
      return AppLocalizations.of(context)!.expense_pos_order_extra;
    case 'expense_table_order_extra':
      return AppLocalizations.of(context)!.expense_table_order_extra;
    case 'expense_order_refund_expense':
      return AppLocalizations.of(context)!.expense_order_refund_expense;
    case 'others':
      return AppLocalizations.of(context)!.others;
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
