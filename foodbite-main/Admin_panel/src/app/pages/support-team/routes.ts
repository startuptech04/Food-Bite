import { Routes } from '@angular/router';
import { SupportTeamDashboard } from './support-team-dashboard/support-team-dashboard';
import { SupportTeamCustomerList } from './support-team-customer-list/support-team-customer-list';
import { SupportTeamRestaurantList } from './support-team-restaurant-list/support-team-restaurant-list';
import { SupportTeamDeliverymanList } from './support-team-deliveryman-list/support-team-deliveryman-list';
import { SupportTeamChatList } from './support-team-chat-list/support-team-chat-list';
import { SupportChatMessageWidget } from './support-chat-message-widget/support-chat-message-widget';
import { SupportTeamCustomerOrderDetail } from './support-team-customer-order-detail/support-team-customer-order-detail';
import { SupportTeamCustomerDiningDetail } from './support-team-customer-dining-detail/support-team-customer-dining-detail';
import { SupportTeamCustomerTiffinSubscriptionDetail } from './support-team-customer-tiffin-subscription-detail/support-team-customer-tiffin-subscription-detail';
import { SupportTeamProfileSetting } from './support-team-profile-setting/support-team-profile-setting';

export const SupportManagementRoutes: Routes = [
  {
    path: '',
    component: SupportTeamDashboard,
    data: {
      title: 'dashboard'
    }
  },
  {
    path: 'customer',
    component: SupportTeamCustomerList,
    data: {
      title: 'customers'
    }
  },
  {
    path: 'restaurants',
    component: SupportTeamRestaurantList,
    data: {
      title: 'restaurants'
    }
  },
  {
    path: 'deliveryman',
    component: SupportTeamDeliverymanList,
    data: {
      title: 'deliveryman'
    }
  },
  {
    path: 'chat-list',
    component: SupportTeamChatList,
    data: {
      title: 'chat_list'
    }
  },
  {
    path: 'message/:id',
    component: SupportChatMessageWidget,
    data: {
      title: 'messages'
    }
  },
  {
    path: 'order-detail/:id',
    component: SupportTeamCustomerOrderDetail,
    data: {
      title: 'order_detail'
    }
  },
  {
    path: 'dining-booking/:id',
    component: SupportTeamCustomerDiningDetail,
    data: {
      title: 'dining_booking_detail'
    }
  },
  {
    path: 'tiffin-purchase-detail/:id',
    component: SupportTeamCustomerTiffinSubscriptionDetail,
    data: {
      title: 'tiffin_subscription_detail'
    }
  },
  {
    path: 'profile-setting',
    component: SupportTeamProfileSetting,
    data: {
      title: 'profile_setting'
    }
  }
];
