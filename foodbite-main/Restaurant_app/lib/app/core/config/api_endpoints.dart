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

class ApiEndPoints {
  static V1Request v1request = const V1Request();
}

class V1Request {
  const V1Request();
  String get getVendorSettings => 'v1/public/getVendorSettings/';
  String get getPageContent => 'v1/public/app_pages/getContent/';
  // Auth Request //
  String get vendorLogin => 'v1/auth/vendor/login/';
  String get vendorLoginWithPhonePassword => 'v1/auth/vendor/login_cmp/';
  String get vendorLoginWithEmailOtSendVerification => 'v1/auth/vendor/login_eo_verification/';
  String get verifyOTP => 'v1/auth/verifyOTP/';
  String get resendOTP => 'v1/auth/resendOTP/';
  String get webOTPVerification => 'v1/public/verification/otp/';
  String get vendorLoginWithEmailOtp => 'v1/auth/vendor/login_eo/';
  String get vendorLoginWithPhoneOTPSendVerification => 'v1/auth/vendor/login_po_verification/';
  String get vendorLoginWithPhoneOTPVerified => 'v1/auth/vendor/login_po/';
  String get vendorLoginWithPhoneOTPFirebaseVerified => 'v1/auth/vendor/login_po_firebase/';
  String get forgotPasswordWithEmail => 'v1/auth/forgot-password-email/';
  String get forgotPasswordWithPhone => 'v1/auth/forgot-password-phone/';
  String get updatePassword => 'v1/auth/reset-password';
  String get updatePasswordFirebase => 'v1/auth/reset-password-firebase';
  String get refreshToken => 'v1/auth/refresh-tokens-app/';
  String get logout => 'v1/auth/logout/';
  String get checkRegisterStatus => 'v1/auth/check-register-status/';
  String get vendorLoginWithGoogleAccount => 'v1/auth/vendor/login_with_google_account/';
  String get vendorLoginWithFacebookAccount => 'v1/auth/vendor/login_with_facebook_account/';
  // Auth Request //

  // Addon's Request //
  String get getMyAddons => 'v1/vendor/addons/getMyAddons/';
  String get addAddons => 'v1/vendor/addons/save/';
  String get updateAddons => 'v1/vendor/addons/update/';
  String get deleteAddons => 'v1/vendor/addons/delete/';
  // Addon's Request //

  // Categories Request //
  String get getAllCategories => 'v1/vendor/vendor_category/getMyCategories/';
  String get updateVendorCategories => 'v1/vendor/vendor_category/update/';
  String get deleteVendorCategories => 'v1/vendor/vendor_category/delete/';
  String get createVendorCategories => 'v1/vendor/vendor_category/save/';
  String get getVendorCategories => 'v1/vendor/vendor_category/getAllMyCategory/';
  // Categories Request //

  // Media Request //
  String get getVendorMedia => 'v1/vendor/media/getVendorMedia/';
  String get uploadImageFile => 'v1/file/uploadImage/';
  String get uploadPublicImageFile => 'v1/public/uploadImage/';
  String get removeImageFile => 'v1/vendor/media/deleteMyImage/';
  // Media Request //

  // Sub Categories Request //
  String get getAllSubCategories => 'v1/vendor/vendor_sub_category/getMyCategories/';
  String get updateVendorSubCategories => 'v1/vendor/vendor_sub_category/update/';
  String get deleteVendorSubCategories => 'v1/vendor/vendor_sub_category/delete/';
  String get createVendorSubCategories => 'v1/vendor/vendor_sub_category/save/';
  // Sub Categories Request //

  // Restaurant Campaigns Request //
  String get getRestaurantCampaignNearMe => 'v1/vendor/restaurant_campaign/near_me/';
  String get leaveRestaurantCampaign => 'v1/vendor/restaurant_campaign/leave/';
  String get joinRestaurantCampaign => 'v1/vendor/restaurant_campaign/join_request/';
  // Restuarant Campaigns Request //

  // Dining Campaign Request //
  String get getDiningCampaignNearMe => 'v1/vendor/dining_campaign/near_me/';
  String get leaveDiningCampaign => 'v1/vendor/dining_campaign/leave/';
  String get joinDiningCampaign => 'v1/vendor/dining_campaign/join_request/';
  // Dining Campaign Request //

  // Food Campaigns Request //
  String get getFoodCampaignNearMe => 'v1/vendor/food_campaign/near_me/';
  String get getFoodCampaignDetail => 'v1/vendor/food_campaign/getDetails/';
  String get leaveFoodCampaign => 'v1/vendor/food_campaign/leave/';
  String get joinFoodCampaign => 'v1/vendor/food_campaign/join_request/';
  // Food Campaigns Request //

