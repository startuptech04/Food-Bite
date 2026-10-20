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
import 'package:vendor/app/presentation/pages/account/@core/account_view.dart';
import 'package:vendor/app/presentation/pages/account/chats/@core/chat_card_view.dart';
import 'package:vendor/app/presentation/pages/account/chats/chat_messages/chat_messages_view.dart';
import 'package:vendor/app/presentation/pages/account/chats/support_chat/support_chat_view.dart';
import 'package:vendor/app/presentation/pages/account/coupons/@core/coupons_list_tab_view.dart';
import 'package:vendor/app/presentation/pages/account/coupons/dining_coupon/dialog_dining_coupon/dialog_dining_coupon_view.dart';
import 'package:vendor/app/presentation/pages/account/coupons/order_coupon/dialog_order_coupon/dialog_order_coupon_view.dart';
import 'package:vendor/app/presentation/pages/account/deliveryman_list/@core/deliveryman_list_view.dart';
import 'package:vendor/app/presentation/pages/account/dining_management/dining_guests_count/dining_guest_count_view.dart';
import 'package:vendor/app/presentation/pages/account/dining_management/@core/dining_pre_bookings_view.dart';
import 'package:vendor/app/presentation/pages/account/dining_management/dining_schedules/@core/dining_schedules_view.dart';
import 'package:vendor/app/presentation/pages/account/dining_management/dining_setting/dining_setting_view.dart';
import 'package:vendor/app/presentation/pages/account/edit_profile/edit_profile_view.dart';
import 'package:vendor/app/presentation/pages/account/edit_restaurant/edit_restaurant_view.dart';
import 'package:vendor/app/presentation/pages/account/expense_reports/expense_reports_view.dart';
import 'package:vendor/app/presentation/pages/account/feedback_form/feedback_form_view.dart';
import 'package:vendor/app/presentation/pages/account/food_taxation/@core/food_taxation_view.dart';
import 'package:vendor/app/presentation/pages/account/kitchen_credentials/@core/kitchen_credentials_list_view.dart';
import 'package:vendor/app/presentation/pages/account/menu_and_photos/menu_and_photos_view.dart';
import 'package:vendor/app/presentation/pages/account/notification_list/notification_list_view.dart';
import 'package:vendor/app/presentation/pages/account/outlets/@core/outlet_list_view.dart';
import 'package:vendor/app/presentation/pages/account/report_emergency/report_emergency_view.dart';
import 'package:vendor/app/presentation/pages/account/review_list/review_list_view.dart';
import 'package:vendor/app/presentation/pages/account/schedules/@core/schedules_view.dart';
import 'package:vendor/app/presentation/pages/account/setting_section/@core/setting_section_view.dart';
import 'package:vendor/app/presentation/pages/account/setting_section/account_setting/@core/account_setting_view.dart';
import 'package:vendor/app/presentation/pages/account/setting_section/account_setting/account_setting_alert_setting/account_setting_alert_setting_view.dart';
import 'package:vendor/app/presentation/pages/account/setting_section/account_setting/account_setting_change_email/account_setting_change_email_view.dart';
import 'package:vendor/app/presentation/pages/account/setting_section/account_setting/account_setting_change_mobile/account_setting_change_mobile_view.dart';
import 'package:vendor/app/presentation/pages/account/setting_section/account_setting/account_setting_delete_account/@core/account_setting_delete_account_view.dart';
import 'package:vendor/app/presentation/pages/account/setting_section/account_setting/account_setting_delete_account/account_setting_delete_account_submit/account_setting_delete_account_submit_view.dart';
import 'package:vendor/app/presentation/pages/account/setting_section/account_setting/account_setting_update_password/account_setting_update_password_view.dart';
import 'package:vendor/app/presentation/pages/account/sounds/sounds_view.dart';
import 'package:vendor/app/presentation/pages/account/subscription_package/@core/subscription_package_view.dart';
import 'package:vendor/app/presentation/pages/account/subscription_package/subscription_package_payment/subscription_package_payment_view.dart';
import 'package:vendor/app/presentation/pages/account/table_orders/@core/table_order_list_view.dart';
import 'package:vendor/app/presentation/pages/account/table_orders/table_complete_order/table_complete_order_view.dart';
import 'package:vendor/app/presentation/pages/account/table_orders/table_list/table_list_view.dart';
import 'package:vendor/app/presentation/pages/account/table_orders/table_order_detail/table_order_detail_view.dart';
import 'package:vendor/app/presentation/pages/account/tiffin_subscription/@core/tiffin_subscription_list_view.dart';
import 'package:vendor/app/presentation/pages/account/tiffin_subscription/dialog_tiffin_subscription/dialog_tiffin_subscription_view.dart';
import 'package:vendor/app/presentation/pages/account/tiffin_subscription/tiffin_subscription_purchaser/@core/tiffin_subscription_purchaser_view.dart';
import 'package:vendor/app/presentation/pages/account/tiffin_subscription/tiffin_subscription_purchaser/tiffin_subscription_purchase_history_detail/tiffin_subscription_purchas_history_detail_view.dart';
import 'package:vendor/app/presentation/pages/account/waiter_list/@core/waiter_list_view.dart';
import 'package:vendor/app/presentation/pages/account/wallet/@core/wallet_view.dart';
import 'package:vendor/app/presentation/pages/account/wallet/cash_in_hand/@core/cash_in_hand_view.dart';
import 'package:vendor/app/presentation/pages/account/wallet/wallet_detail/@core/wallet_detail_view.dart';
import 'package:vendor/app/presentation/pages/app_pages/app_pages_view.dart';
import 'package:vendor/app/presentation/pages/auth/register_request/@core/register_request_view.dart';
import 'package:vendor/app/presentation/pages/auth/register_request/register_request_payment/register_request_payment_view.dart';
import 'package:vendor/app/presentation/pages/auth/register_request/register_request_success/register_request_success_view.dart';
import 'package:vendor/app/presentation/pages/auth/reset_password/@core/reset_password_view.dart';
import 'package:vendor/app/presentation/pages/business/@core/business_view.dart';
import 'package:vendor/app/presentation/pages/business/custom_date_insight/custom_order_date_insight/custom_order_date_insight_view.dart';
import 'package:vendor/app/presentation/pages/business/custom_date_insight/custom_pos_date_insight/custom_pos_date_insight_view.dart';
import 'package:vendor/app/presentation/pages/business/custom_date_insight/custom_table_order_date_insight/custom_table_order_date_insight_view.dart';
import 'package:vendor/app/presentation/pages/campaign/@core/campaign_view.dart';
import 'package:vendor/app/presentation/pages/extra_pages/connection_view.dart';
import 'package:vendor/app/presentation/pages/extra_pages/maintenance_view.dart';
import 'package:vendor/app/presentation/pages/extra_pages/not_found_view.dart';
import 'package:vendor/app/presentation/pages/extra_pages/server_error_view.dart';
import 'package:vendor/app/presentation/pages/intro/intro_view.dart';
import 'package:vendor/app/presentation/pages/auth/@core/login_view.dart';
import 'package:vendor/app/presentation/pages/menu/@core/menu_view.dart';
import 'package:vendor/app/presentation/pages/menu/media_file_list/media_file_list_view.dart';
import 'package:vendor/app/presentation/pages/menu/search_menu/search_menu_view.dart';
import 'package:vendor/app/presentation/pages/orders/@core/orders_view.dart';
import 'package:vendor/app/presentation/pages/orders/order_detail/order_detail_view.dart';
import 'package:vendor/app/presentation/pages/pos_management/pos_order_detail/pos_order_detail_view.dart';
import 'package:vendor/app/presentation/pages/pos_management/pos_order_list/pos_order_list_view.dart';
import 'package:vendor/app/presentation/pages/pos_management/pos_place_order/pos_place_order_view.dart';
import 'package:vendor/app/presentation/pages/pos_management/pos_search_food/pos_search_food_view.dart';
import 'package:vendor/app/presentation/pages/splash/splash_view.dart';
import 'package:vendor/app/presentation/pages/tabs/tabs_view.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String introRoute = '/intro';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String resetPasswordRoute = '/reset_password';
  static const String bottomTabRoute = '/bottom_tabs';
  static const String orderListRoute = '/order_list';
  static const String orderDetailRoute = '/order_detail';
  static const String menuListRoute = '/menu_list';
  static const String businessRoute = '/business';
  static const String campaignRoute = '/campaign';
  static const String accountRoute = '/account';
  static const String maintenanceRoute = '/maintenance';
  static const String internetConnectionRoute = '/internet_connection';
  static const String serverErrorRoute = '/server_error';
  static const String notFoundErrorRoute = '/not_found_error';
  static const String schedulesRoute = '/schedules';
  static const String notificationListRoute = '/notificaiton_list';
  static const String notificationSoundRoute = '/notification_sound';
  static const String diningPreBookingRoute = '/dining_pre_bookings';
  static const String diningScheduleRoute = '/dining_schedule';
  static const String diningGuestCountRoute = '/dining_guest_count';
  static const String diningSettingRoute = '/dining_settings';
  static const String chatListRoute = '/chat_list';
  static const String chatMessageRoute = '/chat_messages';
  static const String appPageRoute = '/app_pages';
  static const String feedbackRoute = '/feedback_form';
  static const String reportEmergencyRoute = '/report_emergency';
  static const String foodTaxationRoute = '/food_taxation';
  static const String reviewListRoute = '/review_list';
  static const String editRestaurantDetailRoute = '/edit_restaurant_detail';
  static const String deliverymanListRoute = '/deliveryman_list';
  static const String couponRoute = '/coupons';
  static const String manageOrderCouponRoute = '/manage_order_coupon';
  static const String manageDiningCouponRoute = '/manage_dining_coupon';
  static const String tiffinSubscriptionRoute = '/tiffin_subscription_list';
  static const String manageTiffinSubscriptionRoute = '/manage_tiffin_subscription';
  static const String tiffinSubscriptionPurchaserHistoryRoute = '/tiffin_subscription_purchaser_history';
  static const String tiffinSubscriptionPurchaseHistoryDetailRoute = '/tiffin_subscription_purchase_history_detail';
  static const String searchMenuRoute = '/search_menu';
  static const String mediaFileListRoute = '/media_file_list';
  static const String supportChatRoute = '/support_chat';
  static const String menuAndPhotoRoute = '/menu_and_photos';
  static const String editProfileRoute = '/edit_profile';
  static const String waiterListRoute = '/waiter_list';
  static const String kitchenCredentialListRoute = '/kitchen_credentials';
  static const String outletListRoute = '/outlet_list';
  static const String tableOrderRoute = '/table_orders';
  static const String completeTableOrderRoute = '/complete_table_order';
  static const String tableOrderDetailRoute = '/table_order_Detail';
  static const String tableListRoute = '/table_list';
  static const String walletRoute = '/wallet';
  static const String cashInHandRoute = '/cash_in_hand';
  static const String walletDetailRoute = '/wallet_detail';
  static const String posSearchFoodRoute = '/pos_search_food';
  static const String posPlaceOrderRoute = '/pos_place_order';
  static const String posOrderListRoute = '/pos_order_list';
  static const String posOrderDetailRoute = '/pos_order_detail';
  static const String customOrderInsightRoute = '/custom_order_insight';
  static const String customPosOrderInsightRoute = '/custom_pos_order_insight';
  static const String customTableOrderInsightRoute = '/custom_table_order_insight';
  static const String registerRequestSuccessRoute = '/register_request_success';
  static const String registerRequestMakePaymentRoute = '/register_request_make_payment';
  static const String subscriptionPackageRoute = '/subscription_package';
  static const String subscriptionPackagePaymentRoute = '/subscription_package_payment';
  static const String expenseReportRoutes = '/expense_report';
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

      case registerRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const RegisterRequestScreen();
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
            return AppBottomTabScreen(tabIndex: args.isNotEmpty && args[0] != null && args[0] != '' ? args[0] : 2);
          },
        );

      case menuListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const MenuScreen();
          },
        );

      case businessRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const BusinessScreen();
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
            return OrderDetailScreen(id: args[0], orderNo: args[1]);
          },
        );

      case campaignRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const CampaignScreen();
          },
        );

      case accountRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const AccountScreen();
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

      case schedulesRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const ScheduleScreen();
          },
        );

      case notificationListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const NotificationListScreen();
          },
        );

      case notificationSoundRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const SoundScreen();
          },
        );

      case diningPreBookingRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const DiningPreBookingsScreen();
          },
        );

      case diningScheduleRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const DiningSchedulesScreen();
          },
        );

      case diningGuestCountRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const DiningGuestCountScreen();
          },
        );

      case diningSettingRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const DiningSettingScreen();
          },
        );

      case chatListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const ChatCardScreen();
          },
        );

      case chatMessageRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return ChatMessageScreen(name: args[0], receiverId: args[1]);
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

      case foodTaxationRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const FoodTaxationScreen();
          },
        );

      case reviewListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const ReviewListScreen();
          },
        );

      case editRestaurantDetailRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const EditRestaurantScreen();
          },
        );

      case deliverymanListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const DeliverymanListScreen();
          },
        );

      case couponRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const CouponsListTabScreen();
          },
        );

      case manageOrderCouponRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return DialogOrderCouponScreen(isNew: args[0], model: args[1]);
          },
        );

      case manageDiningCouponRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return DialogDiningCouponScreen(isNew: args[0], model: args[1]);
          },
        );

      case tiffinSubscriptionRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const TiffinSubscriptionListScreen();
          },
        );

      case manageTiffinSubscriptionRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return DialogTiffinSubscriptionScreen(isNew: args[0], model: args[1]);
          },
        );

      case tiffinSubscriptionPurchaserHistoryRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return TiffinSubscriptionPurchaserScreen(tiffinId: args[0]);
          },
        );

      case tiffinSubscriptionPurchaseHistoryDetailRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return TiffinSubscriptionPurchasHistoryDetailScreen(purchaseId: args[0]);
          },
        );

      case searchMenuRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return SearchMenuScreen(customCategory: args[0]);
          },
        );

      case mediaFileListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const MediaFileListScreen();
          },
        );

      case supportChatRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return SupportChatScreen(type: args[0], typeId: args[1]);
          },
        );

      case menuAndPhotoRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const MenuAndPhotoScreen();
          },
        );

      case editProfileRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const EditProfileScreen();
          },
        );

      case waiterListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const WaiterListScreen();
          },
        );

      case kitchenCredentialListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const KitchenCredentialsListScreen();
          },
        );
      //

      case outletListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const OutletListScreen();
          },
        );

      case tableOrderRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const TableOrderListScreen();
          },
        );

      case completeTableOrderRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return TableCompleteOrderScreen(tableNumber: args[0], tableId: args[1]);
          },
        );

      case tableOrderDetailRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return TableOrderDetailScreen(orderId: args[0]);
          },
        );

      case tableListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const TableListScreen();
          },
        );

      case walletRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const WalletScreen();
          },
        );

      case cashInHandRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const CashInHandScreen();
          },
        );

      case walletDetailRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const WalletDetailScreen();
          },
        );

      case posPlaceOrderRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const PosPlaceOrderScreen();
          },
        );

      case posSearchFoodRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const PosSearchFoodScreen();
          },
        );

      case posOrderListRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const PosOrderListScreen();
          },
        );

      case posOrderDetailRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return PosOrderDetailScreen(orderId: args[0]);
          },
        );

      case customOrderInsightRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const CustomOrderDateInsightScreen();
          },
        );

      case customPosOrderInsightRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const CustomPosDateInsightScreen();
          },
        );

      case customTableOrderInsightRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const CustomTableOrderDateInsightScreen();
          },
        );

      case registerRequestSuccessRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const RegisterRequestSuccessScreen();
          },
        );

      case registerRequestMakePaymentRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return RegisterRequestPaymentScreen(paymentId: args[0]);
          },
        );

      case subscriptionPackageRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const SubscriptionPackageScreen();
          },
        );

      case subscriptionPackagePaymentRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return SubscriptionPackagePaymentScreen(paymentId: args[0]);
          },
        );

      case expenseReportRoutes:
        return MaterialPageRoute(
          builder: (context) {
            return const ExpenseReportScreen();
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

      case accountSettingChangeEmailRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const AccountSettingChangeEmailScreen();
          },
        );

      case accountSettingUpdatePasswordRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const AccountSettingUpdatePasswordScreen();
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

      case accountSettingAlertSettingRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const AccountSettingAlertSettingScreen();
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
