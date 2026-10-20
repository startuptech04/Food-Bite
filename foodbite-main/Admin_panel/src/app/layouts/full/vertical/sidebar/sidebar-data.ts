import { NavItem } from './nav-item/nav-item';

export const navItems: NavItem[] = [
  {
    navCap: 'home',
  },
  {
    displayName: 'dashboard',
    iconName: 'tablerChartPie2',
    route: '/admin/dashboards',
  },
  {
    displayName: 'pos',
    iconName: 'tablerApps',
    route: '/admin/dashboards/pos',
  },
  {
    navCap: 'restaurant_management',
  },
  {
    displayName: 'zone_setup',
    iconName: 'tablerMapPin',
    route: 'admin/zone-setup',
    children: [
      {
        displayName: 'cities',
        iconName: 'tablerCornerDownRight',
        route: '/admin/zone-setup/cities'
      },
      {
        displayName: 'localities',
        iconName: 'tablerCornerDownRight',
        route: '/admin/zone-setup/localities'
      }
    ]
  },
  {
    displayName: 'cuisine',
    iconName: 'tablerRadioactive',
    route: '/admin/restaurant/cuisine',
  },
  {
    displayName: 'restaurants',
    iconName: 'tablerBuildingStore',
    route: 'admin/restaurant-management',
    children: [
      {
        displayName: 'restaurant_list',
        iconName: 'tablerCornerDownRight',
        route: '/admin/restaurant-management/restaurants'
      },
      {
        displayName: 'outlet_list',
        iconName: 'tablerCornerDownRight',
        route: '/admin/restaurant-management/outlets'
      },
      {
        displayName: 'report_issue',
        iconName: 'tablerCornerDownRight',
        route: 'admin/restaurant-management/report-issue-restaurants',
      },
      {
        displayName: 'hidden_restaurants',
        iconName: 'tablerCornerDownRight',
        route: 'admin/restaurant-management/hidden-restaurants'
      },
      {
        displayName: 'restaurant_type',
        iconName: 'tablerCornerDownRight',
        route: '/admin/restaurant-management/restaurant-type',
      },
      {
        displayName: 'restaurant_facilities',
        iconName: 'tablerCornerDownRight',
        route: '/admin/restaurant-management/restaurant-facilities',
      },
      {
        displayName: 'restaurant_waiter',
        iconName: 'tablerCornerDownRight',
        route: '/admin/restaurant-management/restaurant-waiter-list',
      },
      {
        displayName: 'restaurant_kitchen_owner',
        iconName: 'tablerCornerDownRight',
        route: '/admin/restaurant-management/restaurant-kitchen-owner-list',
      },
      {
        displayName: 'new_request',
        iconName: 'tablerCornerDownRight',
        route: '/admin/restaurant-management/restaurant-joining-request',
      },
      {
        displayName: 'filter_restaurants',
        iconName: 'tablerCornerDownRight',
        route: '/admin/restaurant-management/filter-restaurant-query'
      }
    ]
  },
  {
    navCap: 'order_management',
  },
  {
    displayName: 'order_list',
    iconName: 'tablerShoppingCartBolt',
    route: 'admin/order-management/orders-list',
  },
  {
    displayName: 'un_assigned_orders',
    iconName: 'tablerScooterElectric',
    route: 'admin/order-management/un-assigned-orders-list',
  },
  {
    displayName: 'pos_orders',
    iconName: 'tablerBrandMiniprogram',
    route: 'admin/order-management/vendors-pos-order-list',
  },
  {
    displayName: 'table_orders',
    iconName: 'tablerGridScan',
    route: 'admin/order-management/vendors-table-order-list',
  },
  {
    displayName: 'tiffin_packages',
    iconName: 'tablerPaperBag',
    route: 'admin/order-management/subscription-tiffin-package',
  },
  {
    displayName: 'subscription_orders',
    iconName: 'tablerCalendarRepeat',
    route: 'admin/order-management/subscription-tiffin-orders',
  },
  {
    displayName: 'dining_booking_list',
    iconName: 'tablerBrandAirtable',
    route: 'admin/order-management/dining-booking-list',
  },
  {
    displayName: 'refund_request',
    iconName: 'tablerReceiptRefund',
    route: 'admin/order-management/refund-request',
  },
  {
    displayName: 'order_complaints',
    iconName: 'tablerMoodSad',
    route: 'admin/order-management/order-complaints',
  },
  {
    navCap: 'business_setup',
  },
  {
    displayName: 'business_setup',
    iconName: 'tablerAdjustments',
    route: 'admin/bussiness-setup',
  },
  {
    displayName: 'system_settings',
    iconName: 'tablerBinaryTree',
    route: 'admin/system-settings',
  },
  {
    displayName: 'email_templates',
    iconName: 'tablerMailCog',
    route: 'admin/system-settings/email-templates/',
  },
  {
    displayName: 'payment_settings',
    iconName: 'tablerCreditCard',
    route: 'admin/system-settings/payment-settings/',
  },
  {
    displayName: 'subscriptions',
    iconName: 'tablerCrown',
    route: 'admin/subscriptions-management',
    children: [
      {
        displayName: 'subscription_packages',
        iconName: 'tablerCornerDownRight',
        route: '/admin/subscriptions-management/subscriptions'
      },
      {
        displayName: 'subscriber_list',
        iconName: 'tablerCornerDownRight',
        route: '/admin/subscriptions-management/subscribers-list'
      },
    ]
  },
  {
    displayName: 'project_pages',
    iconName: 'tablerFileDescription',
    route: 'admin/project-pages/pages',
  },
  {
    displayName: 'cron_scheduler',
    iconName: 'tablerTimelineEventText',
    route: 'admin/bussiness-setup/cron-job-scheduler',
  },
  {
    displayName: 'joining_form',
    iconName: 'tablerLinkPlus',
    route: 'admin/bussiness-setup/joining-form-setup',
  },
  {
    navCap: 'food_management',
  },
  {
    displayName: 'categories',
    iconName: 'tablerCategory2',
    route: 'admin/food-management',
    children: [
      {
        displayName: 'category',
        iconName: 'tablerCornerDownRight',
        route: '/admin/food-management/categories'
      },
      {
        displayName: 'sub_category',
        iconName: 'tablerCornerDownRight',
        route: '/admin/food-management/sub-categories'
      }
    ]
  },
  {
    displayName: 'foods',
    iconName: 'tablerToolsKitchen2',
    route: '/admin/foods/list',
  },
  {
    displayName: 'addons',
    iconName: 'tablerPepper',
    route: '/admin/foods/addons',
  },
  {
    displayName: 'food_taxation',
    iconName: 'tablerPercentage',
    route: '/admin/foods/food-taxation-list',
  },
  {
    navCap: 'delivery_management'
  },
  {
    displayName: 'vehicles',
    iconName: 'tablerMoped',
    route: '/admin/delivery-management/vehicles'
  },
  {
    displayName: 'shift_schedule',
    iconName: 'tablerClock',
    route: '/admin/delivery-management/delivery-shift-schedule'
  },
  {
    displayName: 'deliveryman',
    iconName: 'tablerRun',
    route: 'admin/driver-management',
    children: [
      {
        displayName: 'deliveryman_list',
        iconName: 'tablerCornerDownRight',
        route: '/admin/driver-management/delivery-partners'
      },
      {
        displayName: 'add_fund',
        iconName: 'tablerCornerDownRight',
        route: '/admin/driver-management/wallet-add-fund'
      },
      {
        displayName: 'new_request',
        iconName: 'tablerCornerDownRight',
        route: '/admin/driver-management/deliveryman-joining-request'
      },
    ]
  },
  {
    navCap: 'customer_management'
  },
  {
    displayName: 'customers',
    iconName: 'tablerUsers',
    route: '/admin/customer-management/customers'
  },
  {
    displayName: 'wallet',
    iconName: 'tablerWallet',
    route: 'admin/customer-wallet-management',
    children: [
      {
        displayName: 'add_fund',
        iconName: 'tablerCornerDownRight',
        route: '/admin/customer-wallet-management/wallet-add-fund'
      },
      {
        displayName: 'wallet_bonus',
        iconName: 'tablerCornerDownRight',
        route: '/admin/customer-wallet-management/wallet-bonus'
      },
    ]
  },
  {
    displayName: 'loyalty_point_report',
    iconName: 'tablerCertificate',
    route: '/admin/customer-management/loyalty-points-report'
  },
  {
    displayName: 'deleted_accounts',
    iconName: 'tablerUserX',
    route: 'admin/deleted-accounts',
    children: [
      {
        displayName: 'customer_accounts',
        iconName: 'tablerCornerDownRight',
        route: '/admin/deleted-accounts/customer-deleted-account'
      },
      {
        displayName: 'restaurant_accounts',
        iconName: 'tablerCornerDownRight',
        route: '/admin/deleted-accounts/restaurant-deleted-account'
      },
      {
        displayName: 'deliveryman_accounts',
        iconName: 'tablerCornerDownRight',
        route: '/admin/deleted-accounts/deliveryman-deleted-account'
      },
      {
        displayName: 'waiter_accounts',
        iconName: 'tablerCornerDownRight',
        route: '/admin/deleted-accounts/waiter-deleted-account'
      },
      {
        displayName: 'kitchen_owner_accounts',
        iconName: 'tablerCornerDownRight',
        route: '/admin/deleted-accounts/kitchen-deleted-accounts'
      },
    ]
  },
  {
    displayName: 'chat',
    iconName: 'tablerBrandHipchat',
    route: '/admin/customer-management/chat-list'
  },
  {
    navCap: 'feedback_management',
  },
  {
    displayName: 'feedback',
    iconName: 'tablerFileAnalytics',
    route: '/admin/feedback-report-list/feedback-list'
  },
  {
    displayName: 'report_emergency',
    iconName: 'tablerPackageImport',
    route: '/admin/feedback-report-list/report-emergency'
  },
  {
    navCap: 'promo_management',
  },
  {
    displayName: 'campaigns',
    iconName: 'tablerSpeakerphone',
    route: 'admin/promotion-management',
    children: [
      {
        displayName: 'restaurant_campaign',
        iconName: 'tablerCornerDownRight',
        route: '/admin/promotion-management/restaurant-campaign'
      },
      {
        displayName: 'dining_campaign',
        iconName: 'tablerCornerDownRight',
        route: '/admin/promotion-management/dining-campaign'
      },
      {
        displayName: 'food_campaign',
        iconName: 'tablerCornerDownRight',
        route: '/admin/promotion-management/food-campaign'
      },
      {
        displayName: 'notification',
        iconName: 'tablerBellRinging2',
        route: '/admin/promotion-management/notifications'
      },
    ]
  },
  {
    displayName: 'coupons',
    iconName: 'tablerTicket',
    route: '/admin/coupons/coupon-list'
  },
  {
    displayName: 'banners',
    iconName: 'tablerFlag3',
    route: '/admin/banners/banner-list'
  },
  {
    displayName: 'media',
    iconName: 'tablerPhotoSearch',
    route: '/admin/media'
  },
  {
    navCap: 'transaction_management',
  },
  {
    displayName: 'collect_cash',
    iconName: 'tablerWallet',
    route: '/admin/transaction/collection-cash'
  },
  {
    displayName: 'restaurant_withdraws',
    iconName: 'tablerReceipt2',
    route: '/admin/transaction/restaurant-withdraws'
  },
  {
    displayName: 'deliveryman_withdraws',
    iconName: 'tablerBike',
    route: '/admin/transaction/deliveryman-withdraws'
  },
  {
    displayName: 'withdrawal_methods',
    iconName: 'tablerPigMoney',
    route: '/admin/transaction/withdrawal-methods'
  },
  {
    displayName: 'disbursements',
    iconName: 'tablerAdjustmentsDollar',
    route: 'admin/disbursements-transaction',
    children: [
      {
        displayName: 'restaurant',
        iconName: 'tablerCornerDownRight',
        route: '/admin/disbursements-transaction/restaurant-disbursements'
      },
      {
        displayName: 'deliveryman',
        iconName: 'tablerCornerDownRight',
        route: '/admin/disbursements-transaction/deliveryman-disbursements'
      },
    ]
  },
  {
    navCap: 'report_management',
  },
  {
    displayName: 'expense_report',
    iconName: 'tablerMessageDollar',
    route: '/admin/reports/admin-expenses-report'
  },
  {
    displayName: 'order_report',
    iconName: 'tablerClipboardText',
    route: 'admin/order-reports',
    children: [
      {
        displayName: 'regular_order_report',
        iconName: 'tablerCornerDownRight',
        route: '/admin/order-reports/regular-order-report'
      },
      {
        displayName: 'pos_order_report',
        iconName: 'tablerCornerDownRight',
        route: '/admin/order-reports/pos-order-report'
      },
      {
        displayName: 'table_order_report',
        iconName: 'tablerCornerDownRight',
        route: '/admin/order-reports/table-order-report'
      },
    ]
  },
  {
    displayName: 'wallet_report',
    iconName: 'tablerWallpaper',
    route: '/admin/reports/wallet-transaction-report'
  },
  {
    displayName: 'payment_report',
    iconName: 'tablerMicrowave',
    route: '/admin/reports/payment-transaction-report'
  },
  {
    displayName: 'dining_booking_report',
    iconName: 'tablerMichelinStarGreen',
    route: '/admin/reports/dining-booking-report'
  },
  {
    displayName: 'food_report',
    iconName: 'tablerBurger',
    route: '/admin/reports/food-report'
  },
  {
    displayName: 'restaurant_report',
    iconName: 'tablerBuildingBank',
    route: '/admin/reports/restaurant-report'
  },
  {
    displayName: 'customer_report',
    iconName: 'tablerUserScan',
    route: '/admin/reports/customer-report'
  },
  {
    displayName: 'deliveryman_report',
    iconName: 'tablerMoped',
    route: '/admin/reports/deliveryman-report'
  },
  {
    displayName: 'disbursement_report',
    iconName: 'tablerCashBanknote',
    route: 'admin/disbursement-reports',
    children: [
      {
        displayName: 'restaurant',
        iconName: 'tablerCornerDownRight',
        route: '/admin/disbursement-reports/restaurant-disbursement-report'
      },
      {
        displayName: 'deliveryman',
        iconName: 'tablerCornerDownRight',
        route: '/admin/disbursement-reports/deliveryman-disbursement-report'
      },
    ]
  },
  {
    navCap: 'role_management',
  },
  {
    displayName: 'admin_team',
    iconName: 'tablerChessKing',
    route: '/admin/team-list/admin-team-list'
  },
  {
    displayName: 'accountant_team',
    iconName: 'tablerAddressBook',
    route: '/admin/team-list/accountant-team-list'
  },
  {
    displayName: 'cityzen_team',
    iconName: 'tablerUserPin',
    route: '/admin/team-list/cityzen-team-list'
  },
  {
    displayName: 'support_team',
    iconName: 'tablerHeadset',
    route: '/admin/team-list/support-team-list'
  },
];