  // Foods Request //
  String get saveFood => 'v1/vendor/foods/save/';
  String get updateFood => 'v1/vendor/foods/update/';
  String get getCustomSubCategories => 'v1/vendor/vendor_sub_category/getActiveByCategoryId/';
  String get getSubCategoriesByCategoryId => 'v1/vendor/sub_category/getByCategoryId/';
  String get getAllMainActiveCategories => 'v1/vendor/foods/getAllMainActiveCategories/';
  String get getAllMyAddons => 'v1/vendor/foods/getAllMyAddonsList/';
  String get getFoodList => 'v1/vendor/foods/getMyFoodApp/';
  String get getFoodInfo => 'v1/vendor/foods/getFoodInfoVendorApp/';
  String get updateFoodMetaInfo => 'v1/vendor/foods/updateMetaInfo/';
  String get searchMenu => 'v1/vendor/foods/searchMenu/';
  String get getAllTaxation => 'v1/vendor/food_taxation/getAllMyTaxation/';
  // Foods Request //

  // Slots Request //
  String get getMySlots => 'v1/vendor/getMySlots/';
  String get updateMySlots => 'v1/vendor/updateMySlots/';
  // Slots Request //

  // Orders Route //
  String get getOrderList => 'v1/vendor/orders/getVendorOrders/';
  String get prepareOrder => 'v1/vendor/orders/prepareOrder/';
  String get acceptScheduleOrder => 'v1/vendor/orders/acceptScheduleOrder/';
  String get orderReady => 'v1/vendor/orders/orderReady/';
  String get activeDrivers => 'v1/vendor/drivers/activeDriver/';
  String get handoverOrderToDriver => 'v1/vendor/orders/handover_to_driver/';
  String get handoverOrderToCustomer => 'v1/vendor/orders/handover_to_customer/';
  String get rejectOrder => 'v1/vendor/orders/rejectOrder/';
  String get fetchDriverNearYou => 'v1/vendor/orders/fetchDriverNearToOrder/';
  String get assignDriverToOrderManually => 'v1/vendor/orders/assignDriverOrderVendor/';
  String get getOrderDetail => 'v1/vendor/orders/vendorOrderDetails/';
  String get callCustomerFromOrder => 'v1/vendor/orders/callCustomer/';
  String get callDeliverymanFromOrder => 'v1/vendor/orders/callDeliveryman/';
  String get orderSumary => 'v1/vendor/orders/summary/';
  String get orderInvoice => 'v1/vendor/orders/invoice/';
  String get printInvoice => 'v1/vendor/orders/print_invoice/';
  // Orders Route //

  // Cancellation Reasons List Route //
  String get cancellationReasonList => 'v1/vendor/cancellation/restaurant/';
  // Cancellation Reasons List Route //

  // Push Notification Token Request //
  String get savePushNotificationToken => 'v1/public/pushTokens/save/';
  String get updatePushNotificationToken => 'v1/public/pushTokens/update/';
  // Push Notification Token Request //

  // Restaurant Extra Detail Request //
  String get getGuestAvailability => 'v1/vendor/restaurant_extra_detail/getGuestAvailability/';
  String get saveGuestAvailability => 'v1/vendor/restaurant_extra_detail/saveGuestAvailability/';
  String get getMyDiningSchedule => 'v1/vendor/restaurant_extra_detail/getMyDiningSchedule/';
  String get saveDiningSchedule => 'v1/vendor/restaurant_extra_detail/saveDiningSchedule/';
  String get getVendorDiningInformation => 'v1/vendor/dining/getVendorDiningInformation/';
  String get getDiningCategories => 'v1/vendor/dining/getDiningCategories/';
  String get updateDiningInformation => 'v1/vendor/dining/updateDiningInformation/';
  // Restaurant Extra Detail Request //

  // Dining Booking Routes ///
  String get diningBookingList => 'v1/vendor/dining_booking/list/';
  String get acceptDiningBooking => 'v1/vendor/dining_booking/accept/';
  String get diningBookingCancellationReason => 'v1/vendor/dining_booking/cancellation/restaurant/';
  String get rejectDiningBooking => 'v1/vendor/dining_booking/reject/';
  String get completeDiningBooking => 'v1/vendor/dining_booking/complete/';
  String get diningBookingInformation => 'v1/vendor/dining_booking/detail/';
  String get diningBookingCallCustomer => 'v1/vendor/dining_booking/callCustomer/';
  // Dining Booking Routes ///

