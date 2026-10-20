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
import 'package:waiter/app/presentation/pages/account/edit_profile/edit_profile_view.dart';
import 'package:waiter/app/presentation/pages/account/feedback_form/feedback_form_view.dart';
import 'package:waiter/app/presentation/pages/account/report_emergency/report_emergency_view.dart';
import 'package:waiter/app/presentation/pages/account/setting_section/@core/setting_section_view.dart';
import 'package:waiter/app/presentation/pages/account/setting_section/account_setting/@core/account_setting_view.dart';
import 'package:waiter/app/presentation/pages/account/setting_section/account_setting/account_setting_alert_setting/account_setting_alert_setting_view.dart';
import 'package:waiter/app/presentation/pages/account/setting_section/account_setting/account_setting_change_email/account_setting_change_email_view.dart';
import 'package:waiter/app/presentation/pages/account/setting_section/account_setting/account_setting_change_mobile/account_setting_change_mobile_view.dart';
import 'package:waiter/app/presentation/pages/account/setting_section/account_setting/account_setting_delete_account/@core/account_setting_delete_account_view.dart';
import 'package:waiter/app/presentation/pages/account/setting_section/account_setting/account_setting_delete_account/account_setting_delete_account_submit/account_setting_delete_account_submit_view.dart';
import 'package:waiter/app/presentation/pages/account/setting_section/account_setting/account_setting_update_password/account_setting_update_password_view.dart';
import 'package:waiter/app/presentation/pages/app_pages/app_pages_view.dart';
import 'package:waiter/app/presentation/pages/auth/login/@core/login_view.dart';
import 'package:waiter/app/presentation/pages/auth/reset_password/@core/reset_password_view.dart';
import 'package:waiter/app/presentation/pages/extra_pages/connection_view.dart';
import 'package:waiter/app/presentation/pages/extra_pages/maintenance_view.dart';
import 'package:waiter/app/presentation/pages/extra_pages/not_found_view.dart';
import 'package:waiter/app/presentation/pages/extra_pages/server_error_view.dart';
import 'package:waiter/app/presentation/pages/splash/splash_view.dart';
import 'package:waiter/app/presentation/pages/table_orders/table_ongoing_item/table_ongoing_item_view.dart';
import 'package:waiter/app/presentation/pages/table_orders/table_order_confirm_items/table_order_confirm_items_view.dart';
import 'package:waiter/app/presentation/pages/table_orders/table_order_dashboard/table_order_dashboard_view.dart';
import 'package:waiter/app/presentation/pages/table_orders/table_order_search_food/table_order_search_food_view.dart';
import 'package:waiter/app/presentation/pages/tabs/tabs_view.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String maintenanceRoute = '/maintenance';
  static const String internetConnectionRoute = '/internet_connection';
  static const String serverErrorRoute = '/server_error';
  static const String notFoundErrorRoute = '/not_found_error';
  static const String loginRoute = '/login';
  static const String resetPasswordRoute = '/reset_password';
  static const String bottomTabRoute = '/bottom_tabs';
  static const String appPageRoute = '/app_pages';
  static const String feedbackRoute = '/feedback_form';
  static const String reportEmergencyRoute = '/report_emergency';
  static const String tableOrderDashboardRoute = '/table_order_dashboard';
  static const String tableOrderSearchFoodRoute = '/table_order_search_food';
  static const String tableOrderConfirmItemRoute = '/table_order_confirm_item';
  static const String tableOngoingOrderItemRoute = '/table_ongoing_order_item';
  static const String editProfileRoute = '/edit_profile';
  static const String settingSectionRoute = '/setting_section';
  static const String appSettingRoute = '/app_settings';
  static const String accountSettingAlertSettingRoute = '/account_setting_alert_setting';
  static const String accountSettingChangeEmailRoute = '/account_setting_change_email';
  static const String accountSettingChangeMobileRoute = '/account_setting_change_mobile';
  static const String accountSettingUpdatePasswordRoute = '/account_setting_update_password';
  static const String accountSettingDeleteAccountRoute = '/account_setting_delete_account';
  static const String accountSettingDeleteAccountSubmitRoute = '/account_setting_delete_account_submit';

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case initialRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          },
        );

      case maintenanceRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return MaintenanceScreen(businessEmail: args[0], businessMobile: args[1]);
          },
        );

      case internetConnectionRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const ConnectionScreen();
          },
        );

      case serverErrorRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const ServerErrorScreen();
          },
        );

      case loginRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        );

      case resetPasswordRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const ResetPasswordScreen();
          },
        );

      case bottomTabRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return AppBottomTabScreen(tabIndex: args.isNotEmpty && args[0] != null && args[0] != '' ? args[0] : 0);
          },
        );

      case appPageRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return AppPageScreen(slug: args[0]);
          },
        );

      case feedbackRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const FeedbackFormScreen();
          },
        );

      case reportEmergencyRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const ReportEmergencyScreen();
          },
        );

      case tableOrderDashboardRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return TableOrderDashboardScreen(tableNumber: args[0], tableId: args[1]);
          },
        );

      case tableOrderSearchFoodRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return TableOrderSearchFoodScreen(tableNumber: args[0], tableId: args[1]);
          },
        );

      case tableOrderConfirmItemRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return TableOrderConfirmItemScreen(tableNumber: args[0], tableId: args[1]);
          },
        );

      case tableOngoingOrderItemRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return TableOngoingItemScreen(tableNumber: args[0], tableId: args[1]);
          },
        );

      case editProfileRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const EditProfileScreen();
          },
        );

      case settingSectionRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const SettingSectionScreen();
          },
        );

      case appSettingRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const AccountSettingScreen();
          },
        );

      case accountSettingAlertSettingRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const AccountSettingAlertSettingScreen();
          },
        );

      case accountSettingUpdatePasswordRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const AccountSettingUpdatePasswordScreen();
          },
        );

      case accountSettingChangeEmailRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const AccountSettingChangeEmailScreen();
          },
        );

      case accountSettingChangeMobileRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const AccountSettingChangeMobileScreen();
          },
        );

      case accountSettingDeleteAccountRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const AccountSettingDeleteAccountScreen();
          },
        );

      case accountSettingDeleteAccountSubmitRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return AccountSettingDeleteAccountSubmitScreen(reason: args[0]);
          },
        );

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}
