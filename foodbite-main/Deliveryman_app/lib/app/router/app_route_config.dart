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

import 'package:driver/app/presentation/pages/account/edit_profile/edit_profile_view.dart';
import 'package:driver/app/presentation/pages/account/feedback_form/feedback_form_view.dart';
import 'package:driver/app/presentation/pages/account/report_emergency/report_emergency_view.dart';
import 'package:driver/app/presentation/pages/account/reviews/review_list_view.dart';
import 'package:driver/app/presentation/pages/account/setting_section/@core/setting_section_view.dart';
import 'package:driver/app/presentation/pages/account/setting_section/account_setting/@core/account_setting_view.dart';
import 'package:driver/app/presentation/pages/account/setting_section/account_setting/account_setting_alert_setting/account_setting_alert_setting_view.dart';
import 'package:driver/app/presentation/pages/account/setting_section/account_setting/account_setting_change_email/account_setting_change_email_view.dart';
import 'package:driver/app/presentation/pages/account/setting_section/account_setting/account_setting_change_mobile/account_setting_change_mobile_view.dart';
import 'package:driver/app/presentation/pages/account/setting_section/account_setting/account_setting_delete_account/@core/account_setting_delete_account_view.dart';
import 'package:driver/app/presentation/pages/account/setting_section/account_setting/account_setting_delete_account/account_setting_delete_account_submit/account_setting_delete_account_submit_view.dart';
import 'package:driver/app/presentation/pages/account/setting_section/account_setting/account_setting_update_password/account_setting_update_password_view.dart';
import 'package:driver/app/presentation/pages/account/sounds/sounds_view.dart';
import 'package:driver/app/presentation/pages/app_pages/app_pages_view.dart';
import 'package:driver/app/presentation/pages/auth/register_request/@core/register_request_view.dart';
import 'package:driver/app/presentation/pages/auth/register_request/register_success/register_request_success_view.dart';
import 'package:driver/app/presentation/pages/auth/reset_password/@core/reset_password_view.dart';
import 'package:driver/app/presentation/pages/chats/@core/chat_card_view.dart';
import 'package:driver/app/presentation/pages/chats/chat_list/chat_list_view.dart';
import 'package:driver/app/presentation/pages/chats/messages/message_view.dart';
import 'package:driver/app/presentation/pages/chats/support_chat/support_chat_view.dart';
import 'package:driver/app/presentation/pages/extra_pages/connection_view.dart';
import 'package:driver/app/presentation/pages/extra_pages/maintenance_view.dart';
import 'package:driver/app/presentation/pages/extra_pages/not_found_view.dart';
import 'package:driver/app/presentation/pages/extra_pages/server_error_view.dart';
import 'package:driver/app/presentation/pages/feeds/completed_order_detail/completed_order_detail_view.dart';
import 'package:driver/app/presentation/pages/feeds/notification_list/notification_list_view.dart';
import 'package:driver/app/presentation/pages/feeds/order_details/order_details_view.dart';
import 'package:driver/app/presentation/pages/feeds/order_list/order_list_view.dart';
import 'package:driver/app/presentation/pages/intro/intro_view.dart';
import 'package:driver/app/presentation/pages/auth/@core/login_view.dart';
import 'package:driver/app/presentation/pages/modals/new_order/new_order_view.dart';
import 'package:driver/app/presentation/pages/splash/splash_view.dart';
import 'package:driver/app/presentation/pages/tabs/tabs_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String introRoute = '/intro';
  static const String loginRoute = '/login';
  static const String resetPasswordRoute = '/reset_password';
  static const String bottomTabRoute = '/bottom_tabs';
  static const String maintenanceRoute = '/maintenance';
  static const String internetConnectionRoute = '/internet_connection';
  static const String serverErrorRoute = '/server_error';
  static const String notFoundErrorRoute = '/not_found_error';
  static const String notificationSoundRoute = '/notification_sound';
  static const String newOrderRoute = '/new_order';
  static const String orderListRoute = '/order_list';
  static const String orderDetailRoute = '/order_detail';
  static const String appPageRoute = '/app_pages';
  static const String editProfileRoute = '/edit_profile';
  static const String reviewListRoute = '/review_list';
  static const String chatCardRoute = '/chat_card';
  static const String chatListRoute = '/chat_list';
  static const String messagesRoute = '/messages';
  static const String supportChatRoute = '/support_Chat';
  static const String feedbackRoute = '/feedback_form';
  static const String reportEmergencyRoute = '/report_emergency';
  static const String registerRequestRoute = '/register_request';
  static const String registerRequestSuccessRoute = '/register_request_success';
  static const String settingSectionRoute = '/setting_section';
  static const String appSettingRoute = '/app_settings';
  static const String accountSettingAlertSettingRoute = '/account_setting_alert_setting';
  static const String accountSettingChangeEmailRoute = '/account_setting_change_email';
  static const String accountSettingChangeMobileRoute = '/account_setting_change_mobile';
  static const String accountSettingUpdatePasswordRoute = '/account_setting_update_password';
  static const String accountSettingDeleteAccountRoute = '/account_setting_delete_account';
  static const String accountSettingDeleteAccountSubmitRoute = '/account_setting_delete_account_submit';
  static const String notificationRoute = '/notification_list';
  static const String completedOrderDetailRoute = '/completed_order_detail';

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case initialRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          },
        );

      case introRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const IntroScreen();
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

      case notificationSoundRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const SoundScreen();
          },
        );

      case newOrderRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return NewOrderModalScreen(orderFrom: args[0].toString().isNotEmpty && args[0] != '' ? args[0] : 'online');
          },
        );

      case orderListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const OrderListScreen();
          },
        );

      case orderDetailRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return OrderDetailScreen(orderId: args[0], orderNo: args[1].toString());
          },
        );

      case appPageRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return AppPageScreen(slug: args[0]);
          },
        );

      case editProfileRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const EditProfileScreen();
          },
        );

      case reviewListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const ReviewListScreen();
          },
        );

      case chatCardRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const ChatCardScreen();
          },
        );

      case chatListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const ChatListScreen();
          },
        );

      case messagesRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return MessageScreen(receiverId: args[0], name: args[1]);
          },
        );

      case supportChatRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return SupportChatScreen(type: args[0], typeId: args[1]);
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

      case registerRequestRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const RegisterRequestScreen();
          },
        );

      case registerRequestSuccessRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const RegisterRequestSuccessScreen();
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

      case notificationRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const NotificationListScreen();
          },
        );

      case completedOrderDetailRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return CompletedOrderDetailScreen(id: args[0], orderNo: args[1].toString());
          },
        );

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}