  // Chat Messages Routes //
  String get fetchChatMessages => 'v1/vendor/chat_room/fetchMessages/';
  String get sendChatMessage => 'v1/vendor/chat_room/sendMessage/';
  String get chatList => 'v1/vendor/chat_room/list/';
  String get getChatConversion => 'v1/vendor/chat_room/conversion/';
  // Chat Messages Routes //

  // Support Chat Message Routes //
  String get fetchSupportChatMessages => 'v1/vendor/support_chat_room/fetchMessages/';
  String get supportChatList => 'v1/vendor/support_chat_room/list/';
  String get sendSupportChatMessage => 'v1/vendor/support_chat_room/sendMessage/';
  String get getSupportChatConversion => 'v1/vendor/support_chat_room/conversion/';
  // Support Chat Message Routes //

  // Feedback & Report Emergecy Routes //
  String get saveFeedbackForm => 'v1/public/feedback_form/save/';
  String get saveReportEmergencyForm => 'v1/public/report_emergency/save/';
  // Feedback & Report Emergecy Routes //

  // Food Taxation Routes //
  String get saveFoodTaxation => 'v1/vendor/food_taxation/save/';
  String get getMyFoodTaxation => 'v1/vendor/food_taxation/getByRestaurant/';
  String get updateFoodTaxation => 'v1/vendor/food_taxation/update/';
  String get deleteFoodTaxation => 'v1/vendor/food_taxation/delete/';
  // Food Taxation Routes //

  // Review Rating Routes //
  String get reviewList => 'v1/vendor/restaurant/reviews/';
  // Review Rating Routes //

  // Deliveryman Routes //
  String get deliverymanList => 'v1/vendor/driver/getMyDriver/';
  String get updateDeliverymanStatus => 'v1/vendor/driver/updateStatus/';
  String get initialDeliverymanData => 'v1/vendor/driver/getBasicData/';
  String get saveDeliveryman => 'v1/vendor/driver/save/';
  String get getDeliverymanInfo => 'v1/vendor/driver/getById/';
  String get updateDeliveryman => 'v1/vendor/driver/update/';
  // Deliveryman Routes //

  // Coupon Management Routes //
  String get getOrderCouponList => 'v1/vendor/coupons/get';
  String get saveOrderCoupon => 'v1/vendor/coupons/request_new/';
  String get getOrderCouponInfo => 'v1/vendor/coupons/getInfo/';
  String get updateOrderCouponMetaInfo => 'v1/vendor/coupons/updateMeta/';
  String get deleteOrderCoupon => 'v1/vendor/coupons/delete/';
  String get updateOrderCoupon => 'v1/vendor/coupons/update/';
  String get getDiningCouponList => 'v1/vendor/dining_coupon/vendorCoupons/';
  String get saveDiningCoupon => 'v1/vendor/dining_coupon/request_new/';
  String get updateDiningCouponMetaInfo => 'v1/vendor/dining_coupon/updateMeta/';
  String get deleteDiningCoupn => 'v1/vendor/dining_coupon/delete/';
  String get getDiningCouponInfo => 'v1/vendor/dining_coupon/getInfo/';
  String get updateDiningCoupon => 'v1/vendor/dining_coupon/update/';
  // Coupon Management Routes //

  // Tiffin Subscription Routes //
  String get getMySubscriptionPackages => 'v1/vendor/tiffin_packages/getMyPackages/';
  String get getTiffinSubscriptionFoodList => 'v1/vendor/tiffin_packages/get_basic/';
  String get saveTiffinSubscription => 'v1/vendor/tiffin_packages/create/';
  String get getTiffinSubscriptionInfo => 'v1/vendor/tiffin_packages/details/';
  String get updateTiffinSubscription => 'v1/vendor/tiffin_packages/update/';
  String get updateTiffinSubscriptionStatus => 'v1/vendor/tiffin_packages/updateStatus/';
  String get deleteTiffinSubscription => 'v1/vendor/tiffin_packages/delete/';

  String get getTiffinSubscriptionPurchaserHistory => 'v1/vendor/tiffin_packages/vendorTiffinSubscriptionPurchased/';
  String get getTiffinSubscriptionPurchaseHistoryDetail => 'v1/vendor/tiffin_packages/userPurchasedTiffinSubscriptionInfo/';
  // Tiffin Subscription Routes //

  // Call Routes//
  String get callCustomer => 'v1/vendor/customer/call/';
  // Call Routes//

  // Complaints Routes //
  String get getOrderDetailForComplaints => 'v1/vendor/orders/forComplaint/';
  String get saveOrderComplaints => 'v1/vendor/complaints/save/';
  // Complaints Routes //

  // Menu And Photots Routes //
  String get getMenuAndPhotos => 'v1/vendor/restaurant_extra_detail/menu/';
  String get updateMenuAndPhotos => 'v1/vendor/restaurant_extra_detail/updateMenu/';
  // Menu And Photots Routes //

  // Update Restaurant Detail Routes //
  String get getRestaurantDetailForUpdate => 'v1/vendor/restaurant/edit_detail/';
  String get getActiveCuisine => 'v1/public/restaurant/activeCuisine/';
  String get getActiveRestaurantType => 'v1/public/restaurant/activeType/';
  String get getActiveRestaurantFacility => 'v1/public/restaurant/activeFacility/';
  String get updateRestaurantDetail => 'v1/vendor/restaurant/updateDetail/';
  String get temporaryCloseRestaurant => 'v1/vendor/restaurant/temporaryClose/';
  String get reOpenTemporaryRestaurant => 'v1/vendor/restaurant/reOpenTemporary/';
  // Update Restaurant Detail Routes //

  // Profile Routes //
  String get getMyProfile => 'v1/vendor/profile/user/';
  String get updateMyProfile => 'v1/vendor/profile/update/';
  // Profile Routes //

  // Waiter Routes //
  String get createWaiter => 'v1/vendor/waiter/save/';
  String get waiterList => 'v1/vendor/waiter/getMyWaiter/';
  String get waiterInfo => 'v1/vendor/waiter/getById/';
  String get updateWaiterInfo => 'v1/vendor/waiter/updateWaiterInfo/';
  String get updateWaiterStatus => 'v1/vendor/waiter/updateWaiterStatus/';
  // Waiter Routes //

  // Kitchen Owner Routes //
  String get createKitchenOwner => 'v1/vendor/kitchen_owner/save/';
  String get kitchenOwnerList => 'v1/vendor/kitchen_owner/list/';
  String get kitchenOwnerInfo => 'v1/vendor/kitchen_owner/info/';
  String get updateKitchenOwnerInfo => 'v1/vendor/kitchen_owner/update_detail/';
  String get updateKitchenOwnerStatus => 'v1/vendor/kitchen_owner/update_kitchen_status/';
  // Kitchen Owner Routes //

  // Outlet Routes //
  String get outletList => 'v1/vendor/outlet/getMyOutlets/';
  String get updateOutletStatus => 'v1/vendor/outlet/updateStatus/';
  String get getBasicDetailForNewOutlet => 'v1/vendor/outlet/getBasicDataForNewOutletForApp/';
  String get saveOutlet => 'v1/vendor/outlet/save/';
  String get getOutletInfo => 'v1/vendor/outlet/getByIdForApp/';
  String get updateOutlet => 'v1/vendor/outlet/update/';
  // Outlet Routes //

  // Table Routes //
  String get getRestaurantTableList => 'v1/vendor/restaurant_table/getList/';
  String get updateRestaurantTableStatus => 'v1/vendor/restaurant_table/updateStatus/';
  String get deleteRestaurantTable => 'v1/vendor/restaurant_table/delete/';
  String get saveRestaurantTable => 'v1/vendor/restaurant_table/save/';
  String get updateRestaurantTable => 'v1/vendor/restaurant_table/update/';
  // Table Routes //

  // Wallet Routes //
  String get walletDetail => 'v1/vendor/restaurant/wallet/';
  String get walletTransactionList => 'v1/vendor/wallet/getWalletTransaction/';
  String get cashInHandHistoryList => 'v1/vendor/cashInHandHistory/getHistory/';
  String get collectedCashInHandHistoryList => 'v1/vendor/collectedCashInHandHistory/getHistory/';
  String get posAndTableOrderCommissionList => 'v1/vendor/cashInHandHistory/posAndTableOrderCommission/';
  // Wallet Routes //

  // Payout Method Routes //
  String get payoutMethodList => 'v1/vendor/payoutMethod/list/';
  String get savePayoutMethod => 'v1/vendor/payoutMethod/createPayoutMethod/';
  String get getMyPayoutMethodList => 'v1/vendor/payoutMethod/myPayoutList/';
  String get deletePayoutMethod => 'v1/vendor/payoutMethod/deleteMethod/';
  String get payoutMethodDetail => 'v1/vendor/payoutMethod/detail/';
  String get updatePayoutMethodDetail => 'v1/vendor/payoutMethod/updatePayoutMethod/';
  String get updatePayoutDefaultStatus => 'v1/vendor/payoutMethod/updateDefault/';
  // Payout Method Routes //

  // Withdrawal Routes //
  String get withdrawalDetail => 'v1/vendor/wallet/withdrawalDetail/';
  String get withdrawalRequest => 'v1/vendor/wallet/requestWithdrawal/';
  String get withdrawalHistory => 'v1/vendor/wallet/withdrawalHistory/';
  // Withdrawal Routes //

  // POS Routes //
  String get posInitialData => 'v1/vendor/restaurant/posData/';
  String get posInitialFoodSearch => 'v1/vendor/restaurant/posFoodInitialSearch/';
  String get posFoodSearch => 'v1/vendor/restaurant/posFoodSearch/';
  String get posOrderSetting => 'v1/vendor/restaurant/posOrderSettings/';
  String get posPlaceOrder => 'v1/vendor/restaurant/posPlaceOrder/';
  String get posOrderList => 'v1/vendor/restaurant/posOrders/';
  String get posOrderDetail => 'v1/vendor/restaurant/posOrderDetail/';
  String get printPOSOrderInvoice => 'v1/vendor/restaurant/pos_invoice_print/';
  // POS Routes //

  // Table Order Routes //
  String get onGoingTableOrders => 'v1/vendor/table_order/ongoing/';
  String get onGoingTableOrderDetail => 'v1/vendor/table_order/ongoingOrderDetail/';
  String get deleteTableOrderCartItem => 'v1/vendor/table_order/deleteTableOrderCartItem/';
  String get completeTableOrder => 'v1/vendor/table_order/completeTableOrder/';
  String get completedTableOrderList => 'v1/vendor/table_order/completedTableOrderList/';
  String get tableOrderDetail => 'v1/vendor/table_order/tableOrderDetail/';
  String get printTableOrderInvoice => 'v1/vendor/table_order/invoice_print/';
  String get tableQrDetail => 'v1/vendor/restaurant_table/qr_table_detail/';
  // Table Order Routes //

  // Business Insight Routes //
  String get orderBusinessInsight => 'v1/vendor/business/insight/';
  String get orderBusinessInsightCustom => 'v1/vendor/business/insight/custom/';
  String get posBusinessInsight => 'v1/vendor/pos/insight/';
  String get posBusinessInsightCustom => 'v1/vendor/pos/insight/custom/';
  String get tableOrderBusinessInsight => 'v1/vendor/table_order/insight/';
  String get tableOrderBusinessInsightCustom => 'v1/vendor/table_order/insight/custom/';
  // Business Insight Routes //

  String get localityByCity => 'v1/public/localities_from_city/';

  // Register Restaurant Routes //
  String get registerRequestBasicDetail => 'v1/public/register/getBasicDataRestaurantRequest';
  String get registerRequest => 'v1/public/restaurant_joining/request/';
  // Register Restaurant Routes //

  // Payment Routes //
  String get makePayment => 'v1/public/payments/makePayment/';
  // Payment Routes //

  // Subscription Routes //
  String get vendorSubscriptionStatus => 'v1/vendor/restaurant/subscription_status/';
  String get subscriptionInfo => 'v1/vendor/restaurant/subscription/';
  String get renewSubscription => 'v1/vendor/restaurant/renew_subscription/';
  // Subscription Routes //

  // Expense Routes //
  String get addExpense => 'v1/vendor/expense/save/';
  String get expenseInitialData => 'v1/vendor/reports/expenseInitial/';
  String get expenseList => 'v1/vendor/reports/expense/';
  // Expense Routes //

  // Account Setting Routes //
  String get updateAccountPassword => 'v1/vendor/account_setting/update_password/';
  String get updateAccountEmail => 'v1/vendor/account_setting/update_email/';
  String get updateAccountEmailAfterVerification => 'v1/vendor/account_setting/update_email_after_verification/';
  String get updateAccountMobileNumber => 'v1/vendor/account_setting/update_mobile_number/';
  String get updateAccountMobileNumberAfterVerification => 'v1/vendor/account_setting/update_mobile_number_after_verification/';
  String get updateAccountMobileNumberAfterFirebaseVerification => 'v1/vendor/account_setting/update_mobile_number_after_firebase_verification/';
  String get restaurantNotificationSetting => 'v1/vendor/account_setting/notification_setting/';
  String get updateNotificationSetting => 'v1/vendor/account_setting/notification_setting/';
  String get accountDeleteReasonList => 'v1/vendor/delete_account_reason_list/';
  String get deleteRestaurantAccount => 'v1/vendor/account_setting/delete_account/';
  String get updateUserLocale => 'v1/vendor/account_setting/update_locale';
  // Account Setting Routes //

  // Notification Routes //
  String get notificationList => 'v1/vendor/notification_list/';
  String get readAllNotification => 'v1/vendor/read_all_notification/';
  // Notification Routes //
}
